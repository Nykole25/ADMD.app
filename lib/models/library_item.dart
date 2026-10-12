import 'user.dart';

abstract class LibraryItem {
  final String title;
  final String? author;
  final DateTime? publishDate;
  User? borrower;
  DateTime? dueDate;

  LibraryItem({required this.title, this.author, this.publishDate});

  // Fiecare subclasă își scrie propria descriere
  String describe();

  String getAuthor() {
    return author ?? 'Not provided';
  }

  String getBorrowerText() {
    if (borrower == null) {
      return 'Available';
    }
    return 'Borrowed by ${borrower!.name}';
  }
}