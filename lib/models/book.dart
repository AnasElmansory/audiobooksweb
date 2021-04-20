import 'dart:convert';

import 'package:audiobooks/models/model.dart';
import 'package:flutter/foundation.dart';

import 'package:audiobooks/models/chapter.dart';

class Book extends Model {
  final String rowId;
  @override
  final String id;
  final String title;
  final String bookAuthor;
  final String bookImage;
  final String publishYear;
  final String language;
  final String countryOfOrigin;
  final String readability;
  final String wordCount;
  final BookGenre genre;
  final String keywords;
  final String textHint;
  final String source;
  final String fav;
  final String thich;
  final String laoi;
  final List<Chapter> chapters;
  Book({
    this.rowId,
    this.id,
    this.title,
    this.bookAuthor,
    this.bookImage,
    this.publishYear,
    this.language,
    this.countryOfOrigin,
    this.readability,
    this.wordCount,
    this.genre,
    this.keywords,
    this.textHint,
    this.source,
    this.fav,
    this.thich,
    this.laoi,
    this.chapters,
  });

  Book copyWith({
    String rowId,
    String id,
    String title,
    String bookAuthor,
    String bookImage,
    String publishYear,
    String language,
    String countryOfOrigin,
    String readability,
    String wordCount,
    BookGenre genre,
    String keywords,
    String textHint,
    String source,
    String fav,
    String thich,
    String laoi,
    List<Chapter> chapters,
  }) {
    return Book(
      rowId: rowId ?? this.rowId,
      id: id ?? this.id,
      title: title ?? this.title,
      bookAuthor: bookAuthor ?? this.bookAuthor,
      bookImage: bookImage ?? this.bookImage,
      publishYear: publishYear ?? this.publishYear,
      language: language ?? this.language,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      readability: readability ?? this.readability,
      wordCount: wordCount ?? this.wordCount,
      genre: genre ?? this.genre,
      keywords: keywords ?? this.keywords,
      textHint: textHint ?? this.textHint,
      source: source ?? this.source,
      fav: fav ?? this.fav,
      thich: thich ?? this.thich,
      laoi: laoi ?? this.laoi,
      chapters: chapters ?? this.chapters,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rowId': rowId,
      'id': id,
      'title': title,
      'bookAuthor': bookAuthor,
      'bookImage': bookImage,
      'publishYear': publishYear,
      'language': language,
      'countryOfOrigin': countryOfOrigin,
      'readability': readability,
      'wordCount': wordCount,
      'genre': genre.toString(),
      'keywords': keywords,
      'textHint': textHint,
      'source': source,
      'fav': fav,
      'thich': thich,
      'laoi': laoi,
      'chapters': chapters?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      rowId: map['row_id'].toString(),
      id: map['book_id_book'].toString(),
      title: map['book_name'],
      bookAuthor: map['book_author'],
      bookImage: map['book_link_image'],
      publishYear: map['book_year_publish'],
      language: map['book_language'],
      countryOfOrigin: map['book_country_of_origin'],
      readability: map['book_readability'],
      wordCount: map['book_word_count'],
      genre: mapBookGenre(map['book_genre']),
      keywords: map['book_keywords'],
      textHint: map['book_text_hint_book'],
      source: map['book_source'],
      fav: map['book_fav'],
      thich: map['book_thich'],
      laoi: map['loai'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Book(rowId: $rowId, id: $id, title: $title, bookAuthor: $bookAuthor, bookImage: $bookImage, publishYear: $publishYear, language: $language, countryOfOrigin: $countryOfOrigin, readability: $readability, wordCount: $wordCount, genre: $genre, keywords: $keywords, textHint: $textHint, source: $source, fav: $fav, thich: $thich, laoi: $laoi, chapters: $chapters)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Book &&
        other.rowId == rowId &&
        other.id == id &&
        other.title == title &&
        other.bookAuthor == bookAuthor &&
        other.bookImage == bookImage &&
        other.publishYear == publishYear &&
        other.language == language &&
        other.countryOfOrigin == countryOfOrigin &&
        other.readability == readability &&
        other.wordCount == wordCount &&
        other.genre == genre &&
        other.keywords == keywords &&
        other.textHint == textHint &&
        other.source == source &&
        other.fav == fav &&
        other.thich == thich &&
        other.laoi == laoi &&
        listEquals(other.chapters, chapters);
  }

  @override
  int get hashCode {
    return rowId.hashCode ^
        id.hashCode ^
        title.hashCode ^
        bookAuthor.hashCode ^
        bookImage.hashCode ^
        publishYear.hashCode ^
        language.hashCode ^
        countryOfOrigin.hashCode ^
        readability.hashCode ^
        wordCount.hashCode ^
        genre.hashCode ^
        keywords.hashCode ^
        textHint.hashCode ^
        source.hashCode ^
        fav.hashCode ^
        thich.hashCode ^
        laoi.hashCode ^
        chapters.hashCode;
  }
}

BookGenre mapBookGenre(String bookGenreString) {
  if (bookGenreString == 'Genre: Fantasy')
    return BookGenre.FANTASY;
  else if (bookGenreString == 'Genre: Poetry')
    return BookGenre.POETRY;
  else if (bookGenreString == 'Genre: Informational')
    return BookGenre.INFORMATIONAL;
  else if (bookGenreString == 'Genre: Horror')
    return BookGenre.HORROR;
  else if (bookGenreString == 'Genre: Romance')
    return BookGenre.ROMANCE;
  else if (bookGenreString == 'Genre: Adventure')
    return BookGenre.ADVENTURE;
  else if (bookGenreString == 'Genre: Fairy Tale/Folk Tale')
    return BookGenre.FAIRY_TAILE_FOLK_TALE;
  else if (bookGenreString == 'Genre: Realism')
    return BookGenre.REALISM;
  else if (bookGenreString == 'Genre: Gothic')
    return BookGenre.GOTHIC;
  else if (bookGenreString == 'Genre: Memoir')
    return BookGenre.MEMOIR;
  else if (bookGenreString == 'Genre: Science Fiction')
    return BookGenre.SCIENCE_FICTION;
  else if (bookGenreString == 'Genre: Epic')
    return BookGenre.EPIC;
  else if (bookGenreString == 'Genre: Essay')
    return BookGenre.ESSAY;
  else if (bookGenreString == 'Genre: Tragedy')
    return BookGenre.TRAGEDY;
  else if (bookGenreString == 'Genre: Satire')
    return BookGenre.SATIRE;
  else if (bookGenreString == 'Genre: Historical Fiction')
    return BookGenre.HISTORICAL_FICTION;
  else if (bookGenreString == 'Genre: Nursery Rhyme')
    return BookGenre.NURSERY_RHYME;
  else if (bookGenreString == 'Genre: Mystery')
    return BookGenre.MYSTERY;
  else if (bookGenreString == 'Genre: Speech')
    return BookGenre.SPEECH;
  else if (bookGenreString == 'Genre: History')
    return BookGenre.HISTORY;
  else
    return BookGenre.UNKNOWN;
}

enum BookGenre {
  UNKNOWN,
  FANTASY,
  HORROR,
  MYSTERY,
  ADVENTURE,
  SCIENCE_FICTION,
  HISTORICAL_FICTION,
  INFORMATIONAL,
  FAIRY_TAILE_FOLK_TALE,
  SATIRE,
  ROMANCE,
  GOTHIC,
  TRAGEDY,
  REALISM,
  MEMOIR,
  ESSAY,
  POETRY,
  NURSERY_RHYME,
  EPIC,
  SPEECH,
  HISTORY,
}
