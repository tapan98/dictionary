import 'package:flutter/material.dart';

class DisplayAntonyms extends StatelessWidget {
  final List<String> antonyms;
  const DisplayAntonyms({super.key, required this.antonyms});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Antonyms: ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(formatAntonyms()),
      ],
    );
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
