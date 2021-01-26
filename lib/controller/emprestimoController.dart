import 'package:rent_thing/model/emprestimo.dart';
import 'package:sqflite/sqlite_api.dart';

const ORDER = ['ASC', 'DESC'];

class EmprestimoController {
  Database _db;

  int sort = 0;

  EmprestimoController(this._db);

  Future<bool> create(LoanModel loanModel) async {
    int quant = await _db.insert('emprestimo', loanModel.toMap());
    if (quant > 0) {
      return true;
    }
    return false;
  }

  Future<bool> update(LoanModel loanModel) async {
    int result = await _db.update('emprestimo', loanModel.toMap(),
        where: '$LOANID = ?', whereArgs: [loanModel.id]);
    if (result > 0) {
      return true;
    }
    return false;
  }

  LoanModel getLoan(int id) {}
  Future<List<LoanModel>> getAllLoan({String filter}) async {
    var orderBy = filter != null ? "$filter ${ORDER[sort]}" : null;
    var rawData = await _db.query('emprestimo', orderBy: orderBy);
    if (filter != null) {
      sort = (sort + 1) % 2;
    }
    return rawData.map((e) => LoanModel.fromMap(e)).toList();
  }

  Future<bool> deleteLoan(int id) async {
    int result =
        await _db.delete('emprestimo', where: 'id = ?', whereArgs: [id]);
    if (result > 0) {
      return true;
    }
    return false;
  }
}
