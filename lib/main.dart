import 'package:flutter/material.dart';
import 'models/user.dart';
import 'models/bank_account.dart';
import 'models/book.dart';
import 'models/magazine.dart';
import 'models/library.dart';

// Datele sunt create aici, în afara widgetului, ca să fie simplu de citit.
List<User> users = [];
List<BankAccount> accounts = [];
Library library = Library();

// Creăm toate obiectele și le punem în liste.
void setupData() {
  // Task I: trei useri cu combinații diferite de null
  users.add(User(name: 'Andra', age: 24, email: 'andra.n@mail.com'));
  users.add(User(name: 'Radu', age: 19));
  users.add(User(name: 'Elena')); // age și email sunt null

  // Task II: trei conturi
  BankAccount acc1 = BankAccount(
    holderName: 'Andra',
    balance: 1200.75,
    bankBranch: 'Cluj-Napoca',
  );
  acc1.initializeAccount('RO44 BANK 1001');

  BankAccount acc2 = BankAccount(holderName: 'Radu', balance: 85.0);
  acc2.initializeAccount('RO55 BANK 2002');

  BankAccount acc3 = BankAccount(holderName: 'Elena'); // neinițializat

  accounts.add(acc1);
  accounts.add(acc2);
  accounts.add(acc3);

  // Task III: o carte și o revistă
  Book book = Book(
    title: 'The Silent Garden',
    author: 'Maria Popescu',
    publishDate: DateTime(2026, 3, 1),
    pageCount: 280,
    isbn: '978-973-111',
  );
  Magazine magazine = Magazine(title: 'Cooking Weekly', issueNumber: 7);

  library.addItem(book);
  library.addItem(magazine);

  // Andra împrumută cartea
  library.borrowItem(book, users[0], DateTime.now().add(Duration(days: 14)));

  // Demonstrații pentru prezentare (apar în terminal)
  print(library.borrowItem(book, users[1], DateTime.now())); // false, deja împrumutată
  print(library.searchByTitle(null)); // [] listă goală
  print(library.searchByTitle('garden').length); // 1
  print(library.getItemsByAuthor('maria popescu').length); // 1
  print(library.getRecentItems().length); // 1
}

void main() {
  setupData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 2 - Andra',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  // Titlu de secțiune, cu spațiu în jur
  Widget sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Construim o singură listă cu toate rândurile, una după alta.
    List<Widget> rows = [];

    // ---------- USERS ----------
    rows.add(sectionTitle('Users'));
    for (var u in users) {
      rows.add(ListTile(
        title: Text(u.name),
        subtitle: Text(u.getDisplayAge() + ' - ' + u.getDisplayEmail()),
      ));
    }

    // ---------- BANK ACCOUNTS ----------
    rows.add(sectionTitle('Bank accounts'));
    for (var a in accounts) {
      rows.add(ListTile(
        title: Text(a.holderName),
        subtitle: Text(
          a.getDisplayNumber() + ' - ' + (a.bankBranch ?? 'N/A'),
        ),
      ));
    }

    // ---------- LIBRARY ----------
    rows.add(sectionTitle('Library'));
    for (var item in library.items) {
      rows.add(ListTile(
        title: Text(item.title),
        subtitle: Text(item.describe()),
      ));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Lab 2 - Andra')),
      // Un singur ListView.builder pentru toată pagina
      body: ListView.builder(
        itemCount: rows.length,
        itemBuilder: (context, i) {
          return rows[i];
        },
      ),
    );
  }
}