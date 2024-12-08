import 'package:dictionary/models/meaning.dart';

class Word {
  final String word;
  List<Meaning> meanings;

  Word({required this.word, required this.meanings});

  @override
  String toString() {
    return "Word: $word\n";
  }
}
