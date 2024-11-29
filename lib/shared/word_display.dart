import 'dart:io';
import 'package:dictionary/models/word.dart';
import 'package:dictionary/providers/word_provider.dart';
import 'package:dictionary/shared/meanings_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordDisplay extends ConsumerStatefulWidget {
  const WordDisplay({super.key});

  @override
  ConsumerState<WordDisplay> createState() => _WordDisplayState();
}

class _WordDisplayState extends ConsumerState<WordDisplay> {
  Widget displayWord(Word data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: MeaningsDisplay(
            meanings: data.meanings,
            title: data.word,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final word = ref.watch(wordNotiferProvider);
    return Scaffold(
      body: FutureBuilder(
        future: word.value,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // parse snapshot
            if (snapshot.hasData && snapshot.data != null) {
              // searched for something
              return (snapshot.data!.word == "")
                  ? const Center(
                      child: Text(
                          "No Definitions Found!\nPlease check word/spelling"))
                  : displayWord(snapshot.data!);
            } else if (snapshot.error.runtimeType == SocketException) {
              return const Center(
                child: Text(
                    "Failed to connect to the Dictionary API\nPlease check your internet"),
              );
            } else if (snapshot.hasError) {
              // error
              return Center(
                child: Text(
                    "Something went wrong!\n${snapshot.error}\nType: ${snapshot.error.runtimeType}"),
              );
            } else if (snapshot.data == null) {
              return const Center(
                child: Text("Use searchbar to lookup a word"),
              );
            }
          }

          // snapshot.connectionState != ConnectionState.done
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
