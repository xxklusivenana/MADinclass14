# MAD Inclass 14: Firebase Cloud
## Project Overview

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
    - 
2. Payload Validation<br>
    What should happen if the notification contains an unsupported image name?
    - 
3. Evidence and Reliability<br>
    Why is it important to test all three application states?
    - 

## Reflection
Device/Permission Information:<br>
One Valid Payload:<br>
Four Result Rows:<br>
Limitations:<br>

Setup and payload: Explain one configuration decision and how your two payload keys control the visible result, about 150-250 words<br>
- 
Lifecycle and evidence: Compare T1-T3 handlers and cite evidence; explain why background work cannot directly update widgets, about 150-250 words<br>
- 
Validation and next step: Explain T4's diagnostic and preserved UI, one failure/fix or risk you checked, and one justified improvement, about 150-250 words<br>
- 

## Technology Stack
* **Language(s):** Dart
* **Frontend:** Flutter
* **Backend/Application Logic:** Dart and Firebase Cloud Messaging service logic
* **Cloud Services:** Firebase Cloud Messaging (FCM) for receiving and handling push notifications; Firebase Core for connecting the Flutter application to Firebase
* **Build Platform:** Android

## System Architecture
The application follows a client-side architecture with Firebase cloud messaging integration. The Flutter frontend handles the user interface and displays notification content. The FCMService manages Firebase Messaging operations, including receiving foreground messages, handling notification taps, validating incoming data, and communicating notification information to the interface.

Firebase provides the cloud messaging infrastructure responsible for delivering notifications to the registered application installation. Custom notification data determines which supported image is displayed and what action the application performs. The application supports foreground, background, and terminated notification interactions through the appropriate Firebase Messaging handlers.