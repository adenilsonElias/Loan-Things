import 'package:flutter/material.dart';
import 'package:rent_thing/model/emprestimo.dart';

class LoanCard extends StatelessWidget {
  final LoanModel emprestimo;

  LoanCard(this.emprestimo);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Row(
        children: [
          Container(
            width: 64,
            height: 100,
            child: Center(
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _colorStatus(emprestimo.status)),
              ),
            ),
          ),
          Container(
            width: 5,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  emprestimo.formatedDataEmprestimo,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                Text(emprestimo.nomeItem,
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center),
                Text(emprestimo.nomePessoa,
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center),
                Text(
                    emprestimo.dataLimite == 0
                        ? "Sem data de entrega"
                        : emprestimo.formatedDataLimite +
                            (emprestimo.status == DEVOLVIDOATRASADO
                                ? " - Devolvido atrasado"
                                : ""),
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center),
              ],
            ),
          )
        ],
      ),
    );
  }

  Color _colorStatus(int status) {
    switch (status) {
      case EMPRESTADO:
        return Color(0xffFAFF0E);
      case DEVOLVIDO:
      case DEVOLVIDOATRASADO:
        return Colors.lightGreen;
      case ATRASADO:
        return Color(0xFFFF0000);
    }
  }
}
