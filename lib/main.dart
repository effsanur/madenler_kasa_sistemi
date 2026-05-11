import 'package:flutter/material.dart';
import 'package:madenler_kasa_sistemi/app/router.dart';
import 'package:madenler_kasa_sistemi/app/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}
