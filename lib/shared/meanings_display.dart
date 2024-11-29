import 'package:dictionary/models/word.dart';
import 'package:dictionary/shared/antonyms_display.dart';
import 'package:dictionary/shared/definitions_display.dart';
import 'package:dictionary/shared/synonyms_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeaningsDisplay extends ConsumerStatefulWidget {
  final List<Meaning> meanings;
  final String title;
  const MeaningsDisplay(
      {super.key, required this.meanings, required this.title});

  @override
  ConsumerState<MeaningsDisplay> createState() => _MeaningsDisplayState();
}

class _MeaningsDisplayState extends ConsumerState<MeaningsDisplay> {
  final _searchController = SearchController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  Widget customScrollView() {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (index == 0)
                      ListTile(
                        title: Center(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    Card(
                      elevation: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // part of speech
                            ListTile(
                              title: Text(
                                widget.meanings[index].partOfSpeech,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            DefinitionsDisplay(
                                definitions:
                                    widget.meanings[index].definitions),
                            // synonyms
                            if (widget.meanings[index].synonyms.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DisplaySynonyms(
                                    synonyms: widget.meanings[index].synonyms),
                              ),
                            // antonyms
                            if (widget.meanings[index].antonyms.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DisplayAntonyms(
                                    antonyms: widget.meanings[index].antonyms),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            childCount: widget.meanings.length,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return customScrollView();
  }
}
