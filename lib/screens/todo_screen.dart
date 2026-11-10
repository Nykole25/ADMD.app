import 'package:flutter/material.dart';

import '../models/todo.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<Todo> _items = [];
  final TextEditingController _input = TextEditingController();
  int _nextId = 0;
  String? _filter;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  List<Todo> get _visible {
    if (_filter == null) {
      return _items;
    }
    return _items.where((t) => t.title.contains(_filter!)).toList();
  }

  int _doneCount() {
    int done = 0;
    for (var i = 0; i < _items.length; i++) {
      done += _items[i].completed ? 1 : 0;
    }
    return done;
  }

  void _add() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _items.add(Todo(userId: 1, id: _nextId, title: text, completed: false));
      _nextId++;
    });
    _input.clear();
  }

  void _toggle(Todo todo, bool? value) {
    // Todo are câmpuri final, deci înlocuim obiectul în listă.
    final index = _items.indexWhere((t) => t.id == todo.id);
    if (index == -1) return;
    setState(() {
      _items[index] = Todo(
        userId: todo.userId,
        id: todo.id,
        title: todo.title,
        completed: value ?? false,
      );
    });
  }

  void _remove(Todo todo) {
    final index = _items.indexWhere((t) => t.id == todo.id);
    setState(() {
      _items.removeWhere((t) => t.id == todo.id);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${todo.title}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _items.insert(index, todo);
            });
          },
        ),
      ),
    );
  }

  void _showAddDialog() {
    _input.clear();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('New todo'),
          content: TextField(controller: _input, autofocus: true),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _add();
                Navigator.pop(ctx);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;

    return Scaffold(
      appBar: AppBar(title: Text('Todos (${_doneCount()}/${_items.length})')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _filter = value.isEmpty ? null : value;
                });
              },
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: visible.length,
              itemBuilder: (context, i) {
                final todo = visible[i];

                return Dismissible(
                  key: ValueKey(todo.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _remove(todo),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: TodoTile(
                    todo: todo,
                    onChanged: (value) => _toggle(todo, value),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoTile extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool?> onChanged;

  const TodoTile({super.key, required this.todo, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(value: todo.completed, onChanged: onChanged),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }
}
