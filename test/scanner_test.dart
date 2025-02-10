import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:qr_scanner/app/core/constants/constants.dart';
import 'package:qr_scanner/app/core/providers/app_settings_provider.dart';
import 'package:qr_scanner/app/router.dart';

void main() {
  late Box testBox;

  setUp(() async {
    await setUpTestHive();
    testBox = await Hive.openBox(Constants.hiveBox);
  });

  tearDown(() async {
    await testBox.close();
  });

  testWidgets('Navigate to Scanner Screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ],
        child: MaterialApp.router(
          routerConfig: AppRouter().router,
        ),
      ),
    );

    expect(find.text("Scanner"), findsExactly(2));

    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    expect(find.text("Home"), findsExactly(2));

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text("Settings"), findsExactly(2));

    await tester.tap(find.byIcon(Icons.qr_code_scanner));
    await tester.pumpAndSettle();
    expect(find.text("Scanner"), findsExactly(2));
  });
}
