import 'dart:io';
import 'package:dictionary/models/definition.dart';
import 'package:dictionary/models/meaning.dart';
import 'package:dictionary/models/word.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class WordNotifer extends AsyncNotifier<Future<Word?>> {
  @override
  Future<Word?> build() async {
    return await _fetchDefinition(null);
  }

  /// Fetches the definition of [word]
  void searchWord(String word) async {
    if (kDebugMode) print("Searching for $word");

    state = await AsyncValue.guard(() async {
      return _fetchDefinition(word);
    });
  }

  Future<Word?> _fetchDefinition(String? word) async {
    if (word == null || word.isEmpty) return null;
    http.Response response = await _getResponse(word);

    final json = convert.jsonDecode(response.body);

    // the json body could be enclosed in an Array/List
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

    return await http
        .get(uri)
        .timeout(const Duration(seconds: 10))
        .onError((error, stackTrace) {
      throw const SocketException("No connection");
    });
  }

  List<Meaning> _parseJson(Map<String, dynamic> data) {
    List<Meaning> meanings = [];

    for (Map<String, dynamic> meaning in data['meanings']) {
      String partOfSpeech = meaning['partOfSpeech'];

      List<String> synonyms = _getSynonyms(meaning);

      List<String> antonyms = _getAntonyms(meaning);

      List<Definition> definitions = _getDefinitions(meaning);

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
        example: definition['example'],
      ));
    }
    return definitions;
  }

  List<String> _getSynonyms(Map<String, dynamic> meaning) {
    return List<String>.from(meaning['synonyms']);
  }

  List<String> _getAntonyms(Map<String, dynamic> meaning) {
    return List<String>.from(meaning['antonyms']);
  }
}

final wordNotiferProvider =
    AsyncNotifierProvider<WordNotifer, Future<Word?>>(() {
  return WordNotifer();
});
