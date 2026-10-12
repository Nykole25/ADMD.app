import 'library_item.dart';
import 'user.dart';

class Library {
  final List<LibraryItem> _items = [];

  List<LibraryItem> get items => _items;

  // Adaugă doar dacă itemul există și are titlu
  bool addItem(LibraryItem? item) {
    if (item == null) return false;
    if (item.title.isEmpty) return false;
    _items.add(item);
    return true;
  }

  // Dacă query e null sau gol, întoarce listă goală
  List<LibraryItem> searchByTitle(String? query) {
    List<LibraryItem> result = [];
    if (query == null || query.isEmpty) return result;

    for (var item in _items) {
      if (item.title.toLowerCase().contains(query.toLowerCase())) {
        result.add(item);
      }
    }
    return result;
  }

  List<LibraryItem> getItemsByAuthor(String? author) {
    List<LibraryItem> result = [];
    if (author == null || author.isEmpty) return result;

    for (var item in _items) {
      if (item.author != null &&
          item.author!.toLowerCase() == author.toLowerCase()) {
        result.add(item);
      }
    }
    return result;
  }

  // Itemele publicate în ultimul an
  List<LibraryItem> getRecentItems() {
    List<LibraryItem> result = [];
    DateTime limit = DateTime.now().subtract(Duration(days: 365));

    for (var item in _items) {
      if (item.publishDate != null && item.publishDate!.isAfter(limit)) {
        result.add(item);
      }
    }
    return result;
  }

  bool borrowItem(LibraryItem? item, User? user, DateTime? dueDate) {
    if (item == null || user == null || dueDate == null) return false;
    if (item.borrower != null) return false; // deja împrumutat
    item.borrower = user;
    item.dueDate = dueDate;
    return true;
  }

  bool returnItem(LibraryItem? item) {
    if (item == null || item.borrower == null) return false;
    item.borrower = null;
    item.dueDate = null;
    return true;
  }
}