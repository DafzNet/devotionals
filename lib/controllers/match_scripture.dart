class BibleReference {
  String? book;
  int? chapter;
  int? verseStart;
  int? verseEnd;

  BibleReference({this.book, this.chapter, this.verseStart, this.verseEnd});

  @override
  String toString() {
    return 'Book: $book, Chapter: $chapter, Verse Start: $verseStart, Verse End: $verseEnd';
  }
}

BibleReference parseBibleReference(String reference) {
  List<String> parts = reference.split(RegExp(r'\s*[:,\-\s]\s*'));
  print(parts);

  String? book;
  int? chapter;
  int? verseStart;
  int? verseEnd;

  if (parts.length > 2) {
    // Parse book
    book = parts[parts.length - 3];

    // Parse chapter
    chapter = int.tryParse(parts[parts.length - 2]);

    // Parse verse
    List<String> verseParts = parts[parts.length - 1].split(':');
    verseStart = int.tryParse(verseParts[0]);

    if (verseParts.length > 1) {
      // Parse verse end if available
      verseEnd = int.tryParse(verseParts[1]);
    }
  }

  return BibleReference(
    book: book,
    chapter: chapter,
    verseStart: verseStart,
    verseEnd: verseEnd,
  );
}