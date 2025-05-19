import 'package:bridgecare/features/bridge_management/inspection/models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseService {
  static Database? _database;
  static const String _dbName = 'form_app.db';
  static const String _imagesTable = 'images';
  static const String _formsTable = 'forms';
  static const String _queueTable = 'queue';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = path.join(documentsDirectory.path, _dbName);
    return await openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_imagesTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            inspeccion_uuid TEXT NOT NULL,
            componente_uuid TEXT NOT NULL,
            image_uuid TEXT NOT NULL UNIQUE,
            puente_id TEXT NOT NULL,
            upload_status TEXT NOT NULL DEFAULT 'pending',
            chunk_count INTEGER NOT NULL DEFAULT 0,
            chunks_uploaded INTEGER NOT NULL DEFAULT 0,
            local_path TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE $_formsTable (
            inspeccion_uuid TEXT PRIMARY KEY,
            payload TEXT NOT NULL,
            submit_status TEXT NOT NULL DEFAULT 'pending',
            created_at TEXT NOT NULL,
            puente_id TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE $_queueTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task_type TEXT NOT NULL,
            data TEXT NOT NULL,
            status TEXT NOT NULL DEFAULT 'pending',
            created_at TEXT NOT NULL,
            depends_on TEXT,
            retry_count INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE $_formsTable (
              inspeccion_uuid TEXT PRIMARY KEY,
              payload TEXT NOT NULL,
              submit_status TEXT NOT NULL DEFAULT 'pending',
              created_at TEXT NOT NULL,
              puente_id TEXT NOT NULL
            )
          ''');
          await db.execute('''
            CREATE TABLE $_queueTable (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              task_type TEXT NOT NULL,
              data TEXT NOT NULL,
              status TEXT NOT NULL DEFAULT 'pending',
              created_at TEXT NOT NULL,
              depends_on TEXT,
              retry_count INTEGER NOT NULL DEFAULT 0
            )
          ''');
        }
      },
    );
  }

  Future<void> insertImage(ImageData image) async {
    final db = await database;
    await db.insert(
      _imagesTable,
      image.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ImageData>> getImagesByFormAndSection(
    String inspeccionUuid,
    String? componenteUuid,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;
    if (componenteUuid == null) {
      maps = await db.query(
        _imagesTable,
        where: 'inspeccion_uuid = ?',
        whereArgs: [inspeccionUuid],
      );
    } else {
      maps = await db.query(
        _imagesTable,
        where: 'inspeccion_uuid = ? AND componente_uuid = ?',
        whereArgs: [inspeccionUuid, componenteUuid],
      );
    }
    return maps.map((map) => ImageData.fromMap(map)).toList();
  }

  Future<void> insertForm(
    String inspeccionUuid,
    String payload,
    String puenteId,
  ) async {
    final db = await database;
    await db.insert(
        _formsTable,
        {
          'inspeccion_uuid': inspeccionUuid,
          'payload': payload,
          'submit_status': 'pending',
          'created_at': DateTime.now().toIso8601String(),
          'puente_id': puenteId,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getPendingForms() async {
    final db = await database;
    return await db.query(
      _formsTable,
      where: 'submit_status = ?',
      whereArgs: ['pending'],
    );
  }

  Future<void> updateFormStatus(String inspeccionUuid, String status) async {
    final db = await database;
    await db.update(
      _formsTable,
      {'submit_status': status},
      where: 'inspeccion_uuid = ?',
      whereArgs: [inspeccionUuid],
    );
  }

  Future<void> enqueueTask({
    required String taskType,
    required String data,
    String? dependsOn,
    String? inspeccionUuid,
  }) async {
    final db = await database;
    await db.insert(_queueTable, {
      'task_type': taskType,
      'data': data,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
      'depends_on': dependsOn,
      'retry_count': 0,
    });
  }

  Future<List<Map<String, dynamic>>> getPendingTasks() async {
    final db = await database;
    return await db.query(
      _queueTable,
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'created_at ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getFailedTasks() async {
    final db = await database;
    return await db.query(
      _queueTable,
      where: 'status = ?',
      whereArgs: ['failed'],
    );
  }

  Future<void> updateTaskStatus(int taskId, String status) async {
    final db = await database;
    await db.update(
      _queueTable,
      {'status': status},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<void> incrementRetryCount(int taskId) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE $_queueTable SET retry_count = retry_count + 1 WHERE id = ?',
      [taskId],
    );
  }
}
