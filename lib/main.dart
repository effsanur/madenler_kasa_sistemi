import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase çekirdek paketi
import 'package:madenler_kasa_sistemi/app/router.dart';
import 'package:madenler_kasa_sistemi/app/theme.dart';

void main() async {
  // Flutter widget ağacının düzgün bağlandığından emin oluyoruz
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlatıyoruz.
  // Manuel kurulum yaptığın için ek parametreye gerek duymadan
  // google-services.json dosyasını otomatik okuyacaktır.
  await Firebase.initializeApp();

  runApp(const MyApp());
}

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
