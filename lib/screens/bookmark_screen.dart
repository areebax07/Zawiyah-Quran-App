import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zawiyah/models/bookmark.dart';
import 'package:zawiyah/providers/settings_provider.dart';
import 'package:zawiyah/screens/quran_page_screen.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<SettingsProvider>().isDarkMode;
    final purpleColor = const Color(0xFF863ED5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : purpleColor,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder<Box<Bookmark>>(
        valueListenable: Hive.box<Bookmark>('bookmarks').listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No bookmarks yet.\nAdd bookmarks while reading Quran.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final bookmark = box.getAt(index)!;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.bookmark_outline, color: Colors.purple, size: 32,),
                  title: Text(
                    'Surah ${bookmark.surahName} • Page ${bookmark.pageNumber}',
                  ),
                  subtitle: Text(
                    bookmark.description.isEmpty
                        ? 'No description'
                        : bookmark.description,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => bookmark.delete(),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuranPageScreen(
                          startingPage: bookmark.pageNumber,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
