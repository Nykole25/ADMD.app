import 'dart:math';

import 'package:dio/dio.dart';

import '../models/todo.dart';

final _dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));

/// JSON-ul este decodat doar în această funcție.
/// [path] poate fi '/nope' pentru a testa eșecul (404).
Future<List<Todo>> fetchTodos({String path = '/todos'}) async {
  final res = await _dio.get(path);
  final raw = res.data as List<dynamic>;
  return raw.map((j) => Todo.fromJson(j as Map<String, dynamic>)).toList();
}

/// Reîncearcă [op] de maximum [maxAttempts] ori, cu backoff exponențial
/// (400, 800, 1600, 3200 ms) plus jitter aleator.
/// [onLog] primește o linie pentru fiecare încercare.
Future<T> withRetry<T>(
  Future<T> Function() op, {
  int maxAttempts = 5,
  void Function(String message)? onLog,
}) async {
  final random = Random();
  for (var i = 0; ; i++) {
    try {
      onLog?.call('Attempt ${i + 1}/$maxAttempts...');
      return await op();
    } catch (e) {
      if (i == maxAttempts - 1) {
        onLog?.call('Attempt ${i + 1} failed. Giving up.');
        rethrow;
      }
      final base = 400 * (1 << i);
      final delay = base + random.nextInt(base);
      onLog?.call(
        'Attempt ${i + 1} failed. Retrying in ${delay}ms '
        '(base $base + jitter ${delay - base})',
      );
      await Future.delayed(Duration(milliseconds: delay));
    }
  }
}
