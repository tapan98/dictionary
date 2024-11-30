import 'dart:io';
import 'package:dictionary/models/word.dart';
import 'package:dictionary/providers/word_provider.dart';
import 'package:dictionary/shared/meanings_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FetchWord extends ConsumerStatefulWidget {
  const FetchWord({super.key});

  @override
  ConsumerState<FetchWord> createState() => _WordDisplayState();
}

class _WordDisplayState extends ConsumerState<FetchWord> {
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
                  ? _displayNoDefinitions()
                  : _displayWord(snapshot.data!);
            } else if (snapshot.error.runtimeType == SocketException) {
              return _displayFailedToConnect();
            } else if (snapshot.hasError) {
              return _displayUnknownError(
                  snapshot.error, snapshot.error.runtimeType);
            } else if (snapshot.data == null) {
              return _hintUser();
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

  Widget _displayWord(Word data) {
    return MeaningsDisplay(
      title: data.word,
      meanings: data.meanings,
    );
  }

  Center _displayNoDefinitions() {
    return const Center(
        child: Text("No Definitions Found!\nPlease check word/spelling"));
  }

  Center _displayFailedToConnect() {
    return const Center(
      child: Text(
          "Failed to connect to the Dictionary API\nPlease check your internet"),
    );
  }

  Center _displayUnknownError(Object? error, Type runtimeType) {
    return Center(
      child: Text("Something went wrong!\n$error\nType: $runtimeType"),
    );
  }

  Center _hintUser() {
    return const Center(child: Text("Use searchbar to lookup a word"));
  }
}
