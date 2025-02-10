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
dart run flutter_native_splash:create --path=splash_screen.yaml
```
- flags
  - `--path` path to file e.g. `splash_screen.yaml`

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

## Building and Installing of AAB
- [Bundle Tool](https://developer.android.com/tools/bundletool)

**Notes:**
- create `tool` directory to project root and add bundletool.jar there
- `flutter devices` - run to get devices serial-id

Extract apks from bundle:
```bash
java -jar tool/bundletool-all-1.18.0.jar build-apks --bundle build/app/outputs/bundle/release/app-release.aab --output=tool/app.apks
```

Extract apks from bundle: (device specific)
```bash
java -jar tool/bundletool-all-1.18.0.jar build-apks --bundle build/app/outputs/bundle/release/app-release.aab --output=tool/app.apks --connected-device --device-id=<serial-id>
```

Extract apks from bundle: (keystore setup)
```bash
java -jar tool/bundletool-all-1.18.0.jar build-apks --bundle build/app/outputs/bundle/release/app-release.aab --output=tool/app.apks --ks=<keystore-path> --ks-pass=pass:<keystore-pass> --ks-key-alias=<key-alias> --key-pass=pass:<key-pass>
```

Extract apks from bundle: (Recommended: device specific and keystore setup)
```bash
java -jar tool/bundletool-all-1.18.0.jar build-apks --bundle build/app/outputs/bundle/release/app-release.aab --output=tool/app.apks --connected-device --device-id=<serial-id> --ks=<keystore-path> --ks-pass=pass:<keystore-pass> --ks-key-alias=<key-alias> --key-pass=pass:<key-pass>
```

Install apks from bundle:
```bash
java -jar tool/bundletool-all-1.18.0.jar install-apks --apks=tool/app.apks --device-id=<serial-id>
```
