# QR Scanner

A free QR Scanner for all.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Setup

To install packages:
```bash
flutter pub get
```

To run the app:
```bash
flutter run
```
- flags
  - `-d` run in specific devices (use the `flutter devices` to see available devices)

These are commands used for setup of application e.g. Splash Screen, Launcher Icon

### Splash Screen
- [Flutter Native Splash](https://pub.dev/packages/flutter_native_splash)

After setting up the configuration, apply the config to the app (android or ios)
```bash
dart run flutter_native_splash:create
```
- flags
  - `--path` path to file e.g. `assets/logo.png`

### Launcher Icon
- [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons)

Generate config file:
```bash
dart run flutter_launcher_icons:generate
```

After setting up the configuration, apply the config to the app (android or ios)
```bash
dart run flutter_launcher_icons
```
- flags
  - `-f` file name (make sure it is in same directory as pubspec.yaml)
