import 'dart:async';
import 'dart:math';

import 'package:chord_indonesia/about.dart';
import 'package:chord_indonesia/app_bar.dart';
import 'package:chord_indonesia/apps.dart';
import 'package:chord_indonesia/artists.dart';
import 'package:chord_indonesia/constant_variable.dart';
import 'package:chord_indonesia/daftar_lyric.dart';
import 'package:chord_indonesia/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  unawaited(WakelockPlus.enable());
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String chordUrl = CHORD_URI;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      // title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        // useMaterial3: true,
      ),
      routes: {
        "/": (context) => const ArtistPage(),
        ArtistPage.routeName: (context) => const ArtistPage(),
        DaftarLirikPage.routeName: (context) => const DaftarLirikPage(),
      },
      initialRoute: "/",
    );
  }
}
