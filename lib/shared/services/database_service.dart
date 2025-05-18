import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'bridgecare.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE image_chunks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          image_id TEXT,
          chunk_index INTEGER,
          data TEXT,
          retry_count INTEGER,
          timestamp TEXT,
          initiated INTEGER,
          filename TEXT,
          bridge_id INTEGER,
          inspection_id TEXT,
          component_key TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE inspection_queue (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          inspection_id TEXT,
          bridge_id INTEGER,
          data TEXT,
          retry_count INTEGER,
          timestamp TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE image_urls (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          inspection_id TEXT,
          component_key TEXT,
          url TEXT
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
          CREATE TABLE image_urls (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            inspection_id TEXT,
            component_key TEXT,
            url TEXT
          )
        ''');
        }
      },
    );
  }

  Future<void> updateInspectionId(String oldId, String newId) async {
    final db = await database;
    await db.update(
      'image_chunks',
      {'inspection_id': newId.toString()},
      where: 'inspection_id = ?',
      whereArgs: [oldId],
    );
    await db.update(
      'inspection_queue',
      {'inspection_id': newId.toString()},
      where: 'inspection_id = ?',
      whereArgs: [oldId],
    );
    await db.update(
      'image_urls',
      {'inspection_id': newId.toString()},
      where: 'inspection_id = ?',
      whereArgs: [oldId],
    );
  }

  Future<List<String>> getImageUrls(
      String inspectionId, String componentKey) async {
    final db = await database;
    final result = await db.query(
      'image_urls',
      where: 'inspection_id = ? AND component_key = ?',
      whereArgs: [inspectionId, componentKey],
    );
    return result.map((row) => row['url'] as String).toList();
  }

  Future<void> insertInspectionJson(Map<String, dynamic> json) async {
    final db = await database;
    await db.insert('inspection_queue', json);
  }

  Future<Map<String, dynamic>?> getInspectionJson(String inspectionId) async {
    final db = await database;
    final result = await db.query('inspection_queue',
        where: 'inspection_id = ?', whereArgs: [inspectionId], limit: 1);
    return result.isNotEmpty ? result[0] : null;
  }

  Future<List<Map<String, dynamic>>> getQueuedInspections() async {
    final db = await database;
    return await db.query('inspection_queue');
  }

  Future<bool> hasSubmittedInspections() async {
    final db = await database;
    final result = await db.query('inspection_queue',
        where: 'submitted = ?', whereArgs: [1], limit: 1);
    return result.isNotEmpty;
  }

  Future<void> insertImageChunk(Map<String, dynamic> chunk) async {
    final db = await database;
    await db.insert('image_chunks', chunk);
  }

  Future<void> updateImageChunk(int id, Map<String, dynamic> updates) async {
    final db = await database;
    await db.update('image_chunks', updates, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateImageChunks(
      String imageId, Map<String, dynamic> updates) async {
    final db = await database;
    await db.update('image_chunks', updates,
        where: 'image_id = ?', whereArgs: [imageId]);
  }

  Future<void> deleteImageChunk(int id) async {
    final db = await database;
    await db.delete('image_chunks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getImageChunks(String imageId) async {
    final db = await database;
    return await db
        .query('image_chunks', where: 'image_id = ?', whereArgs: [imageId]);
  }

  Future<List<Map<String, dynamic>>> getQueuedImages() async {
    final db = await database;
    return await db.query('image_chunks',
        columns: [
          'image_id',
          'filename',
          'bridge_id',
          'inspection_id',
          'component_key'
        ],
        distinct: true);
  }

  Future<int> getImageQueueCount() async {
    final db = await database;
    final result = await db
        .rawQuery('SELECT COUNT(DISTINCT image_id) as count FROM image_chunks');
    return result[0]['count'] as int;
  }

  Future<void> updateInspectionJson(
      int id, Map<String, dynamic> updates) async {
    final db = await database;
    await db
        .update('inspection_queue', updates, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteInspectionJson(int id) async {
    final db = await database;
    await db.delete('inspection_queue', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getJsonQueueCount() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT COUNT(*) as count FROM inspection_queue');
    return result[0]['count'] as int;
  }

  Future<void> storeImageUrl(
      String inspectionId, String componentKey, String url) async {
    final db = await database;
    await db.insert('image_urls', {
      'inspection_id': inspectionId.toString(),
      'component_key': componentKey,
      'url': url,
    });
  }
}
