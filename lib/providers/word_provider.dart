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
    return await _fetchDefinition(null);
  }

  // methods to update
  void searchWord(String word) async {
    if (word == "") return;
    if (kDebugMode) print("Searching for $word");

    state = await AsyncValue.guard(() async {
      return _fetchDefinition(word);
    });
  }

  Future<Word?> _fetchDefinition(String? word) async {
    if (word == null) return null;
    http.Response response = await _getResponse(word);

    final json = convert.jsonDecode(response.body);

    Map<String, dynamic> data = json[0] ?? json;

    // No Definitions check
    if (data.containsKey('title') &&
        json['title'] as String == "No Definitions Found") {
      return Word(word: "", meanings: []);
    }

    List<Meaning> meanings = _parseJson(data);

    return Word(word: data['word'], meanings: meanings);
  }

  Future<http.Response> _getResponse(String word) async {
    var uri = Uri.http('api.dictionaryapi.dev', '/api/v2/entries/en/$word');
    // var uri = Uri.http('localhost', '/api/v2/entries/en/$word');

    return await http
        .get(uri)
        .timeout(const Duration(seconds: 10))
        .onError((error, stackTrace) {
      throw const SocketException("No connection");
    });
  }

  List<Meaning> _parseJson(Map<String, dynamic> data) {
    List<Meaning> meanings = [];

    // list of meanings
    for (Map<String, dynamic> meaning in data['meanings']) {
      // get part of speechDefinition
      String partOfSpeech = meaning['partOfSpeech'];

      // get synonyms
      List<String> synonyms = _getSynonyms(meaning);

      // get antonyms
      List<String> antonyms = _getAntonyms(meaning);

      // get definitions
      List<Definition> definitions = _getDefinitions(meaning);

      // create Meaning object
      meanings.add(Meaning(
        partOfSpeech: partOfSpeech,
        definitions: definitions,
        synonyms: synonyms,
        antonyms: antonyms,
      ));
    }
    return meanings;
  }

  List<Definition> _getDefinitions(Map<String, dynamic> meaning) {
    List<Definition> definitions = [];
    for (Map<String, dynamic> definition in meaning['definitions']) {
      definitions.add(Definition(
        definition: definition['definition'].toString(),
        example:
            (definition.containsKey('example')) ? definition['example'] : null,
      ));
    }
    return definitions;
  }

  List<String> _getSynonyms(Map<String, dynamic> meaning) {
    List<String> synonyms = [];
    for (String synonym in meaning['synonyms']) {
      synonyms.add(synonym);
    }
    return synonyms;
  }

  List<String> _getAntonyms(Map<String, dynamic> meaning) {
    List<String> antonyms = [];
    for (String antonym in meaning['antonyms']) {
      antonyms.add(antonym);
    }
    return antonyms;
  }
}

final wordNotiferProvider =
    AsyncNotifierProvider<WordNotifer, Future<Word?>>(() {
  return WordNotifer();
});
