import 'library_item.dart';

class Magazine extends LibraryItem {
  final int? issueNumber;
  final String? publisher;

  Magazine({
    required String title,
    String? author,
    DateTime? publishDate,
    this.issueNumber,
    this.publisher,
  }) : super(title: title, author: author, publishDate: publishDate);

  @override
  String describe() {
    return 'Magazine - issue ${issueNumber ?? 'N/A'} - ${publisher ?? 'publisher unknown'} - ${getBorrowerText()}';
  }
}