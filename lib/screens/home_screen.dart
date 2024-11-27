import 'package:dictionary/providers/word_provider.dart';
import 'package:dictionary/shared/word_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final searchController = SearchController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SearchBar(
              hintText: "Search",
              onSubmitted: (value) {
                ref
                    .read(wordNotiferProvider.notifier)
                    .searchWord(searchController.text);
              },
              controller: searchController,
            ),
          ),
          const Expanded(
            child: WordDisplay(),
          ),
        ],
      )),
    );
  }
}
