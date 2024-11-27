class Word {
  final String word;
  List<Meaning> meanings;

  Word({required this.word, required this.meanings});

  @override
  String toString() {
    return "Word: $word\n";
  }
}

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

class Definition {
  String definition;

  String? example;
  Definition({
    required this.definition,
    this.example,
  });
}
