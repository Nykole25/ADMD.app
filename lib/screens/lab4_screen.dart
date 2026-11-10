import 'package:flutter/material.dart';

import '../api/todo_api.dart';
import '../models/todo.dart';
import 'todo_screen.dart' show TodoTile;

class Lab4Screen extends StatefulWidget {
  const Lab4Screen({super.key});

  @override
  State<Lab4Screen> createState() => _Lab4ScreenState();
}

class _Lab4ScreenState extends State<Lab4Screen> {
  List<Todo> _items = [];
  final List<String> _log = [];
  bool _loading = false;
  bool _useInvalidPath = false;
  String? _error;
  late final String _equalityResult;

  @override
  void initState() {
    super.initState();

    // Task I: două todo-uri identice trebuie să fie egale.
    const a = Todo(userId: 1, id: 1, title: 'test', completed: false);
    const b = Todo(userId: 1, id: 1, title: 'test', completed: false);
    _equalityResult = 'a == b -> ${a == b}';
    // ignore: avoid_print
    print(_equalityResult);

    // Task II: lista se încarcă din API la pornire.
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _log.clear();
    });
    try {
      final todos = await withRetry(
        () => fetchTodos(path: _useInvalidPath ? '/nope' : '/todos'),
        onLog: (m) {
          // ignore: avoid_print
          print(m);
          if (mounted) setState(() => _log.add(m));
        },
      );
      if (mounted) setState(() => _items = todos);
    } catch (e) {
      if (mounted) {
        setState(() {
          _items = [];
          _error = e.toString();
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toggle(Todo todo, bool? value) {
    // Todo are câmpuri final, deci înlocuim obiectul.
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

  int get _doneCount => _items.where((t) => t.completed).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lab 4 ($_doneCount/${_items.length})')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(_equalityResult),
          ),
          SwitchListTile(
            title: const Text('Use invalid path (/nope)'),
            value: _useInvalidPath,
            onChanged: _loading
                ? null
                : (v) => setState(() => _useInvalidPath = v),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: _loading ? null : _load,
                child: const Text('Load'),
              ),
            ),
          ),
          // Log-ul de retry, vizibil pe ecran
          Container(
            width: double.infinity,
            height: 130,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView(
              children: [
                for (final line in _log)
                  Text(line, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          if (_loading) const LinearProgressIndicator(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Error: $_error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, i) {
                final todo = _items[i];
                return TodoTile(
                  todo: todo,
                  onChanged: (value) => _toggle(todo, value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
