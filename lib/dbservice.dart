import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Dbservice {
  static final Dbservice _instance = Dbservice._internal();
  factory Dbservice() => _instance;
  Dbservice._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'passwords.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE passwords (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            password TEXT,
            service_id TEXT,
            account_id TEXT
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getPasswords() async {
    final db = await database;
    return await db.query('passwords');
  }

  Future<void> insertPassword(String password, String serviceId, String accountId) async {
    final db = await database;

    final formattedServiceId = _capitalizeFirstLetter(serviceId);

    await db.insert(
      'passwords',
      {'password': password, 'service_id': formattedServiceId, 'account_id': accountId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deletePassword(String id) async {
    final db = await database;
    await db.delete(
      'passwords',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }
}