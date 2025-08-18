import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko')
  ];

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @restoreResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase Restoration Results'**
  String get restoreResultTitle;

  /// No description provided for @restoreResultDetail.
  ///
  /// In en, this message translates to:
  /// **'Completed the execution of the restore purchase.'**
  String get restoreResultDetail;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'App ver.'**
  String get version;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'GO Back'**
  String get goBack;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @modify.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get modify;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'cash'**
  String get cash;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'card'**
  String get card;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File(PDF)'**
  String get file;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @passportRS.
  ///
  /// In en, this message translates to:
  /// **'Register/Edit Passport Image'**
  String get passportRS;

  /// No description provided for @viewPassport.
  ///
  /// In en, this message translates to:
  /// **'View passport images'**
  String get viewPassport;

  /// No description provided for @selectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select passport image'**
  String get selectTitle;

  /// No description provided for @selectContent.
  ///
  /// In en, this message translates to:
  /// **'You can choose from camera and gallery.'**
  String get selectContent;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @passportAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'There are no registered images.'**
  String get passportAlertTitle;

  /// No description provided for @passportAlertContent.
  ///
  /// In en, this message translates to:
  /// **'First, please register your passport image.'**
  String get passportAlertContent;

  /// No description provided for @incheonAirport.
  ///
  /// In en, this message translates to:
  /// **'InCheon Airport'**
  String get incheonAirport;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @favoriteDesc.
  ///
  /// In en, this message translates to:
  /// **'You can add your travel plans to your favorites.'**
  String get favoriteDesc;

  /// No description provided for @planRule.
  ///
  /// In en, this message translates to:
  /// **'Carry-on regulations'**
  String get planRule;

  /// No description provided for @byAirline.
  ///
  /// In en, this message translates to:
  /// **'By Airline(Korean)'**
  String get byAirline;

  /// No description provided for @baggage.
  ///
  /// In en, this message translates to:
  /// **'baggage regulations'**
  String get baggage;

  /// No description provided for @batteries.
  ///
  /// In en, this message translates to:
  /// **'Auxiliary batteries,electronic cigarette regulations'**
  String get batteries;

  /// No description provided for @createNewPlan.
  ///
  /// In en, this message translates to:
  /// **'Create a new trip!'**
  String get createNewPlan;

  /// No description provided for @planMainDesc.
  ///
  /// In en, this message translates to:
  /// **'Travel with ReadyGo'**
  String get planMainDesc;

  /// No description provided for @expectedMenu.
  ///
  /// In en, this message translates to:
  /// **'Expected expenses'**
  String get expectedMenu;

  /// No description provided for @expectedDesc.
  ///
  /// In en, this message translates to:
  /// **'Plan and manage your travel expenses in advance.'**
  String get expectedDesc;

  /// No description provided for @eTicketMenu.
  ///
  /// In en, this message translates to:
  /// **'E-Ticket'**
  String get eTicketMenu;

  /// No description provided for @eTicketDesc.
  ///
  /// In en, this message translates to:
  /// **'Save it instead of printing it out so you can check it easily.'**
  String get eTicketDesc;

  /// No description provided for @checkListMenu.
  ///
  /// In en, this message translates to:
  /// **'Check-List'**
  String get checkListMenu;

  /// No description provided for @checkListDesc.
  ///
  /// In en, this message translates to:
  /// **'Please add a checklist item.'**
  String get checkListDesc;

  /// No description provided for @eSimMenu.
  ///
  /// In en, this message translates to:
  /// **'e-SIM Management'**
  String get eSimMenu;

  /// No description provided for @eSimDesc.
  ///
  /// In en, this message translates to:
  /// **'You can easily check the activation code of your e-sim and check the activation time.'**
  String get eSimDesc;

  /// No description provided for @expenseMenu.
  ///
  /// In en, this message translates to:
  /// **'Travel expense management'**
  String get expenseMenu;

  /// No description provided for @expenseDesc.
  ///
  /// In en, this message translates to:
  /// **'You can record and check your travel expenses.'**
  String get expenseDesc;

  /// No description provided for @accommodationMenu.
  ///
  /// In en, this message translates to:
  /// **'Accommodation information'**
  String get accommodationMenu;

  /// No description provided for @accommodationDesc.
  ///
  /// In en, this message translates to:
  /// **'Save your reservation information and easily check it on a map.'**
  String get accommodationDesc;

  /// No description provided for @scheduleMenu.
  ///
  /// In en, this message translates to:
  /// **'Schedule management'**
  String get scheduleMenu;

  /// No description provided for @scheduleDesc.
  ///
  /// In en, this message translates to:
  /// **'Record and manage your travel itinerary in advance.'**
  String get scheduleDesc;

  /// No description provided for @titleAddPlan.
  ///
  /// In en, this message translates to:
  /// **'Add Travel Plan'**
  String get titleAddPlan;

  /// No description provided for @addNation.
  ///
  /// In en, this message translates to:
  /// **'Country to travel'**
  String get addNation;

  /// No description provided for @addTitle.
  ///
  /// In en, this message translates to:
  /// **'Title to travel'**
  String get addTitle;

  /// No description provided for @addPeriod.
  ///
  /// In en, this message translates to:
  /// **'Select to period'**
  String get addPeriod;

  /// No description provided for @addPlanHint.
  ///
  /// In en, this message translates to:
  /// **'friendship trip, family trip, city, etc.'**
  String get addPlanHint;

  /// No description provided for @visitEmptyTop.
  ///
  /// In en, this message translates to:
  /// **'When the trip ends'**
  String get visitEmptyTop;

  /// No description provided for @visitEmptyData1.
  ///
  /// In en, this message translates to:
  /// **'can check the statistics of the countries you visited.'**
  String get visitEmptyData1;

  /// No description provided for @visitEmptyData2.
  ///
  /// In en, this message translates to:
  /// **'can check the statistics of the expenses you used.'**
  String get visitEmptyData2;

  /// No description provided for @visitStatistics.
  ///
  /// In en, this message translates to:
  /// **'Visiting Country Statistics'**
  String get visitStatistics;

  /// No description provided for @costUse.
  ///
  /// In en, this message translates to:
  /// **'Cost statistics for use'**
  String get costUse;

  /// No description provided for @visitEmptyBottom.
  ///
  /// In en, this message translates to:
  /// **'The completed trip does not exist.'**
  String get visitEmptyBottom;

  /// No description provided for @cashAndCard.
  ///
  /// In en, this message translates to:
  /// **'(Cash + Card)'**
  String get cashAndCard;

  /// No description provided for @purchaseTitle1.
  ///
  /// In en, this message translates to:
  /// **'Try all your trips'**
  String get purchaseTitle1;

  /// No description provided for @purchaseTitle2.
  ///
  /// In en, this message translates to:
  /// **'with '**
  String get purchaseTitle2;

  /// No description provided for @purchaseTitle3.
  ///
  /// In en, this message translates to:
  /// **'ReadyGo.'**
  String get purchaseTitle3;

  /// No description provided for @purchaseTitle4.
  ///
  /// In en, this message translates to:
  /// **''**
  String get purchaseTitle4;

  /// No description provided for @removeAd.
  ///
  /// In en, this message translates to:
  /// **'Remove Ad'**
  String get removeAd;

  /// No description provided for @purchaseCompleted.
  ///
  /// In en, this message translates to:
  /// **'(purchase completed)'**
  String get purchaseCompleted;

  /// No description provided for @removeAdDesc.
  ///
  /// In en, this message translates to:
  /// **'You can use the app without advertising.'**
  String get removeAdDesc;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buy;

  /// No description provided for @menuExpensePlan.
  ///
  /// In en, this message translates to:
  /// **'Expense plan'**
  String get menuExpensePlan;

  /// No description provided for @menuFlightTicket.
  ///
  /// In en, this message translates to:
  /// **'Flight Ticket(e-Ticket)'**
  String get menuFlightTicket;

  /// No description provided for @menuCheckList.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get menuCheckList;

  /// No description provided for @menuRoaming.
  ///
  /// In en, this message translates to:
  /// **'Roaming (e-SIM)'**
  String get menuRoaming;

  /// No description provided for @menuSpentBudget.
  ///
  /// In en, this message translates to:
  /// **'Account book'**
  String get menuSpentBudget;

  /// No description provided for @menuAccommodation.
  ///
  /// In en, this message translates to:
  /// **'Accommodation'**
  String get menuAccommodation;

  /// No description provided for @menuSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get menuSchedule;

  /// No description provided for @planMainTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan Menu'**
  String get planMainTitle;

  /// No description provided for @createTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create Template'**
  String get createTemplate;

  /// No description provided for @expensePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense Plan'**
  String get expensePlanTitle;

  /// No description provided for @flightTicketTitle.
  ///
  /// In en, this message translates to:
  /// **'Flight Ticket'**
  String get flightTicketTitle;

  /// No description provided for @checkListTitle.
  ///
  /// In en, this message translates to:
  /// **'Check List'**
  String get checkListTitle;

  /// No description provided for @roamingTitle.
  ///
  /// In en, this message translates to:
  /// **'Roaming(e-SIM)'**
  String get roamingTitle;

  /// No description provided for @accountBookTitle.
  ///
  /// In en, this message translates to:
  /// **'Account book'**
  String get accountBookTitle;

  /// No description provided for @accommodationTitle.
  ///
  /// In en, this message translates to:
  /// **'Accommodation Info'**
  String get accommodationTitle;

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule management'**
  String get scheduleTitle;

  /// No description provided for @expensePlanDesc.
  ///
  /// In en, this message translates to:
  /// **'Plan your estimated expenses in advance.'**
  String get expensePlanDesc;

  /// No description provided for @ownCurrency.
  ///
  /// In en, this message translates to:
  /// **'Own Currency'**
  String get ownCurrency;

  /// No description provided for @foreignCurrency.
  ///
  /// In en, this message translates to:
  /// **'Foreign Currency'**
  String get foreignCurrency;

  /// No description provided for @ticketDepartureButton.
  ///
  /// In en, this message translates to:
  /// **'Select Departure Ticket File (Image)'**
  String get ticketDepartureButton;

  /// No description provided for @ticketArrivalButton.
  ///
  /// In en, this message translates to:
  /// **'Select Arrival Ticket File (Image)'**
  String get ticketArrivalButton;

  /// No description provided for @ticketDepartureDesc.
  ///
  /// In en, this message translates to:
  /// **'Please register your departure e-ticket.'**
  String get ticketDepartureDesc;

  /// No description provided for @ticketArrivalDesc.
  ///
  /// In en, this message translates to:
  /// **'Please register your arrival e-ticket.'**
  String get ticketArrivalDesc;

  /// No description provided for @templateSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Template'**
  String get templateSelect;

  /// No description provided for @addListItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addListItem;

  /// No description provided for @addTemp.
  ///
  /// In en, this message translates to:
  /// **'Add & select templates'**
  String get addTemp;

  /// No description provided for @templateDesc.
  ///
  /// In en, this message translates to:
  /// **'Please create a template.'**
  String get templateDesc;

  /// No description provided for @addTemplateItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Adding Template Item'**
  String get addTemplateItemTitle;

  /// No description provided for @addTemplateItemDesc.
  ///
  /// In en, this message translates to:
  /// **'Please add items to the new template.'**
  String get addTemplateItemDesc;

  /// No description provided for @addTemplateName.
  ///
  /// In en, this message translates to:
  /// **'Template name'**
  String get addTemplateName;

  /// No description provided for @addEsimImg.
  ///
  /// In en, this message translates to:
  /// **'Add e-SIM QR code'**
  String get addEsimImg;

  /// No description provided for @addEsimCode.
  ///
  /// In en, this message translates to:
  /// **'Add e-SIM active code'**
  String get addEsimCode;

  /// No description provided for @activeCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Code'**
  String get activeCodeTitle;

  /// No description provided for @dpAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'SM-DP Address'**
  String get dpAddressTitle;

  /// No description provided for @dpAddressDesc.
  ///
  /// In en, this message translates to:
  /// **'Please register the SM-DP Address.'**
  String get dpAddressDesc;

  /// No description provided for @activeCodeDesc.
  ///
  /// In en, this message translates to:
  /// **'Please register the Active Code.'**
  String get activeCodeDesc;

  /// No description provided for @periodEsimTitle.
  ///
  /// In en, this message translates to:
  /// **'e-sim active period'**
  String get periodEsimTitle;

  /// No description provided for @startUsing.
  ///
  /// In en, this message translates to:
  /// **'Start Using'**
  String get startUsing;

  /// No description provided for @selectPeriod.
  ///
  /// In en, this message translates to:
  /// **'Select Period'**
  String get selectPeriod;

  /// No description provided for @startUsingSnack.
  ///
  /// In en, this message translates to:
  /// **'Please select or reset the period.'**
  String get startUsingSnack;

  /// No description provided for @timeUsed.
  ///
  /// In en, this message translates to:
  /// **'Used(m)'**
  String get timeUsed;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get min;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hour;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @remainingTime.
  ///
  /// In en, this message translates to:
  /// **'Remain(m)'**
  String get remainingTime;

  /// No description provided for @codeDeleteDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete it?'**
  String get codeDeleteDesc;

  /// No description provided for @copyActiveCode.
  ///
  /// In en, this message translates to:
  /// **'The Active Code has been copied to the clipboard.'**
  String get copyActiveCode;

  /// No description provided for @copyDpAddress.
  ///
  /// In en, this message translates to:
  /// **'The SM-DP Address has been copied to the clipboard.'**
  String get copyDpAddress;

  /// No description provided for @resetPeriod.
  ///
  /// In en, this message translates to:
  /// **'Usage information has been initialized.'**
  String get resetPeriod;

  /// No description provided for @resetInfo1.
  ///
  /// In en, this message translates to:
  /// **'Reset usage information'**
  String get resetInfo1;

  /// No description provided for @resetInfo2.
  ///
  /// In en, this message translates to:
  /// **'The usage information for the set period is initialized.'**
  String get resetInfo2;

  /// No description provided for @resetInfo3.
  ///
  /// In en, this message translates to:
  /// **'Do you want to change it?'**
  String get resetInfo3;

  /// No description provided for @resetCompleted.
  ///
  /// In en, this message translates to:
  /// **'The usage information has been initialized.'**
  String get resetCompleted;

  /// No description provided for @addExpenses.
  ///
  /// In en, this message translates to:
  /// **'Add Expenses'**
  String get addExpenses;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @travelExpenses.
  ///
  /// In en, this message translates to:
  /// **'Travel Expenses'**
  String get travelExpenses;

  /// No description provided for @remainExpenses.
  ///
  /// In en, this message translates to:
  /// **'Remain Expenses'**
  String get remainExpenses;

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total cost'**
  String get totalCost;

  /// No description provided for @cashUsed.
  ///
  /// In en, this message translates to:
  /// **'Cash used'**
  String get cashUsed;

  /// No description provided for @cardUsed.
  ///
  /// In en, this message translates to:
  /// **'Card used'**
  String get cardUsed;

  /// No description provided for @accountEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Try to manage your travel expenses.'**
  String get accountEmptyTitle;

  /// No description provided for @accountEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **' registration is missing.'**
  String get accountEmptyDesc;

  /// No description provided for @amountToAdd.
  ///
  /// In en, this message translates to:
  /// **'Amount to add'**
  String get amountToAdd;

  /// No description provided for @accInfoDesc1.
  ///
  /// In en, this message translates to:
  /// **'Save the information for your stay.'**
  String get accInfoDesc1;

  /// No description provided for @accInfoDesc2.
  ///
  /// In en, this message translates to:
  /// **'Easy to savee, Easy to check!'**
  String get accInfoDesc2;

  /// No description provided for @addToInfo.
  ///
  /// In en, this message translates to:
  /// **'Enter accommodation information'**
  String get addToInfo;

  /// No description provided for @accName.
  ///
  /// In en, this message translates to:
  /// **'Accommodation Name'**
  String get accName;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @enterPeriod.
  ///
  /// In en, this message translates to:
  /// **'Accommodation Schedule'**
  String get enterPeriod;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @checkInAndCheckout.
  ///
  /// In en, this message translates to:
  /// **'Check-In & Checkout'**
  String get checkInAndCheckout;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @reservationInfo.
  ///
  /// In en, this message translates to:
  /// **'Reservation information(Option)'**
  String get reservationInfo;

  /// No description provided for @reservationApp.
  ///
  /// In en, this message translates to:
  /// **'Reservation App'**
  String get reservationApp;

  /// No description provided for @reservationNum.
  ///
  /// In en, this message translates to:
  /// **'Reservation Number'**
  String get reservationNum;

  /// No description provided for @viewMap.
  ///
  /// In en, this message translates to:
  /// **'View Map'**
  String get viewMap;

  /// No description provided for @option.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get option;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-In'**
  String get checkIn;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @copyAddress.
  ///
  /// In en, this message translates to:
  /// **'The address of the accommodation has been copied.'**
  String get copyAddress;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data.'**
  String get noData;

  /// No description provided for @addMainSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add Main Schedule'**
  String get addMainSchedule;

  /// No description provided for @scheduleEmptyDescTitle.
  ///
  /// In en, this message translates to:
  /// **'Please register your main schedule.'**
  String get scheduleEmptyDescTitle;

  /// No description provided for @scheduleEmptyDesc1.
  ///
  /// In en, this message translates to:
  /// **'After registering the main schedule'**
  String get scheduleEmptyDesc1;

  /// No description provided for @scheduleEmptyDesc2.
  ///
  /// In en, this message translates to:
  /// **'can register the detailed schedule.'**
  String get scheduleEmptyDesc2;

  /// No description provided for @addDetailSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add detailed schedule'**
  String get addDetailSchedule;

  /// No description provided for @deleteScheduleDesc.
  ///
  /// In en, this message translates to:
  /// **'Delete the schedule.'**
  String get deleteScheduleDesc;

  /// No description provided for @mainSchedule.
  ///
  /// In en, this message translates to:
  /// **'Main Schedule'**
  String get mainSchedule;

  /// No description provided for @detailAndMemo.
  ///
  /// In en, this message translates to:
  /// **'Detail schedule & Memo'**
  String get detailAndMemo;

  /// No description provided for @detailDesc1.
  ///
  /// In en, this message translates to:
  /// **'Add a detailed schedule or a brief note.'**
  String get detailDesc1;

  /// No description provided for @detailDesc2.
  ///
  /// In en, this message translates to:
  /// **''**
  String get detailDesc2;

  /// No description provided for @snackTitle.
  ///
  /// In en, this message translates to:
  /// **'Check the input information.'**
  String get snackTitle;

  /// No description provided for @snackCommonDetail.
  ///
  /// In en, this message translates to:
  /// **'Empty values cannot be saved.'**
  String get snackCommonDetail;

  /// No description provided for @snackDetail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your {item}'**
  String snackDetail(Object item);

  /// No description provided for @snackCheckScheduleTime.
  ///
  /// In en, this message translates to:
  /// **'The schedule already exists at the selected time.'**
  String get snackCheckScheduleTime;

  /// No description provided for @snackNoChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Please check what you want to modify.'**
  String get snackNoChangeTitle;

  /// No description provided for @snackNoChangeDesc.
  ///
  /// In en, this message translates to:
  /// **'Changes do not exist.'**
  String get snackNoChangeDesc;

  /// No description provided for @snackRejectAccPeriod1.
  ///
  /// In en, this message translates to:
  /// **'Cannot select a date earlier than the start date of your trip.'**
  String get snackRejectAccPeriod1;

  /// No description provided for @snackRejectAccPeriod2.
  ///
  /// In en, this message translates to:
  /// **'Cannot select a date after the end date of your trip.'**
  String get snackRejectAccPeriod2;

  /// No description provided for @snackFavoriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to add to favorites.'**
  String get snackFavoriteTitle;

  /// No description provided for @snackFavoriteDesc.
  ///
  /// In en, this message translates to:
  /// **'You can register up to two favorites.'**
  String get snackFavoriteDesc;

  /// No description provided for @snackLoadFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get snackLoadFailedTitle;

  /// No description provided for @snackLoadFailedDesc.
  ///
  /// In en, this message translates to:
  /// **'Load failed for unknown reason.'**
  String get snackLoadFailedDesc;

  /// No description provided for @snackTemplateSelectDesc.
  ///
  /// In en, this message translates to:
  /// **'Please select the template you added.'**
  String get snackTemplateSelectDesc;

  /// No description provided for @snackEmptyNation.
  ///
  /// In en, this message translates to:
  /// **'Please select your country of travel.'**
  String get snackEmptyNation;

  /// No description provided for @snackEmptySubject.
  ///
  /// In en, this message translates to:
  /// **'Please enter your title of travel.'**
  String get snackEmptySubject;

  /// No description provided for @snackEmptyPeriod.
  ///
  /// In en, this message translates to:
  /// **'Please select your period of travel.'**
  String get snackEmptyPeriod;

  /// No description provided for @snackAccommodationCopy.
  ///
  /// In en, this message translates to:
  /// **'The accommodation address has been copied to the clipboard.'**
  String get snackAccommodationCopy;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
