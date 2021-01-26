import 'package:mobx/mobx.dart';
import 'package:rent_thing/controller/emprestimoController.dart';
import 'package:rent_thing/model/emprestimo.dart';
part 'homeController.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  EmprestimoController _emprestimoController;
  @observable
  ObservableList<LoanModel> observableListLoan;
  @observable
  bool isLoading = false;

  _HomeControllerBase(this._emprestimoController);

  @action
  void loadList({String filter}) {
    isLoading = true;
    _emprestimoController.getAllLoan(filter: filter).then((value) {
      observableListLoan = value.asObservable();
      isLoading = false;
    });
  }

  @action
  void returnLoan(LoanModel loan) {
    isLoading = true;
    if (loan.status == EMPRESTADO) {
      loan.status = DEVOLVIDO;
    } else {
      loan.status = DEVOLVIDOATRASADO;
    }
    _emprestimoController.update(loan).then((value) {
      isLoading = false;
      if (value == true) {
        loadList();
      }
    });
    return;
  }

  @action
  void deleteEmprestimo(int id) {
    isLoading = true;
    _emprestimoController.deleteLoan(id).then((value) {
      isLoading = false;
      if (value == true) {
        loadList();
      }
    });
  }
}
