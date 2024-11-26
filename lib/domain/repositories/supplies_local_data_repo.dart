
mixin SuppliesLocalDataRepo {
  Future<List<Map<String, bool>>> getSuppliesList(int id);
  Future<void> addSuppliesItem(List<Map<String, bool>> item, int id);
  Future<void> removeSuppliesItem(List<Map<String, bool>> item, int id);
  Future<void> updateSuppliesItem(List<Map<String, bool>> item, int id);
}