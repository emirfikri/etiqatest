
# To-Do List (Flutter App) by Emir Fikri

➤ The app’s state management, navigation & dependencies management is rely on [Bloc Package](https://pub.dev/packages/bloc) and [sqflite] (https://pub.dev/packages/sqflite) for Android/IOS ,[Shared Preferences](https://pub.dev/packages/shared_preferences) for local storage (saving session on web).


## Screenshots

![New Microsoft PowerPoint Presentation](https://user-images.githubusercontent.com/76787324/204736264-1e0c84d9-5fa0-46da-81ec-3c273b2cf78f.jpg)


## Demo

- [Watch app demo on YouTube](https://youtu.be/pkyvh2KHcHk)
- [View Demo on Flutter Web](https://emirfikri.github.io/)
- [Download APK](https://1drv.ms/u/s!Atd0aLPih2vGgP5b3ibtiwZuYgk1iA?e=cvc2Ea)


## Key Features
Auth
 - Login user
 - Register as new user
 - Using FirebaseAuthentication  
 - Responsive Authentication page 
To-Do app
 - Create To-Do
 - Edit To-Do
 - Delete To-Do
 - Mark To-Do as Complete 

Features 
 - Animation builder when new task is created on simultaneous device
 - Using firestore realtime services
 - Include simple notification (for Android only)
 - Popup notification when using different devices 
    for making changes and delete To-Do items
 - Simple Profile page
 - Include StreamSubscription to listen for changes and notified.    

Simple validations:
To-Do
- Title must not be empty
- Start date must be smaller than or equal to end date
- End Date must be larger than or equal to start date

Auth
- Email must be valid (Regex pattern)
- Username and password must not be empty
- Login will be using username and password
 


## Project Architecture
- [Bloc Pattern](https://github.com/felangel/bloc/tree/master/examples)
- Project Structure:
```bash
├── lib
│   ├── blocs (Controller / Business logic)
│   ├── configs (firebase configs, Notifications)
│   ├── cubit 
│   ├── database (saving user session in web/mobile)
│   ├── helpers (styling, reusable constants)
│   ├── models (data models - user, todo)
│   ├── repositories (repository to access datamodels in firebase / auth)
│   ├── screens (Screens UI for each page)
│   └── widgets (global widgets / reusable widgets)
│     
└── test
```
## Unit Test

- Simple unit tests are created
- To execute all the unit tests, run
```bash
flutter test   
```



## Setup Project
- Clone repository
```bash
git clone https://github.com/emirfikri/etiqatest.git
```

- To run the app, simply write
```bash
flutter pub get  
```
```bash
flutter run (Tested working on Android / IOS / Web) (emulator only)
```
# etiqa

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
