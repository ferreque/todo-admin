// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';

abstract class GlobalSettings {
  final String apiUrl;
  final String codeName;
  final num smallFormWidth;
  final num largeFormWidth;
  final num mediumFormWidth;
  final Color headerFillColor;
  final Color menuFillColor;
  final Color contentFillColor;
  final BorderRadius generalRadius;

  bool get isTest;

  factory GlobalSettings(mode) {
    return mode == 'test' ? GlobalSettingsTest() : GlobalSettingsLive();
  }
}

class GlobalSettingsLive implements GlobalSettings {
  //final String apiUrl = 'https://api.todo.com';
  final String apiUrl = 'http://127.0.0.1:6401';
  final String codeName = 'rocky';
  final num smallFormWidth = 300.0;
  final num largeFormWidth = 800.0;
  final num mediumFormWidth = 700.0;
  final Color headerFillColor = const Color(0xff1d1d1d);
  final Color menuFillColor = const Color(0xff343b42);
  final Color contentFillColor = Colors.white;
  final BorderRadius generalRadius = BorderRadius.circular(8);

  bool get isTest => false;
}

class GlobalSettingsTest extends GlobalSettingsLive {
  final String apiUrl = 'http://localhost:6401';

  bool get isTest => true;
}
