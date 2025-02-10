import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:qr_scanner/app/core/constants/constants.dart';
import 'package:qr_scanner/app/core/providers/app_settings_provider.dart';
import 'package:qr_scanner/app/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Box testBox;

  late Widget mainApp;
  setUp(() async {
    await setUpTestHive();
    testBox = await Hive.openBox(Constants.hiveBox);
    mainApp = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter().router,
      ),
    );
    SharedPreferences.setMockInitialValues(
        {Constants.settingsSaveOnDetect: false});
  });

  tearDown(() async {
    await testBox.close();
  });

  testWidgets('Navigate to Settings Screen', (WidgetTester tester) async {
    await tester.pumpWidget(mainApp);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text("Settings"), findsExactly(2));

    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    expect(find.text("Home"), findsExactly(2));

    await tester.tap(find.byIcon(Icons.qr_code_scanner));
    await tester.pumpAndSettle();
    expect(find.text("Scanner"), findsExactly(2));

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text("Settings"), findsExactly(2));
  });

  testWidgets('Prompt reset all saved QR Codes', (WidgetTester tester) async {
    await tester.pumpWidget(mainApp);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Clear Saved Data"));
    await tester.pumpAndSettle();
    expect(find.text("Reset ALL"), findsOne);
    expect(find.text("Close"), findsOne);
    expect(find.text("Reset"), findsOne);
  });

  testWidgets('Toggle save on detect checkbox', (WidgetTester tester) async {
    await tester.pumpWidget(mainApp);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    final checkboxSaveOnDetect = find.byKey(Key(Keys.checkboxSaveOnDetect));

    final checkboxCustom = find.descendant(
        of: checkboxSaveOnDetect,
        matching: find.byKey(Key(Keys.checkboxCustom)));

    expect(checkboxCustom, findsOne);
    await tester.pump();
    expect(tester.widget<Checkbox>(checkboxCustom).value, false);

    await tester.tap(checkboxCustom);
    await tester.pump();
    expect(tester.widget<Checkbox>(checkboxCustom).value, true);

    await tester.tap(checkboxCustom);
    await tester.pump();
    expect(tester.widget<Checkbox>(checkboxCustom).value, false);
  });
}
