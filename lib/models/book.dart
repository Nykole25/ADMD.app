import 'library_item.dart';

class Book extends LibraryItem {
  final int? pageCount;
  final String? isbn;

  Book({
    required String title,
    String? author,
    DateTime? publishDate,
    this.pageCount,
    this.isbn,
  }) : super(title: title, author: author, publishDate: publishDate);

  @override
  String describe() {
    String pages = 'pages unknown';
    if (pageCount != null) {
      pages = '$pageCount pages';
    }
    return 'Book - $pages - ISBN: ${isbn ?? 'N/A'} - ${getAuthor()} - ${getBorrowerText()}';
  }
}