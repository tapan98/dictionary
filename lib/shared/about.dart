import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class About {
  static const String version = '0.1.0';
  static const String name = "Dictionary";

  static void addLicense() {
    LicenseRegistry.addLicense(() async* {
      final freeDictionaryApiLicense =
          await rootBundle.loadString('lib/assets/licenses/freeDictionaryAPI');
      yield LicenseEntryWithLineBreaks(
          ['Free Dictionary API'], freeDictionaryApiLicense);
    });
  }

  static List<Widget> aboutDialogText() {
    return [
      const Text("Uses Free Dictionary API"),
    ];
  }
}
