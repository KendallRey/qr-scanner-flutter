import 'package:flutter/material.dart';
import 'package:qr_scanner/app/core/widgets/app_bar.dart';
import 'package:qr_scanner/app/core/widgets/bottom_app_bar.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget child;

  const AppScaffold({super.key, required this.child, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: title),
      body: AnimatedSwitcher(
        duration: Durations.short1,
        child: child,
      ),
      bottomNavigationBar: MyBottomAppBar(),
    );
  }
}
