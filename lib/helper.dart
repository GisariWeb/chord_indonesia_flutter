import 'package:chord_indonesia/constant_variable.dart';
import 'package:chord_indonesia/model/catalog.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'model/lyric_header.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
DateTime currentBackPressTime = DateTime.now();

Future<bool> onWillPop() async {
  DateTime now = DateTime.now();
  if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
    currentBackPressTime = now;
    try {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text("Back sekali lagi untuk keluar"),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (ex) {
      // print(ex);
    }

    return Future.value(false);
  }
  return Future.value(true);
}

Future<void> saveJsonToLocal(
    Map<String, dynamic> jsonData, String filename) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');

    await file.writeAsString(jsonEncode(jsonData));
    print('JSON saved to: ${file.path}');
  } catch (e) {
    print('Error saving JSON: $e');
  }
}

Future<void> saveJsonListToLocal(
    List<dynamic> jsonData, String filename) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');

    await file.writeAsString(jsonEncode(jsonData));
    print('JSON saved to: ${file.path}');
  } catch (e) {
    print('Error saving JSON: $e');
  }
}

Future<Map<String, dynamic>> loadJsonFromLocal(String filename) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');

    final jsonString = await file.readAsString();
    return jsonDecode(jsonString) as Map<String, dynamic>;
  } catch (e) {
    print('Error loading JSON: $e');
    return {}; // Return an empty map if there's an error
  }
}

Future<List<Map<String, dynamic>>> loadJsonListFromLocal(
    String filename) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');

    final jsonString = await file.readAsString();
    final list = List<Map<String, dynamic>>.from(
        (jsonDecode(jsonString) as List).map((e) => jsonDecode(e)));

    return list;
  } catch (e) {
    print('Error loading JSON: $e');
    return []; // Return an empty map if there's an error
  }
}

Future<List<Catalog>> fetchListOfArtist() async {
  try {
    var resp = await http.get(Uri.parse("$CHORD_URI/daftar-artist"));
    // print(jsonDecode(resp.body));
    return List<Catalog>.from(
      (jsonDecode(resp.body) as List).map((e) {
        return Catalog.fromMap(e);
      }),
    );
  } catch (ex) {
    rethrow;
  }
}

Future<List<Catalog>> getListOfArtist() async {
  try {
    var resp = await loadJsonFromLocal("catalogs.json");
    // print(jsonDecode(resp.body));
    return List<Catalog>.from(
      (resp as List).map((e) {
        return Catalog.fromMap(e);
      }),
    );
  } catch (ex) {
    rethrow;
  }
}

Future<List<LyricHeader>> getLyricHeader(String? url) async {
  if (url == null) return [];
  // print(url.lastIndexOf("/"));
  try {
    var resp = await http.get(Uri.parse("$CHORD_URI/$url"));
    // print(jsonDecode(resp.body));
    return List<LyricHeader>.from(
      (jsonDecode(resp.body) as List).map((e) {
        return LyricHeader.fromMap(e);
      }),
    );
  } catch (ex) {
    rethrow;
  }
}

// Function epochDateDifference(num firstEpoch, num lastEpoch) {}
