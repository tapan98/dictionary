import 'dart:io';
import 'package:dictionary/models/word.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class WordNotifer extends AsyncNotifier<Future<Word?>> {
  // init
  @override
  Future<Word?> build() async {
    return await fetchDefinition(null);
  }

  void searchWord(String word) {
    if (kDebugMode) print("Searching for $word");
    state = AsyncValue.data(fetchDefinition(word));
  }

  // methods to update
  Future<Word?> fetchDefinition(String? word) async {
    var url = (word == null)
        ? Uri.http('localhost:8000', '/example.json')
        : Uri.http('api.dictionaryapi.dev', '/api/v2/entries/en/$word');
    var response = await http.get(url).onError((error, stackTrace) {
      throw AsyncError<SocketException>("No connection", StackTrace.current);
    });
    final json = convert.jsonDecode(response.body);

    Map<String, dynamic> data = json[0] ?? json;
    if (data.containsKey('title') &&
        json['title'] as String == "No Definitions Found") {
      return null;
    }
    List<Meaning> meanings = [];

    // list of meanings
    for (Map<String, dynamic> meaning in data['meanings']) {
      // get part of speechDefinition
      String partOfSpeech = meaning['partOfSpeech'];
      List<String> synonyms = [];
      List<String> antonyms = [];

      List<Definition> defs = [];
      // get synonyms
      for (String synonym in meaning['synonyms']) {
        synonyms.add(synonym);
      }

      // get antonyms
      for (String antonym in meaning['antonyms']) {
        antonyms.add(antonym);
      }

      // get definitions
      for (Map<String, dynamic> definition in meaning['definitions']) {
        defs.add(Definition(
          definition: definition['definition'].toString(),
          example: (definition.containsKey('example'))
              ? definition['example']
              : null,
        ));
      }

      // create Meaning object
      meanings.add(Meaning(
        partOfSpeech: partOfSpeech,
        definitions: defs,
        synonyms: synonyms,
        antonyms: antonyms,
      ));
    }
    return Word(word: data['word'], meanings: meanings);
  }
}

final wordNotiferProvider =
    AsyncNotifierProvider<WordNotifer, Future<Word?>>(() {
  return WordNotifer();
});
