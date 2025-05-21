// lib/services/local_log_service.dart
import 'package:LangPocket/database_helper.dart'; // Assuming project name LangPocket
import 'package:sqflite/sqflite.dart';

class LocalLogService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> logErrorLocal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        'AppLogs', // Anticipating 'AppLogs' table
        {
          'timestamp': DateTime.now().toIso8601String(),
          'message': message,
          'error': error?.toString(),
          'stackTrace': stackTrace?.toString(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('LocalLogService: Logged error to local DB - $message');
    } catch (e) {
      print('LocalLogService: CRITICAL - Failed to log error to local DB: $e');
      print('Original error: $message, Error: $error');
    }
  }

  Future<List<Map<String, dynamic>>> getLogs({
    int limit = 15,
    int offset = 0,
  }) async {
    try {
      final db = await _dbHelper.database;
      return await db.query(
        'AppLogs',
        orderBy: 'timestamp DESC',
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      print('LocalLogService: Failed to get logs: $e');
      return [];
    }
  }

  Future<int> getLogCount() async {
    try {
      final db = await _dbHelper.database;
      final result = await db.rawQuery('SELECT COUNT(*) FROM AppLogs');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print('LocalLogService: Failed to get log count: $e');
      return 0;
    }
  }

  Future<void> purgeLogs() async {
    try {
      final db = await _dbHelper.database;
      await db.delete('AppLogs');
      print('LocalLogService: Purged all logs from local DB.');
    } catch (e) {
      print('LocalLogService: Failed to purge logs: $e');
    }
  }
}
