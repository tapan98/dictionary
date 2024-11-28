import 'package:flutter/material.dart';

class DisplayAntonyms extends StatelessWidget {
  final List<String> antonyms;
  const DisplayAntonyms({super.key, required this.antonyms});

  @override
  Widget build(BuildContext context) {
    return Text(formatAntonyms());
  }

  String formatAntonyms() {
    String anms = "";
    for (String antonym in antonyms) {
      if (anms.isNotEmpty) anms += "; ";
      anms += antonym;
    }
    return anms;
  }
}
