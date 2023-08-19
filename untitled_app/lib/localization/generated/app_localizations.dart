import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('es')
  ];

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @invalidEmailTittle.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email Formating'**
  String get invalidEmailTittle;

  /// No description provided for @invalidEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Please check your email and try again.'**
  String get invalidEmailBody;

  /// No description provided for @userNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Can\'t Find Account'**
  String get userNotFoundTitle;

  /// No description provided for @userNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'We can\'t find an account with that email. Try another email, or sign up.'**
  String get userNotFoundBody;

  /// No description provided for @wrongPasswordTittle.
  ///
  /// In en, this message translates to:
  /// **'Incorrect Password'**
  String get wrongPasswordTittle;

  /// No description provided for @wrongPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'The password you entered is incorrect.'**
  String get wrongPasswordBody;

  /// No description provided for @userDisabledTittle.
  ///
  /// In en, this message translates to:
  /// **'Account Disabled'**
  String get userDisabledTittle;

  /// No description provided for @userDisabledBody.
  ///
  /// In en, this message translates to:
  /// **'Your account has been disabled. Please contact us at conetechnologiesdev@gmail.com.'**
  String get userDisabledBody;

  /// No description provided for @weakPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Weak Password'**
  String get weakPasswordTitle;

  /// No description provided for @weakPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Update your password and try again.'**
  String get weakPasswordBody;

  /// No description provided for @defaultErrorTittle.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get defaultErrorTittle;

  /// No description provided for @defaultErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Please try again later or reach out to conetechnologiesdev@gmail.com.'**
  String get defaultErrorBody;

  /// No description provided for @emailAlreadyInUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Already In-Use'**
  String get emailAlreadyInUseTitle;

  /// No description provided for @emailAlreadyInUseBody.
  ///
  /// In en, this message translates to:
  /// **'An account with that email already exists'**
  String get emailAlreadyInUseBody;

  /// No description provided for @forgotPasswordTittle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve Got Mail!'**
  String get forgotPasswordTittle;

  /// No description provided for @forgotPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Check your email for a password reset link.'**
  String get forgotPasswordBody;

  /// No description provided for @exitCreateAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Return to login'**
  String get exitCreateAccountTitle;

  /// No description provided for @exitCreateAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to go back? your information will be deleted.'**
  String get exitCreateAccountBody;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @go.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get go;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get userName;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}