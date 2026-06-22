/// Constants are must be define here
abstract class AppConstant {
  static const int otpTextLength = 6;
  static const int encryptionLength = 16;
  static const String android = "android";
  static const String ios = "ios";
  static const String web = "web";
  static const double smallDeviceHeight = 800;
  static const double webPixelWidth = 1200;
  static const double mobilePixelWidth = 600;
  static const String en ="en";
  static const String hi ="hi";
  static const String updateApp = "force_update_maintainance_config";
  static const String sentryUserId = "user.name";
  static const String sentryUserEmail = "user.name@brainvire.com";
  static const String playStoreURL = "https://play.google.com/store/apps/details?id=";
  static const String appstoreURL = "https://apps.apple.com/app/";
  static const String appId = "";
  static const String stage = "stage";
  static const String prod = "prod";
}

///notification constants
abstract class NotificationConst {
  static const String channelGroupKey = 'basic_channel_group';
  static const String channelGroupName = 'Basic group';
  static const String channelKey = 'basic_channel';
  static const String channelName = 'Basic notifications';
  static const String channelDescription =
      'Notification channel for basic tests';
}

///API constants
abstract class ApiConst {
  static const String cacheArgument = "cache";
  static const String cacheDurationArgument = "validate_time";
  static const int defaultCacheTime = 30;
  static const int count14 = 14;
  static const String page = '_page';
  static const String limit = '_limit';
}

///Sentry constants
abstract class SentryConst{
  static const String response = 'response';
}
