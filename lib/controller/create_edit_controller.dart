import 'package:mobx/mobx.dart';
import 'package:rent_thing/controller/emprestimoController.dart';
import 'package:rent_thing/model/emprestimo.dart';

part 'create_edit_controller.g.dart';

const REGEX =
    r"^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})";
class Loan = LoanBase with _$Loan;

abstract class LoanBase with Store {
  LoanBase.withLoan(LoanModel loanItem) {
    _nomeItem = loanItem.nomeItem;
    _nomePessoa = loanItem.nomePessoa;
    _dataEmprestimo = loanItem.dataEmprestimo;
    _dataLimite = loanItem.dataLimite;
    id = loanItem.id;
    status = loanItem.status;
  }

  LoanBase();
  int id;
  int status;
  @observable
  String _nomeItem = "";
  @observable
  String _nomePessoa = "";
  @observable
  int _dataEmprestimo;
  @observable
  int _dataLimite;
  @observable
  bool dataEmprestimoValid = false;
  @observable
  bool dataLimiteValid = true;
  @observable
  bool nomeItemValid = false;
  @observable
  bool nomePessoaValid = false;

  set nomeItem(String value) {
    if (value.length > 0) {
      nomeItemValid = true;
    }
    runInAction(() => _nomeItem = value);
  }

  set nomePessoa(String value) {
    if (value.length > 0) {
      nomePessoaValid = true;
    }
    runInAction(() => _nomePessoa = value);
  }

  set dataEmprestimo(String value) {
    int data;
    if (value.isEmpty || value.length < 10 || !RegExp(REGEX).hasMatch(value)) {
      dataEmprestimoValid = false;
      data = null;
      return;
    }
    dataEmprestimoValid = true;
    var broken = value.split("/");
    data = int.parse("${broken[2]}${broken[1]}${broken[0]}");
    runInAction(() => _dataEmprestimo = data);
  }

  set dataLimite(String value) {
    int data;
    if (value.length > 0 &&
        (value.length < 10 || !RegExp(REGEX).hasMatch(value))) {
      dataLimiteValid = false;
      data = null;
      return;
    }
    dataLimiteValid = true;
    if (value.length > 0) {
      var broken = value.split("/");
      data = int.parse("${broken[2]}${broken[1]}${broken[0]}");
    }
    runInAction(() => _dataLimite = data);
  }

  Future<bool> createEmprestimo(
      EmprestimoController emprestimoController) async {
    if (nomeItemValid == true &&
        nomePessoaValid == true &&
        dataEmprestimoValid == true &&
        dataEmprestimoValid == true) {
      var emprestimo = LoanModel(
          nomeItem: _nomeItem,
          nomePessoa: _nomePessoa,
          dataEmprestimo: _dataEmprestimo,
          dataLimite: _dataLimite != null ? _dataLimite : 0,
          status: EMPRESTADO);
      if (emprestimo.dataLimite > 0 &&
          emprestimo.dataLimite < emprestimo.dataEmprestimo) {
        dataLimiteValid = false;
        return false;
      }
      return await emprestimoController.create(emprestimo);
    }
    return false;
  }

  Future<bool> editEmprestimo(EmprestimoController emprestimoController) async {
    if (nomeItemValid == true &&
        nomePessoaValid == true &&
        dataEmprestimoValid == true &&
        dataEmprestimoValid == true) {
      var now = DateTime.now();
      int timeNowItem = int.parse(
          "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}");
      int statusLocal = status;
      if (status == EMPRESTADO &&
          _dataLimite > 0 &&
          _dataLimite < timeNowItem) {
        statusLocal = ATRASADO;
      }
      var emprestimo = LoanModel(
        id: id,
        nomeItem: _nomeItem,
        nomePessoa: _nomePessoa,
        dataEmprestimo: _dataEmprestimo,
        dataLimite: _dataLimite != null ? _dataLimite : 0,
        status: statusLocal,
      );
      if (emprestimo.dataLimite > 0 &&
          emprestimo.dataLimite < emprestimo.dataEmprestimo) {
        dataLimiteValid = false;
        return false;
      }
      return await emprestimoController.update(emprestimo);
    }
    return false;
  }
}
