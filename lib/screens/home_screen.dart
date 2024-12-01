import 'package:dictionary/providers/word_provider.dart';
import 'package:dictionary/shared/about.dart';
import 'package:dictionary/shared/fetch_word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90.0,
          title: _displaySearchBar(),
          actions: _createPopupMenus(),
        ),
        body: const Column(
          children: [
            Expanded(
              child: FetchWord(),
            ),
          ],
        ),
      ),
    );
  }

  SearchBar _displaySearchBar() {
    return SearchBar(
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
    );
  }

  List<Widget> _createPopupMenus() {
    return [
      PopupMenuButton<int>(
        onSelected: (value) {
          switch (value) {
            case _popupMenuAbout:
              showAboutDialog(
                context: context,
                applicationVersion: About.version,
                applicationName: About.name,
                applicationIcon: const FlutterLogo(),
                children: About.aboutDialogText(),
              );
          }
        },
        itemBuilder: (context) =>
            [const PopupMenuItem(value: _popupMenuAbout, child: Text("About"))],
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    serachFocusNode.dispose();
  }

  final searchController = SearchController();
  final serachFocusNode = FocusNode();
  static const int _popupMenuAbout = 0;
}
