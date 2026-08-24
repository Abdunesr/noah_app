import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Login & Signup
      'Welcome back': 'Welcome back',
      'Manage your assets with confidence':
          'Manage your assets with confidence',
      'Email Address': 'Email Address',
      'Password': 'Password',
      'Forgot Password?': 'Forgot Password?',
      'Sign In': 'Sign In',
      'Please fill out all fields': 'Please fill out all fields',
      'Incorrect credential': 'Incorrect credential',
      'Create Account': 'Create Account',
      'Join Estate Flow to manage your properties with ease':
          'Join Estate Flow to manage properties with ease',
      'FULL NAME': 'FULL NAME',
      'EMAIL ADDRESS': 'EMAIL ADDRESS',
      'PHONE NUMBER': 'PHONE NUMBER',
      'PASSWORD': 'PASSWORD',
      'I agree to the ': 'I agree to the ',
      'Terms & Conditions': 'Terms & Conditions',
      ' and ': ' and ',
      'Privacy Policy': 'Privacy Policy',
      'Already have an account?': 'Already have an account?',
      'OR REGISTER WITH': 'OR REGISTER WITH',
      'GOOGLE': 'GOOGLE',
      'APPLE': 'APPLE',
      'Need help? Contact support ': 'Need help? Contact support ',

      // Home Screen
      'DASHBOARD': 'DASHBOARD',
      'Welcome back, ': 'Welcome back, ',
      'Unpaid Bill Amount': 'Unpaid Bill Amount',
      'Next inspection scheduled for ': 'Next inspection: ',
      'Bills & Invoices': 'Bills & Invoices',
      'View history': 'View history',
      'Water': 'Water',
      'Usage reports': 'Usage reports',
      'Parking': 'Parking',
      'Spot B-12': 'Spot B-12',
      'Maintenance': 'Maintenance',
      'New request': 'New request',
      'Marketplace': 'Marketplace',
      'Buy & sell within the community': 'Buy & sell in the community',
      'Announcements': 'Announcements',
      'Elevator maintenance on floor 4...': 'Elevator maintenance...',
      'Calendar': 'Calendar',
      'Events': 'Events',
      'Check community events': 'Check community events',

      // Profile Screen
      'Profile': 'Profile',
      'My Profile': 'My Profile',
      'Logout': 'Logout',
      'Account Settings': 'Account Settings',
      'Phone Number': 'Phone Number',
      'Status': 'Status',
      'Member Since': 'Member Since',
      'Last Active At': 'Last Active At',
      'Security': 'Security',
      'Change Password': 'Change Password',
      'Update credentials securely.': 'Update credentials securely.',
      'Sign Out Account': 'Sign Out Account',
      'Update Password': 'Update Password',
      'Please enter your current and new passwords below.':
          'Enter passwords below.',
      'Current Password': 'Current Password',
      'Enter current password': 'Enter current password',
      'Please enter your current password': 'Enter current password',
      'New Password': 'New Password',
      'Minimum 8 characters': 'Min 8 chars',
      'Please enter a new password': 'Enter new password',
      'Password must be at least 8 characters': 'Min 8 characters required',
      'Confirm Password': 'Confirm Password',
      'Retype new password': 'Retype new password',
      'Please confirm your password': 'Confirm password',
      'Passwords do not match': 'Passwords do not match',
      'Cancel': 'Cancel',
      'Save': 'Save',
      'Success': 'Success',
      'Password updated successfully. 🎉': 'Password updated! 🎉',
      'Error': 'Error',
      'Failed to update password': 'Failed to update password',
      'Phone': 'Phone',
      'Joined': 'Joined',
      'Last Active': 'Last Active',
      'Resident • Apt 402-B': 'Resident • Apt 402-B',
      'Select Language': 'Select Language',

      // Forgot Password Screen
      'Forgot Password': 'Forgot Password',
      'Enter your email to receive recovery link':
          'Enter email for recovery link',
      'Enter your email address': 'Enter your email address',
      'Send Reset Link': 'Send Reset Link',
      'Remember your password? ': 'Remember password? ',
      'Please enter your email address': 'Enter your email address',
      'Recovery link sent to ': 'Reset link sent to ',

      // Bills Screen
      'Current Month': 'Current Month',
      'Total Due': 'Total Due',
      'Unpaid': 'Unpaid',
      'Due Date: ': 'Due Date: ',
      'Pay Now': 'Pay Now',
      'Auto-pay': 'Auto-pay',
      'Disabled': 'Disabled',
      'Invoices': 'Invoices',
      '12 Annual': '12 Annual',
      'Bill History': 'Bill History',
      'Filter ': 'Filter ',
      'Pending': 'Pending',
      'Paid': 'Paid',
      'Rent + Utilities': 'Rent + Utilities',

      // Announcements Screen
      'Featured': 'Featured',
      'No announcements available': 'No announcements available',
      'UPCOMING EVENT': 'UPCOMING EVENT',
      'PINNED': 'PINNED',
      'Latest Updates': 'Latest Updates',
      'Show Less': 'Show Less',
      'View All': 'View All',
      'No announcements': 'No announcements',
      'Published ': 'Published ',
      'Posted by': 'Posted by',
      'Close': 'Close',
      'Retry': 'Retry',
      'Error loading announcements: ': 'Error: ',

      // Parking Screen
      'Estate Flow': 'Estate Flow',
      'TOTAL AVAILABILITY': 'TOTAL AVAILABILITY',
      'spaces': 'spaces',
      'Real-time parking availability across all building levels.':
          'Real-time parking status.',
      'Search locations...': 'Search locations...',
      'Parking Locations': 'Parking Locations',
      'View Map': 'View Map',
      'No parking spots found.': 'No parking spots found.',
      'Avg. Stay': 'Avg. Stay',
      'Dues': 'Dues',
      'Scan QR': 'Scan QR',
      'Scan Successful': 'Scan Successful',
      'Validation Failed': 'Validation Failed',
      'Done': 'Done',
      'Payments': 'Payments',
      'Home': 'Home',
    },
    'am': {
      // Login & Signup
      'Welcome back': 'እንኳን ደህና መጡ',
      'Manage your assets with confidence': 'ንብረቶችዎን በልበ ሙሉነት ያስተዳድሩ',
      'Email Address': 'የኢሜል አድራሻ',
      'Password': 'የይለፍ ቃል',
      'Forgot Password?': 'የይለፍ ቃል ረስተዋል?',
      'Sign In': 'ግባ',
      'Please fill out all fields': 'እባክዎን ሁሉንም ይሙሉ',
      'Incorrect credential': 'የተሳሳተ መለያ',
      'Create Account': 'መለያ ፍጠር',
      'Join Estate Flow to manage your properties with ease':
          'መኖሪያዎን በቀላሉ ለማስተዳደር ይቀላቀሉ',
      'FULL NAME': 'ሙሉ ስም',
      'EMAIL ADDRESS': 'የኢሜል አድራሻ',
      'PHONE NUMBER': 'የስልክ ቁጥር',
      'PASSWORD': 'የይለፍ ቃል',
      'I agree to the ': 'እስማማለሁ በ ',
      'Terms & Conditions': 'ውሎች እና ሁኔታዎች',
      ' and ': ' እና ',
      'Privacy Policy': 'የግላዊነት ፖሊሲ',
      'Already have an account?': 'መለያ አለዎት?',
      'OR REGISTER WITH': 'በዚህ ይመዝገቡ',
      'GOOGLE': 'GOOGLE',
      'APPLE': 'APPLE',
      'Need help? Contact support ': 'እርዳታ፡ ድጋፍ ያግኙ ',

      // Home Screen
      'DASHBOARD': 'ዳሽቦርድ',
      'Welcome back, ': 'እንኳን ደህና መጡ፣ ',
      'Unpaid Bill Amount': 'ያልተከፈለ ክፍያ',
      'Next inspection scheduled for ': 'ቀጣይ ፍተሻ፡ ',
      'Bills & Invoices': 'ክፍያዎች',
      'View history': 'ታሪክ ይመልከቱ',
      'Water': 'ውሃ',
      'Usage reports': 'አጠቃቀም',
      'Parking': 'ማቆሚያ',
      'Spot B-12': 'ቦታ B-12',
      'Maintenance': 'ጥገና',
      'New request': 'አዲስ ጥያቄ',
      'Marketplace': 'ገበያ',
      'Buy & sell within the community': 'በማህበረሰቡ ውስጥ ይግዙ እና ይሸጡ',
      'Announcements': 'ማስታወቂያ',
      'Elevator maintenance on floor 4...': 'የሊፍት ጥገና...',
      'Calendar': 'ቀን መቁጠሪያ',
      'Events': 'ክስተቶች',
      'Check community events': 'ክስተቶችን ይመልከቱ',

      // Profile Screen
      'Profile': 'መገለጫ',
      'My Profile': 'መገለጫዬ',
      'Logout': 'ውጣ',
      'Account Settings': 'የመለያ ቅንብር',
      'Phone Number': 'የስልክ ቁጥር',
      'Status': 'ሁኔታ',
      'Member Since': 'አባል የሆኑት',
      'Last Active At': 'የመጨረሻ ተሳትፎ',
      'Security': 'ደህንነት',
      'Change Password': 'የይለፍ ቃል ቀይር',
      'Update credentials securely.': 'ደህንነቱ በተጠበቀ ሁኔታ ይቀይሩ',
      'Sign Out Account': 'መለያ አውጣ',
      'Update Password': 'ይለፍ ቃል ማደሻ',
      'Please enter your current and new passwords below.': 'ያለውንና አዲሱን ያስገቡ',
      'Current Password': 'ያለው ይለፍ ቃል',
      'Enter current password': 'ያለውን ይለፍ ቃል ያስገቡ',
      'Please enter your current password': 'ያለውን ይለፍ ቃል ያስገቡ',
      'New Password': 'አዲስ ይለፍ ቃል',
      'Minimum 8 characters': 'ቢያንስ 8 ፊደላት',
      'Please enter a new password': 'አዲስ ይለፍ ቃል ያስገቡ',
      'Password must be at least 8 characters': 'ቢያንስ 8 ፊደላት መሆን አለበት',
      'Confirm Password': 'ይለፍ ቃል አረጋግጥ',
      'Retype new password': 'በድጋሚ ይለፍ ቃል ጻፍ',
      'Please confirm your password': 'ይለፍ ቃልዎን ያረጋግጡ',
      'Passwords do not match': 'የይለፍ ቃሎች አይመሳሰሉም',
      'Cancel': 'ሰርዝ',
      'Save': 'አስቀምጥ',
      'Success': 'ተሳክቷል',
      'Password updated successfully. 🎉': 'ይለፍ ቃል ተቀይሯል! 🎉',
      'Error': 'ስህተት',
      'Failed to update password': 'ቃል መቀየር አልተሳካም',
      'Phone': 'ስልክ',
      'Joined': 'የተቀላቀሉት',
      'Last Active': 'የመጨረሻ ተሳትፎ',
      'Resident • Apt 402-B': 'ነዋሪ • አፓርትመንት 402-B',
      'Select Language': 'ቋንቋ ይምረጡ',

      // Forgot Password Screen
      'Forgot Password': 'ይለፍ ቃል መርሳት',
      'Enter your email to receive recovery link': 'ለማደሻ ኢሜልዎን ያስገቡ',
      'Enter your email address': 'ኢሜል አድራሻዎን ያስገቡ',
      'Send Reset Link': 'የማደሻ ላክ',
      'Remember your password? ': 'ይለፍ ቃል ያስታውሳሉ? ',
      'Please enter your email address': 'እባክዎን ኢሜል ያስገቡ',
      'Recovery link sent to ': 'የመመለሻ ሊንክ ተልኳል ለ ',

      // Bills Screen
      'Current Month': 'የአሁኑ ወር',
      'Total Due': 'አጠቃላይ እዳ',
      'Unpaid': 'ያልተከፈለ',
      'Due Date: ': 'መክፈያ ቀን፡ ',
      'Pay Now': 'አሁን ክፈል',
      'Auto-pay': 'ራስ-ክፍያ',
      'Disabled': 'ጠፍቷል',
      'Invoices': 'ደረሰኞች',
      '12 Annual': '12 ዓመታዊ',
      'Bill History': 'የክፍያ ታሪክ',
      'Filter ': 'አጣራ ',
      'Pending': 'በጥበቃ ላይ',
      'Paid': 'ተከፍሏል',
      'Rent + Utilities': 'ኪራይ + አገልግሎት',

      // Announcements Screen
      'Featured': 'ዋና ዋና',
      'No announcements available': 'ምንም ማስታወቂያ የለም',
      'UPCOMING EVENT': 'የሚቀጥል ኩነት',
      'PINNED': 'የተሰካ',
      'Latest Updates': 'አዳዲስ መረጃዎች',
      'Show Less': 'ቀንስ',
      'View All': 'ሁሉንም እይ',
      'No announcements': 'ምንም ማስታወቂያ የለም',
      'Published ': 'የወጣበት፡ ',
      'Posted by': 'የለጠፈው፡',
      'Close': 'ዝጋ',
      'Retry': 'ድጋሚ ሞክር',
      'Error loading announcements: ': 'ስህተት፡ ',

      // Parking Screen
      'Estate Flow': 'Estate Flow',
      'TOTAL AVAILABILITY': 'አጠቃላይ ነጻ ቦታ',
      'spaces': 'ክፍት ቦታ',
      'Real-time parking availability across all building levels.':
          'የተሽከርካሪ ማቆሚያ ሁኔታ።',
      'Search locations...': 'ቦታ ፈልግ...',
      'Parking Locations': 'የማቆሚያ ቦታዎች',
      'View Map': 'ካርታ እይ',
      'No parking spots found.': 'ምንም ቦታ አልተገኘም።',
      'Avg. Stay': 'ቆይታ ጊዜ',
      'Dues': 'ክፍያ',
      'Scan QR': 'QR አንብብ',
      'Scan Successful': 'ማንበብ ተሳክቷል',
      'Validation Failed': 'ማረጋገጥ አልተሳካም',
      'Done': 'አበቃ',
      'Home': 'ዋና ገጽ',
      'Payments': 'ክፍያዎች',
    },
    'om': {
      // Login & Signup
      'Welcome back': 'Baga nagaan',
      'Manage your assets with confidence': 'Qabeenya keessan bulchaa',
      'Email Address': 'Teessoo Imeelii',
      'Password': 'Jecha Iccitii',
      'Forgot Password?': 'Iccitii dagattanii?',
      'Sign In': 'Seeni',
      'Please fill out all fields': 'Maaloo hunda guutaa',
      'Incorrect credential': 'Galmee sobaa',
      'Create Account': 'Heechtoo uumi',
      'Join Estate Flow to manage your properties with ease':
          'Bulchiinsa qabeenyaaf makamaa',
      'FULL NAME': 'MAQAA GUUTUU',
      'EMAIL ADDRESS': 'TEESSOO IMEELII',
      'PHONE NUMBER': 'LAKK BILBILAA',
      'PASSWORD': 'JECHA ICCITII',
      'I agree to the ': 'Waliin gala ',
      'Terms & Conditions': 'Waliigaltee',
      ' and ': ' fi ',
      'Privacy Policy': 'Imaammata',
      'Already have an account?': 'Heechtoo qabduu?',
      'OR REGISTER WITH': 'KANAAN GALMAA\'I',
      'GOOGLE': 'GOOGLE',
      'APPLE': 'APPLE',
      'Need help? Contact support ': 'Gargaarsa: Deeggarsa ',

      // Home Screen
      'DASHBOARD': 'DAASHBOORDI',
      'Welcome back, ': 'Baga nagaan, ',
      'Unpaid Bill Amount': 'Kaffaltii hafe',
      'Next inspection scheduled for ': 'Gamaaggama: ',
      'Bills & Invoices': 'Kaffaltii',
      'View history': 'Seenaa ilaali',
      'Water': 'Bishaan',
      'Usage reports': 'Gabaasa',
      'Parking': 'Dhaabbata',
      'Spot B-12': 'Bakka B-12',
      'Maintenance': 'Suphaa',
      'New request': 'Gaaffii haaraa',
      'Marketplace': 'Gabaa',
      'Buy & sell within the community': 'Hawaasa keessatti bitaa',
      'Announcements': 'Beeksisa',
      'Elevator maintenance on floor 4...': 'Suphaa eeleveetaraa...',
      'Calendar': 'Kalandarii',
      'Events': 'Qophiiwwan',
      'Check community events': 'Qophiiwwan ilaali',

      // Profile Screen
      'Profile': 'Piroofayilii',
      'My Profile': 'Piroofayilii ko',
      'Logout': 'Ba\'i',
      'Account Settings': 'Sajataa Heechtoo',
      'Phone Number': 'Lakkoofsa Bilbilaa',
      'Status': 'Haala',
      'Member Since': 'Miliyoona irraa',
      'Last Active At': 'Dhumarratti kan mul\'ate',
      'Security': 'Nageenya',
      'Change Password': 'Iccitii jijjiiri',
      'Update credentials securely.': 'Iccitii nageenyaan jijjiiri',
      'Sign Out Account': 'Heechtoo baasi',
      'Update Password': 'Iccitii haaraa',
      'Please enter your current and new passwords below.':
          'Iccitii ammaa fi haaraa galchi',
      'Current Password': 'Jecha Iccitii Ammaa',
      'Enter current password': 'Iccitii ammaa galchi',
      'Please enter your current password': 'Iccitii ammaa galchi',
      'New Password': 'Jecha Iccitii Haaraa',
      'Minimum 8 characters': 'Yoo xiqqaate 8',
      'Please enter a new password': 'Iccitii haaraa galchi',
      'Password must be at least 8 characters': 'Char 8 ta\'uu qaba',
      'Confirm Password': 'Iccitii mirkaneessi',
      'Retype new password': 'Iccitii irra deebi\'i',
      'Please confirm your password': 'Iccitii kee mirkaneessi',
      'Passwords do not match': 'Iccitiin wal hin simne',
      'Cancel': 'Dhiisi',
      'Save': 'Save',
      'Success': 'Milkaa\'eera',
      'Password updated successfully. 🎉': 'Iccitiin jijjiirameera! 🎉',
      'Error': 'Dogoggora',
      'Failed to update password': 'Jijjiiruun hin danda\'amne',
      'Phone': 'Bilbila',
      'Joined': 'Kan makame',
      'Last Active': 'Kan mul\'ate',
      'Resident • Apt 402-B': 'Jiraataa • Apt 402-B',
      'Select Language': 'Afaan Filadhu',

      // Forgot Password Screen
      'Forgot Password': 'Jecha Iccitii Dagadhe',
      'Enter your email to receive recovery link': 'Immeelii deebisaa galchi',
      'Enter your email address': 'Immeelii kee galchi',
      'Send Reset Link': 'Ergaa Deebisaa Ergi',
      'Remember your password? ': 'Iccitii yaadattu? ',
      'Please enter your email address': 'Maaloo imeelii galchi',
      'Recovery link sent to ': 'Ergaan deebisaa ergameeraf ',

      // Bills Screen
      'Current Month': 'Ji\'a Ammaa',
      'Total Due': 'Kaffaltii Walii',
      'Unpaid': 'Hin Kaffalamne',
      'Due Date: ': 'Guyyaa Kaffaltii: ',
      'Pay Now': 'Amma Kaffali',
      'Auto-pay': 'Auto-pay',
      'Disabled': 'Gootameera',
      'Invoices': 'Invooyisoota',
      '12 Annual': '12 Annual',
      'Bill History': 'Seenaa Kaffaltii',
      'Filter ': 'Calali ',
      'Pending': 'Eeggamaa',
      'Paid': 'Kaffalameera',
      'Rent + Utilities': 'Rent + Utilities',

      // Announcements Screen
      'Featured': 'Filatamoo',
      'No announcements available': 'Beeksisni hin jiru',
      'UPCOMING EVENT': 'Qophii Itti Aanu',
      'PINNED': 'PINNED',
      'Latest Updates': 'Gabaasa Haaraa',
      'Show Less': 'Xiqqum ilaali',
      'View All': 'Hunda Ilaali',
      'No announcements': 'Beeksisni hin jiru',
      'Published ': 'Kan ba\'e: ',
      'Posted by': 'Kan barreesse:',
      'Close': 'Cufi',
      'Retry': 'Deebisii yaali',
      'Error loading announcements: ': 'Dogoggora: ',

      // Parking Screen
      'Estate Flow': 'Estate Flow',
      'TOTAL AVAILABILITY': 'BAKKA JIRU',
      'spaces': 'bakka',
      'Real-time parking availability across all building levels.':
          'Haala dhaabbata konkolaataa.',
      'Search locations...': 'Bakka barbaadi...',
      'Parking Locations': 'Iddoowwan Dhaabbataa',
      'View Map': 'Kaartaa Ilaali',
      'No parking spots found.': 'Bakki hin argamne.',
      'Avg. Stay': 'Turiinsa',
      'Dues': 'Kaffaltii',
      'Scan QR': 'QR Barbaadi',
      'Scan Successful': 'Milkiin dubbisame',
      'Validation Failed': 'Mirkaneessi hafe',
      'Done': 'Xumurame',
      'Home': 'Jalqabaa',
      'Payments': 'kaffaltii',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'am', 'om'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

class OromoMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const OromoMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'om';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(OromoMaterialLocalizationsDelegate old) => false;
}

class OromoCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const OromoCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'om';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(OromoCupertinoLocalizationsDelegate old) => false;
}

extension LocalizedString on BuildContext {
  String tr(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }
}
