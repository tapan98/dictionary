import 'package:dictionary/models/word.dart';
import 'package:dictionary/shared/definitions_display.dart';
import 'package:dictionary/shared/synonyms_display.dart';
import 'package:flutter/material.dart';

class MeaningsDisplay extends StatelessWidget {
  final List<Meaning> meanings;
  const MeaningsDisplay({super.key, required this.meanings});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: meanings.length,
      // prototypeItem: Tex,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      meanings[index].partOfSpeech,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DefinitionsDisplay(definitions: meanings[index].definitions),
                  if (meanings[index].synonyms.isNotEmpty)
                    const Text("Synonyms: "),
                  DisplaySynonyms(synonyms: meanings[index].synonyms),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
