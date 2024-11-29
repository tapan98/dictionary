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
  final serachFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    serachFocusNode.dispose();
  }

  Widget searchButton() {
    return IconButton(onPressed: () {}, icon: const Icon(Icons.search));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90.0,
          title: SearchBar(
            hintText: "Search",
            onSubmitted: (value) {
              ref
                  .read(wordNotiferProvider.notifier)
                  .searchWord(searchController.text);
            },
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: searchController,
          ),
          actions: [
            PopupMenuButton<int>(
                onSelected: (value) {
                  switch (value) {
                    case _popupMenuSettings:
                      () {};
                    default:
                  }
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: _popupMenuSettings, child: Text("Settings")),
                    ]),
          ],
        ),
        body: const Column(
          children: [
            Expanded(
              child: WordDisplay(),
            ),
          ],
        ),
      ),
    );
  }

  static const int _popupMenuSettings = 0;
}
