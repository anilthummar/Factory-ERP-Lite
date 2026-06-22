# factory_erp_lite

A new Flutter project.

Getting Started
This project is a starting point for a Flutter application.

Flutter Version: 3.24.0-0.2-pre

**Instruction for Flutter**

We have 2 different environment file

1. STAGE (helps to connect with stage server)
   "--dart-define-from-file=stage_env.json"

2. PRODUCTION (helps to connect with production server)
   "--dart-define-from-file=prod_env.json"
   
**Flavors for Android**

We have 2 different flavors

1. STAGE
   "--flavor stage"

2. PRODUCTION
   "--flavor prod"

**Flavors for IOS**

We have 2 different flavors

1. STAGE
   "--flavor Stage"

2. PRODUCTION
   "--flavor Prod"

**Notification Payload**

ex.

```json
{
   "message": {
      "topic": "TEST_TOPIC",
      "apns": {
         "headers": {
            "apns-priority": "10"
         },
         "payload": {
            "aps": {
               "alert": {
                  "title": "Title of the notification",
                  "body": "Body of the notification"
               },
               "content-available": 1,
               "sound": "default"
            }
         }
      },
      "data": {
         "title": "Title of the notification",
         "body": "Body of the notification",
         "image": "Image url of the notification"
      }
   }
}
```

**Force Update**

ex.

```json
{
  "force_update": {
    "android_max_version": "1.0.5",
    "android_min_version": "1.0.3",
    "ios_max_version": "1.0.7",
    "ios_min_version": "1.0.3",
    "force_update_msg": "We Recommends that you update to the latest version. To access new feature and better experience."
  },
  "under_maintainance": {
    "is_maintainance_mode_enable": false,
    "maintainance_title": "Under Maintenance",
    "maintainance_description": "We're are improving our app. We will come back soon with new cool features.",
    "maintainance_image": "https://picsum.photos/id/237/200/300",
    "maintainance_priority": 1
  }
}
```

"maintainance_priority": 1 (Maintenance Text), 2 (Maintenance Image)

**Build command**

**Android**

1. STAGE
   "flutter build apk --release --flavor stage --dart-define-from-file=stage_env.json"

2. PRODUCTION
   "flutter build apk --release --flavor prod --dart-define-from-file=prod_env.json"

**IOS**

1. STAGE
   "flutter build ios --release --flavor Stage --dart-define-from-file=stage_env.json"

2. PRODUCTION
   "flutter build ios --release --flavor Prod --dart-define-from-file=prod_env.json"

**Web**

1. STAGE
   "flutter build web --release --dart-define-from-file=stage_env.json --web-renderer auto"

2. PRODUCTION
   "flutter build web --release --dart-define-from-file=prod_env.json --web-renderer auto"

**API Cache**

we have implemented caching for API requests.

To enable caching, set the needToCache argument to true.

If you want to customize the cache duration, pass the desired duration in minutes using the cacheDurationMnt argument.

caching is only available for GET and POST requests, for more reference check "tab_one_repository_impl.dart" file.

**Note**

1. For the firebase services you have to create the account in the firebase and add the
   google-services.json file according to flavour in the android/app folder and
   GoogleService-Info.plist file in the ios/Runner folder.
2. According to your firebase account you have to update "stage_env.json" and "prod_env.json" file
   with the respective keys.
3. For the sentry you have to create the account in the sentry and update the dsn key in the "stage_env.json" and "prod_env.json" file.



dart run build_runner build --delete-conflicting-outputs