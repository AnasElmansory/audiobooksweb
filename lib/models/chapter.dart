import 'dart:convert';

class Chapter {
  final String id;
  final String title;
  final String author;
  final String textHint;
  final String contentAsHtml;
  final String audioLink;
  final String pdfLink;
  final String wordCount;
  Chapter({
    this.id,
    this.title,
    this.author,
    this.textHint,
    this.contentAsHtml,
    this.audioLink,
    this.pdfLink,
    this.wordCount,
  });

  Chapter copyWith({
    String id,
    String title,
    String author,
    String textHint,
    String contentAsHtml,
    String audioLink,
    String pdfLink,
    String wordCount,
  }) {
    return Chapter(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      textHint: textHint ?? this.textHint,
      contentAsHtml: contentAsHtml ?? this.contentAsHtml,
      audioLink: audioLink ?? this.audioLink,
      pdfLink: pdfLink ?? this.pdfLink,
      wordCount: wordCount ?? this.wordCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'textHint': textHint,
      'contentAsHtml': contentAsHtml,
      'audioLink': audioLink,
      'pdfLink': pdfLink,
      'wordCount': wordCount,
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['chapter_stt'],
      title: map['chapter_title'],
      author: map['chapter_author'],
      textHint: map['chapter_text_hint'],
      contentAsHtml: map['chapter_text'],
      audioLink: map['chapter_link_audio'],
      pdfLink: map['chapter_link_pdf'],
      wordCount: map['chapter_word_count'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromJson(String source) =>
      Chapter.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Chapter(id: $id, title: $title, author: $author, textHint: $textHint, contentAsHtml: $contentAsHtml, audioLink: $audioLink, pdfLink: $pdfLink, wordCount: $wordCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chapter &&
        other.id == id &&
        other.title == title &&
        other.author == author &&
        other.textHint == textHint &&
        other.contentAsHtml == contentAsHtml &&
        other.audioLink == audioLink &&
        other.pdfLink == pdfLink &&
        other.wordCount == wordCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        author.hashCode ^
        textHint.hashCode ^
        contentAsHtml.hashCode ^
        audioLink.hashCode ^
        pdfLink.hashCode ^
        wordCount.hashCode;
  }
}
