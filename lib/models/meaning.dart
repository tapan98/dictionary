import 'package:dictionary/models/definition.dart';

class Meaning {
  String partOfSpeech;
  List<String> synonyms;
  List<String> antonyms;
  List<Definition> definitions;
  Meaning({
    required this.partOfSpeech,
    required this.definitions,
    required this.synonyms,
    required this.antonyms,
  });
}
