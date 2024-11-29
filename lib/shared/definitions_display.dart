import 'package:dictionary/models/word.dart';
import 'package:flutter/material.dart';

class DefinitionsDisplay extends StatelessWidget {
  final List<Definition> definitions;
  const DefinitionsDisplay({super.key, required this.definitions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: definitions.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${index + 1}. "),
                  Expanded(
                    child: Text(
                      definitions[index].definition,
                      textAlign: TextAlign.left,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              if (definitions[index].example != null)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Example: ${definitions[index].example}",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
