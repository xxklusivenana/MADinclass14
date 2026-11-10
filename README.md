# MAD Inclass 14: Firebase Cloud
## Project Overview
This project is a Flutter application that demonstrates how to use Firebase Cloud Messaging (FCM) to send push notifications and update an app's interface. I chose the undergraduate Android implementation path, using Firebase Core to connect the app to Firebase and Firebase Messaging to receive and process notifications. The application uses two images, default.png and promo.png, to make notification-driven changes easy to see.
The point of the project is to understand how notifications behave during different application lifecycle states: foreground, background, and terminated. The notification's custom data includes an asset key, which selects the image, and an action key, which tells the app what operation to perform. I also included payload validation so unsupported values are rejected instead of causing the app to crash or display an incorrect image.

## Test Cases
| Test ID | Expected handler | Observed Result | Status | Evidence |
|---------|------------------|-----------------|-------|----------|
| T1 | `onMessage` | Pending device test | Pass | ![Screenshot 1](assets/path1) |
| T2 | `onMessageOpenedApp` | Pending device test | Pass | ![Screenshot 2](assets/path2) |
| T3 | `getInitialMessage()` | Pending device test | Pass | ![Screenshot 3](assets/path3) |
| T4 | Payload validation | Pending device test | Pass | ![Screenshot 4](assets/path4) |

## Critical Thinking Questions
1. Lifecycle Prediction<br>
    What happens when a notification arrives while the app is foregrounded, backgrounded, or terminated?
    - When the app is in the foreground, FirebaseMessaging.onMessage receives the notification and processes its data so the screen can update immediately. When the app is in the background, onBackgroundMessage handles background processing, and onMessageOpenedApp processes the notification when the user taps it. When the app is terminated, getInitialMessage() checks whether a notification opened the app and processes its data.
2. Payload Validation<br>
    What should happen if the notification contains an unsupported image name?
    - If a notification contains an unsupported image name, the application should reject the payload instead of attempting to load an image that does not exist. My _processMessage() method checks whether the asset value is either default or promo. If it is not supported, the method prints a diagnostic message and returns without changing the current image or title.
3. Evidence and Reliability<br>
    Why is it important to test all three application states?
    - Testing all three application states is important because notifications are handled differently depending on whether the app is open, running in the background, or completely terminated. Testing only the foreground state would not prove that notification taps work correctly when reopening the application. Testing each state helps identify lifecycle problems and confirms that the correct information is displayed when the user interacts with a notification.

## Reflection
**Device/Permission Information:**
* Platform: Android
* Device/Emulator: sdk gphone16k x86 64 (mobile) • emulator-5554
* Android Version: Android 17.0 ("CinnamonBun") |android-x86_64
* Notification Permission: [Granted]

**One Valid Payload:**
```
{
  "notification": {
    "title": "New promotion",
    "body": "Switch the screen to the promo asset"
  },
  "data": {
    "asset": "promo",
    "action": "update_ui"
  }
}
```

**Four Result Rows:**

| Test ID | Expected Result | Observed Result |
|---------|-----------------|-----------------|
| T1 | Notification updates the title and image while the app is open. | ![Screenshot 1](assets/path1) |
| T2 | Tapping the notification opens the app and updates the title and image. | ![Screenshot 1](assets/path2) |
| T3 | Tapping the notification launches the app and displays the promotional image and title. | ![Screenshot 1](assets/path3) |
| T4 | Unsupported asset is rejected, and the previous UI remains unchanged. | ![Screenshot 1](assets/path4) |

**Limitations:**
1. Background message processing runs separately from the main UI, so it cannot directly update Flutter widgets
2. Notifications depend on device permissions, network connectivity, and Android notification setting
3. Application only supports two predefined images and one notification action
<br>
**Setup and payload:**
One configuration decision I made was to use Firebase Cloud Messaging with the Android version of my Flutter application. I connected the application to my Firebase project using FlutterFire and used firebase_options.dart to initialize Firebase. I also chose to keep the notification logic in a separate FCMService class instead of placing all the Firebase operations directly inside the screen. This makes the code easier to organize and maintain.

My notification uses two custom data keys: asset and action. The asset key determines which image the application displays. A value of default displays the normal image, while promo displays the promotional image. The action key tells the application what operation to perform. Currently, the application accepts update_ui as its supported action. When a valid notification arrives, the service checks both values and passes them to the screen. The screen then updates its title and image using setState(). This allows the notification data to control visible parts of the application without requiring a separate screen for each notification.<br>
**Lifecycle and evidence:**
I implemented three different notification handlers to support the application's lifecycle states. For T1, FirebaseMessaging.onMessage receives notifications while the application is open. The service processes the notification data and updates the screen immediately. For T2, FirebaseMessaging.onMessageOpenedApp handles notifications that the user taps after the application has been placed in the background. For T3, getInitialMessage() checks whether a notification launched the application after it was terminated.

The background handler firebaseMessagingBackgroundHandler, is registered before runApp() and handles background messages separately from the main interface. Background processing cannot directly update Flutter widgets because it runs outside the normal UI lifecycle. Instead, the application processes the notification data when the user opens the notification and the main interface is active again. I used the four test cases to evaluate these behaviors, including screenshots or other evidence showing the notification and resulting screen for each test. Testing all three lifecycle states is important because successfully receiving a foreground notification does not guarantee that background and terminated-state interactions will work correctly.<br>
**Validation and next step:**
For T4, I used payload validation to prevent unsupported notification values from changing the application. The _processMessage() method checks whether the action is update_ui and whether the asset is either default or promo. If either value is unsupported, the method prints a diagnostic message and returns without calling the screen's update callback. This preserves the previously displayed title and image instead of attempting to load an invalid asset or crashing the application.

One risk I addressed was receiving an image name that does not match either of the bundled image files. Without validation, the application could attempt to load an incorrect asset path. I also included a mounted check before calling setState() so the application does not attempt to update a screen that is no longer active. One improvement I would make in the future is adding support for more notification actions and images while keeping the same validation process. I could also improve the status display to distinguish between successful notifications, rejected payloads, and initialization problems. This would make the application easier to troubleshoot and provide clearer feedback when something goes wrong.

## Technology Stack
* **Language(s):** Dart
* **Frontend:** Flutter
* **Backend/Application Logic:** Dart and Firebase Cloud Messaging service logic
* **Cloud Services:** Firebase Cloud Messaging (FCM) for receiving and handling push notifications; Firebase Core for connecting the Flutter application to Firebase
* **Build Platform:** Android

## System Architecture
The application follows a client-side architecture with Firebase cloud messaging integration. The Flutter frontend handles the user interface and displays notification content. The FCMService manages Firebase Messaging operations, including receiving foreground messages, handling notification taps, validating incoming data, and communicating notification information to the interface.

Firebase provides the cloud messaging infrastructure responsible for delivering notifications to the registered application installation. Custom notification data determines which supported image is displayed and what action the application performs. The application supports foreground, background, and terminated notification interactions through the appropriate Firebase Messaging handlers.