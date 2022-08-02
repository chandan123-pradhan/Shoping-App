import 'package:manek_tech_practicle/models/Item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_database_example/model/note.dart';

class ProductDatabase {
  static final ProductDatabase instance = ProductDatabase._init();

  static Database? _database;

  ProductDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('shoping.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute(
        '''
CREATE TABLE $tableNotes ( 
  ${ItemFields.id} $idType, 
  ${ItemFields.fetureImage} $textType,
  ${ItemFields.price} $integerType,
  ${ItemFields.title} $textType,
  ${ItemFields.description} $textType,
  ${ItemFields.productId} $textType
  )
''');
  }

  Future<Item> create(Item note) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${ItemFields.title}, ${ItemFields.description}, ${ItemFields.time}';
    // final values =
    //     '${json[ItemFields.title]}, ${json[ItemFields.description]}, ${json[ItemFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Item> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: ItemFields.values,
      where: '${ItemFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Item.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Item>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${ItemFields.productId} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Item.fromJson(json)).toList();
  }

  Future<int> update(Item note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${ItemFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${ItemFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
