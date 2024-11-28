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
    if (word == "") return;
    if (kDebugMode) print("Searching for $word");
    state = AsyncValue.data(fetchDefinition(word));
  }

  // methods to update
  Future<Word?> fetchDefinition(String? word) async {
    if (word == null) return null;
    var uri = Uri.http('api.dictionaryapi.dev', '/api/v2/entries/en/$word');
    var response = await http.get(uri).onError((error, stackTrace) {
      throw AsyncError<SocketException>("No connection", StackTrace.current);
    });
    print("Response was: ${response.body}");
    final json = convert.jsonDecode(response.body);
    print("json: $json");

    Map<String, dynamic> data = json[0] ?? json;
    if (data.containsKey('title') &&
        json['title'] as String == "No Definitions Found") {
      return Word(word: "", meanings: []);
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
