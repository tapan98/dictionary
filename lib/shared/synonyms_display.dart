import 'package:flutter/material.dart';

class DisplaySynonyms extends StatelessWidget {
  final List<String> synonyms;
  const DisplaySynonyms({super.key, required this.synonyms});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: synonyms.length,
        itemBuilder: (context, index) {
          return Text(formatSynonyms());
        });
  }

  String formatSynonyms() {
    String syns = "";
    for (String synonym in synonyms) {
      if (syns.isNotEmpty) syns += "; ";
      syns += synonym;
    }
    return syns;
  }
}
