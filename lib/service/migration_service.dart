import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/data/repositories/plan_local_data_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MigrationService {
  final _planLocalDataRepo = GetIt.I.get<PlanLocalDataRepo>();
  final _logger = Logger();

  static const int _latestVersion = 2;

  Future<void> runMigrations() async {
    final prefs = await SharedPreferences.getInstance();
    int currentVersion = prefs.getInt('migrated_version') ?? 1;

    if (currentVersion >= _latestVersion) {
      _logger.i("No migration needed. Current version: $currentVersion");
      return;
    }

    _logger.i("Starting migration from version $currentVersion to $_latestVersion");

    if (currentVersion < 2) {
      await _migrateToVersion2(prefs);
    }

    await prefs.setInt('migrated_version', _latestVersion);
    _logger.i("Migration completed. New version: $_latestVersion");
  }

  Future<void> _migrateToVersion2(SharedPreferences prefs) async {
    _logger.i("Running migration to version 2: Plan ID migration");
    try {
      final planList = await _planLocalDataRepo.getLocalList();
      if (planList.isNotEmpty) {
        for (var i = 0; i < planList.length; i++) {
          final oldId = i + 1;
          final newId = planList[i].id!;
          _logger.i("Migrating plan ID: $oldId => $newId");
          await _planLocalDataRepo.planDataMigration(oldId, newId);
        }
      }
      _logger.i("Plan ID migration to version 2 completed successfully.");
    } catch (e) {
      _logger.e("Error during migration to version 2: ${e.toString()}");
      // Consider a rollback strategy or error handling
      rethrow;
    }
  }
}
