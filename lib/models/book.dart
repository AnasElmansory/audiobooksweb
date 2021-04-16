import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:audiobooks/models/chapter.dart';

class Book {
  final String rowId;
  final String id;
  final String title;
  final String bookAuthor;
  final String bookImage;
  final String publishYear;
  final String language;
  final String countryOfOrigin;
  final String readability;
  final String wordCount;
  final String genre;
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
    String genre,
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
      'genre': genre,
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
      rowId: map['row_id'],
      id: map['book_id_book'],
      title: map['book_name'],
      bookAuthor: map['book_author'],
      bookImage: map['book_link_image'],
      publishYear: map['book_year_publish'],
      language: map['book_language'],
      countryOfOrigin: map['book_country_of_origin'],
      readability: map['book_readability'],
      wordCount: map['book_word_count'],
      genre: map['book_genre'],
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
