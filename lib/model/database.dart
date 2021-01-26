import 'package:path/path.dart';
import 'package:rent_thing/model/emprestimo.dart';
import 'package:sqflite/sqflite.dart';

String setLateLoanQuery = """
    UPDATE emprestimo
    SET $STATUS = ?
    WHERE ($STATUS = $EMPRESTADO) AND (NOT ($DATALIMITE = 0)) AND ($DATALIMITE < ?)
  """;

Future<void> setLoanlates(Database db) async {
  var now = DateTime.now();
  int timeNowItem = int.parse(
      "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}");

  await db.rawUpdate(setLateLoanQuery, [ATRASADO, timeNowItem]);
}

class DatabaseLoan {
  Database _db;

  Database get db {
    return _db;
  }

  void _createTableEmprestimoV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS emprestimo');
    batch.execute('''
    CREATE TABLE emprestimo (
      $LOANID INTEGER PRIMARY KEY AUTOINCREMENT,
      $NOMEITEM TEXT,
      $NOMEPESSOA TEXT,
      $DATAEMPRESTIMO INTEGER,
      $DATALIMITE INTEGER,
      $STATUS INTEGER
    )
    ''');
  }

  Future<void> createDbConnection() async {
    _db = await openDatabase(
      join(
        await getDatabasesPath(),
        'loanDb.db',
      ),
      version: 1,
      onCreate: (db, version) async {
        var batch = db.batch();
        _createTableEmprestimoV1(batch);
        await batch.commit();
      },
      onDowngrade: onDatabaseDowngradeDelete,
      onUpgrade: (db, oldVersion, newVersion) {},
      onOpen: (db) async {
        await setLoanlates(db);
      },
    );
  }
}
