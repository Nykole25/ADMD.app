import 'package:flutter/material.dart';

import 'models/user.dart';
import 'models/bank_account.dart';
import 'models/book.dart';
import 'models/magazine.dart';
import 'models/library.dart';
import 'screens/todo_screen.dart';
import 'screens/lab4_screen.dart';

List<User> users = [];
List<BankAccount> accounts = [];
Library library = Library();

void setupData() {
  users.add(User(name: 'Andra', age: 24, email: 'andra.n@mail.com'));
  users.add(User(name: 'Radu', age: 19));
  users.add(User(name: 'Elena'));

  BankAccount acc1 = BankAccount(
    holderName: 'Andra',
    balance: 1200.75,
    bankBranch: 'Cluj-Napoca',
  );
  acc1.initializeAccount('RO44 BANK 1001');

  BankAccount acc2 = BankAccount(holderName: 'Radu', balance: 85.0);
  acc2.initializeAccount('RO55 BANK 2002');

  BankAccount acc3 = BankAccount(holderName: 'Elena');

  accounts.add(acc1);
  accounts.add(acc2);
  accounts.add(acc3);

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

  library.borrowItem(book, users[0], DateTime.now().add(Duration(days: 14)));

  print(library.borrowItem(book, users[1], DateTime.now()));
  print(library.searchByTitle(null));
  print(library.searchByTitle('garden').length);
  print(library.getItemsByAuthor('maria popescu').length);
  print(library.getRecentItems().length);
}

void main() {
  setupData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'ADMD - Andra', home: MenuPage());
  }
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ADMD - Andra')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Lab 2 - Dart and null safety'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodoScreen()),
                );
              },
              child: Text('Lab 3 - Todo app'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Lab4Screen()),
                );
              },
              child: Text('Lab 4 - Serialization and networking'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
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
    List<Widget> rows = [];

    rows.add(sectionTitle('Users'));
    for (var u in users) {
      rows.add(
        ListTile(
          title: Text(u.name),
          subtitle: Text(u.getDisplayAge() + ' - ' + u.getDisplayEmail()),
        ),
      );
    }

    rows.add(sectionTitle('Bank accounts'));
    for (var a in accounts) {
      rows.add(
        ListTile(
          title: Text(a.holderName),
          subtitle: Text(
            a.getDisplayNumber() + ' - ' + (a.bankBranch ?? 'N/A'),
          ),
        ),
      );
    }

    rows.add(sectionTitle('Library'));
    for (var item in library.items) {
      rows.add(
        ListTile(title: Text(item.title), subtitle: Text(item.describe())),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Lab 2 - Andra')),
      body: ListView.builder(
        itemCount: rows.length,
        itemBuilder: (context, i) {
          return rows[i];
        },
      ),
    );
  }
}
