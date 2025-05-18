import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'translations.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create the Vocabulary table
    await db.execute('''
      CREATE TABLE Vocabulary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        Name TEXT NOT NULL UNIQUE
      )
    ''');

    // Pre-fill the Vocabulary table
    await db.execute('INSERT INTO Vocabulary (Name) VALUES ("Emotions")');
    await db.execute('INSERT INTO Vocabulary (Name) VALUES ("Shopping")');
    await db.execute('INSERT INTO Vocabulary (Name) VALUES ("Small talk")');
    await db.execute('INSERT INTO Vocabulary (Name) VALUES ("Travel")');
    await db.execute('INSERT INTO Vocabulary (Name) VALUES ("City")');

    // Create the Translations table with a foreign key and index
    await db.execute('''
      CREATE TABLE Translations(
        vocabulary INTEGER NOT NULL,
        original_word TEXT NOT NULL,
        word_level TEXT NOT NULL,
        origin_lang TEXT NOT NULL,
        transl_word TEXT NOT NULL,
        transl_code TEXT NOT NULL,
        learned INTEGER,
        FOREIGN KEY (vocabulary) REFERENCES Vocabulary(id)
      )
    ''');
    await db.execute('CREATE INDEX idx_translations_vocabulary ON Translations(vocabulary)'); // Index on vocabulary (now INTEGER ID)
  }

  Future<List<Map<String, dynamic>>> getVocabularies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Vocabulary', columns: ['Name', 'id']);
    return List.generate(maps.length, (i) {
      return {'id': maps[i]['id'] as int, 'Name': maps[i]['Name'] as String};
    });
  }

  Future<bool> checkIfTopicExists(
      String topic,
      String level,
      String languageCode) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT COUNT(*) FROM Translations t
      JOIN Vocabulary v ON t.vocabulary = v.id
      WHERE v.Name = ? AND t.word_level = ? AND t.transl_code = ?
      ''',
      [topic, level, languageCode],
    );

    int? count = Sqflite.firstIntValue(result);
    return count != null && count > 0;
  }
}
