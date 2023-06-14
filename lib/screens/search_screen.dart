import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/search_results_provider.dart';
import 'package:todo/screens/note_screen.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(searchResultProvider);
    return WillPopScope(
      onWillPop: () async {
        ref.read(searchQueryProvider.notifier).searchFor('');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).searchFor(value);
            },
            decoration: const InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: result.length,
          itemBuilder: (ctx, i) => InkWell(
            onTap: () {
              ref.read(searchQueryProvider.notifier).searchFor('');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => NoteScreen(
                    note: result[i]['note'],
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondaryContainer),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(8),
              child: Text(
                result[i]['text'],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
