import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
      RichText(
        text: TextSpan(
          children: [
            const TextSpan(
                text: "Uses ", style: TextStyle(color: Colors.black)),
            TextSpan(
                text: "Free Dictionary API",
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse("https://dictionaryapi.dev/"));
                  })
          ],
        ),
      ),
    ];
  }
}
