# MAD Inclass 14: Firebase Cloud
## Project Overview

## Test Cases
| Test | Expected handler | Observed Result | Status | Evidence |
|------|------------------|-----------------|-----|----------|
| T1 | `onMessage` | Pending device test | Pending | Screenshot 1 |
| T2 | `onMessageOpenedApp` | Pending device test | Pending | Screenshot 2 |
| T3 | `getInitialMessage()` | Pending device test | Pending | Screenshot 3 |
| T4 | Payload validation | Pending device test | Pending | Screenshot 4 |

## Critical Thinking Questions
1. Lifecycle Prediction
    What happens when a notification arrives while the app is foregrounded, backgrounded, or terminated?
    - 
2. Payload Validation
    What should happen if the notification contains an unsupported image name?
    - 
3. Evidence and Reliability
    Why is it important to test all three application states?
    - 

## Reflection

## Technology Stack
* **Language(s):** Dart
* **Frontend:** Flutter
* **Backend/Application Logic:** Dart and Firebase Cloud Messaging service logic
* **Cloud Services:** Firebase Cloud Messaging (FCM) for receiving and handling push notifications; Firebase Core for connecting the Flutter application to Firebase
* **Build Platform:** Android

## System Architecture
The application follows a client-side architecture with Firebase cloud messaging integration. The Flutter frontend handles the user interface and displays notification content. The FCMService manages Firebase Messaging operations, including receiving foreground messages, handling notification taps, validating incoming data, and communicating notification information to the interface.

Firebase provides the cloud messaging infrastructure responsible for delivering notifications to the registered application installation. Custom notification data determines which supported image is displayed and what action the application performs. The application supports foreground, background, and terminated notification interactions through the appropriate Firebase Messaging handlers.