import 'package:hive/hive.dart';

part 'bookmark.g.dart';

@HiveType(typeId: 1)
class Bookmark extends HiveObject {
  @HiveField(0)
  final int surahNumber;

  @HiveField(1)
  final String surahName;

  @HiveField(2)
  final int pageNumber;

  @HiveField(3)
  final String description;

  Bookmark({
    required this.surahNumber,
    required this.surahName,
    required this.pageNumber,
    required this.description,
  });
}
