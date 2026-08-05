import 'package:flutter/material.dart';
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
          'Join Estate Flow to manage your properties with ease',
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
      'Next inspection scheduled for Oct 24':
          'Next inspection scheduled for Oct 24',
      'Bills & Invoices': 'Bills & Invoices',
      'View history': 'View history',
      'Water': 'Water',
      'Usage reports': 'Usage reports',
      'Parking': 'Parking',
      'Spot B-12': 'Spot B-12',
      'Maintenance': 'Maintenance',
      'New request': 'New request',
      'Marketplace': 'Marketplace',
      'Buy & sell within the community': 'Buy & sell within the community',
      'Announcements': 'Announcements',
      'Elevator maintenance on floor 4...':
          'Elevator maintenance on floor 4...',
      'Calendar': 'Calendar',
      'Check community events': 'Check community events',

      // Profile Screen
      'Profile': 'Profile',
      'Logout': 'Logout',
      'Account Details': 'Account Details',
      'Phone': 'Phone',
      'Status': 'Status',
      'Joined': 'Joined',
      'Last Active': 'Last Active',
      'Resident • Apt 402-B': 'Resident • Apt 402-B',
      'Select Language': 'Select Language',
    },
    'am': {
      // Login & Signup
      'Welcome back': 'እንኳን ደህና መጡ',
      'Manage your assets with confidence': 'ንብረቶችዎን በልበ ሙሉነት ያስተዳድሩ',
      'Email Address': 'የኢሜል አድራሻ',
      'Password': 'የይለፍ ቃል',
      'Forgot Password?': 'የይለፍ ቃልዎን ረስተዋል?',
      'Sign In': 'ግባ',
      'Please fill out all fields': 'እባክዎን ሁሉንም መስኮች ይሙሉ',
      'Incorrect credential': 'የተሳሳተ መለያ',
      'Create Account': 'መለያ ፍጠር',
      'Join Estate Flow to manage your properties with ease':
          'ንብረቶቻችሁን በቀላሉ ለማስተዳደር እስቴት ፍሎውን ይቀላቀሉ',
      'FULL NAME': 'ሙሉ ስም',
      'EMAIL ADDRESS': 'የኢሜል አድራሻ',
      'PHONE NUMBER': 'የስልክ ቁጥር',
      'PASSWORD': 'የይለፍ ቃል',
      'I agree to the ': 'እስማማለሁ በ ',
      'Terms & Conditions': 'ውሎች እና ሁኔታዎች',
      ' and ': ' እና ',
      'Privacy Policy': 'የግላዊነት ፖሊሲ',
      'Already have an account?': 'ቀደም ሲል መለያ አለዎት?',
      'OR REGISTER WITH': 'ወይም በዚህ ይመዝገቡ',
      'GOOGLE': 'ጉግል',
      'APPLE': 'አፕል',
      'Need help? Contact support ': 'እርዳታ ይፈልጋሉ? ድጋፍ ያግኙ ',

      // Home Screen
      'DASHBOARD': 'ዳሽቦርድ',
      'Welcome back, ': 'እንኳን ደህና መጡ፣ ',
      'Unpaid Bill Amount': 'ያልተከፈለ የክፍያ መጠን',
      'Next inspection scheduled for Oct 24': 'ቀጣዩ ፍተሻ ጥቅምት 14 ቀን ተይዟል',
      'Bills & Invoices': 'ክፍያዎች እና ደረሰኞች',
      'View history': 'ታሪክ ይመልከቱ',
      'Water': 'ውሃ',
      'Usage reports': 'የአጠቃቀም ሪፖርቶች',
      'Parking': 'ማቆሚያ',
      'Spot B-12': 'ቦታ B-12',
      'Maintenance': 'ጥገና',
      'New request': 'አዲስ ጥያቄ',
      'Marketplace': 'ገበያ',
      'Buy & sell within the community': 'በማህበረሰቡ ውስጥ ይግዙ እና ይሸጡ',
      'Announcements': 'ማስታወቂያዎች',
      'Elevator maintenance on floor 4...': 'በፎቅ 4 ላይ የሊፍት ጥገና...',
      'Calendar': 'ቀን መቁጠሪያ',
      'Check community events': 'የማህበረሰብ ክስተቶችን ይመልከቱ',

      // Profile Screen
      'Profile': 'መገለጫ',
      'Logout': 'ውጣ',
      'Account Details': 'የመለያ ዝርዝሮች',
      'Phone': 'ስልክ',
      'Status': 'ሁኔታ',
      'Joined': 'የተመዘገቡበት',
      'Last Active': 'ለመጨረሻ ጊዜ የታየው',
      'Resident • Apt 402-B': 'ነዋሪ • አፓርትመንት 402-B',
      'Select Language': 'ቋንቋ ይምረጡ',
    },
    'om': {
      // Login & Signup
      'Welcome back': 'Baga nagaan',
      'Manage your assets with confidence': 'Qabeenya keessan  bulchaa',
      'Email Address': 'Teessoo Imeelii',
      'Password': 'Jecha Iccitii',
      'Forgot Password?': 'Fungurroo Dagattanii?',
      'Sign In': 'Seeni',
      'Please fill out all fields': 'Maaloo dirree hunda guutaa',
      'Incorrect credential': 'Galmee sobaa',
      'Create Account': 'Heechtoo Uumi',
      'Join Estate Flow to manage your properties with ease':
          'Estate Flowtti makamuun qabeenya ',
      'FULL NAME': 'MAQAA GUUTUU',
      'EMAIL ADDRESS': 'TEESSOO ',
      'PHONE NUMBER': 'LAKKOOFSA ',
      'PASSWORD': 'JECHA ',
      'I agree to the ': 'Nii walii gala ',
      'Terms & Conditions': 'Waliigaltee & Haalawwan',
      ' and ': ' fi ',
      'Privacy Policy': 'Imaammata Dhuunfamaa',
      'Already have an account?': 'Duraan heechtoo qabduu?',
      'OR REGISTER WITH': 'YKN KANHAAN GALMAA\'I',
      'GOOGLE': 'GOOGLE',
      'APPLE': 'APPLE',
      'Need help? Contact support ':
          'Gargaarsa barbaadduu? Deeggarsa qunnamaa ',

      // Home Screen
      'DASHBOARD': 'DASHBOORDI',
      'Welcome back, ': 'Baga nagaan , ',
      'Unpaid Bill Amount': 'Gatii Kaffaltii Hin Kaffalamne',
      'Next inspection scheduled for Oct 24':
          'Gamaaggamni itti aanu Onkololeessa 24tti qabameera',
      'Bills & Invoices': 'Kaffaltii & Invooyisoota',
      'View history': 'Seenaa ilaali',
      'Water': 'Bishaan',
      'Usage reports': 'Gabaasa Fayyadamaa',
      'Parking': 'Dhaabbata Konkolaataa',
      'Spot B-12': 'Bakka B-12',
      'Maintenance': 'Suphaa',
      'New request': 'Gaaffii Haaraa',
      'Marketplace': 'Gabaa',
      'Buy & sell within the community': 'Hawaasa keessatti bituu ',
      'Announcements': 'Beeksisa',
      'Elevator maintenance on floor 4...':
          'Suphaan eeleveetaraa footoo 4ffaa irratti...',
      'Calendar': 'Kalandarii',
      'Check community events': 'Qophiiwwan hawaasaa sakatta\'aa',

      // Profile Screen
      'Profile': 'Piroofayilii',
      'Logout': 'Ba\'i',
      'Account Details': 'Bal\'ina Heechtoo',
      'Phone': 'Bilbila',
      'Status': 'Haala',
      'Joined': 'Makamee',
      'Last Active': 'Dhumarratti Kan Mul\'ate',
      'Resident • Apt 402-B': 'Jiraataa • Apt 402-B',
      'Select Language': 'Afaan Filadhu',
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

extension LocalizedString on BuildContext {
  String tr(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }
}
