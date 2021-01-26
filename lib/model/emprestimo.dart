import 'package:flutter/cupertino.dart';

const EMPRESTADO = 0;
const DEVOLVIDO = 1;
const ATRASADO = 2;
const DEVOLVIDOATRASADO = 3;

const LOANID = 'id';
const NOMEITEM = 'nome_item';
const NOMEPESSOA = 'nome_pessoa';
const DATAEMPRESTIMO = 'data_emprestimo';
const DATALIMITE = 'data_limite';
const STATUS = "status";

class LoanModel {
  int id;
  String nomeItem;
  String nomePessoa;
  int dataEmprestimo;
  int dataLimite;
  int status;

  String get formatedDataEmprestimo {
    // no banco 20210111
    return "${(dataEmprestimo % 100).truncate().toString().padLeft(2, '0')}/${((dataEmprestimo / 100).truncate() % 100).truncate().toString().padLeft(2, '0')}/${(dataEmprestimo / 10000).truncate()}";
  }

  String get formatedDataLimite {
    // no banco 20210111
    print(dataLimite);
    if (dataLimite != 0) {
      return "${(dataLimite % 100).truncate().toString().padLeft(2, '0')}/${((dataLimite / 100).truncate() % 100).truncate().toString().padLeft(2, '0')}/${(dataLimite / 10000).truncate()}";
    }
    return "";
  }

  LoanModel({
    this.id,
    @required this.nomeItem,
    @required this.nomePessoa,
    @required this.dataEmprestimo,
    @required this.dataLimite,
    @required this.status,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map[NOMEITEM] = nomeItem;
    map[NOMEPESSOA] = nomePessoa;
    map[DATAEMPRESTIMO] = dataEmprestimo;
    map[DATALIMITE] = dataLimite;
    map[STATUS] = status;
    if (id != null) {
      map[LOANID] = id;
    }
    return map;
  }

  LoanModel.fromMap(Map<String, dynamic> value) {
    nomeItem = value[NOMEITEM];
    nomePessoa = value[NOMEPESSOA];
    dataEmprestimo = value[DATAEMPRESTIMO];
    dataLimite = value[DATALIMITE];
    status = value[STATUS];
    if (value[LOANID] != null) {
      id = value[LOANID];
    }
  }

  @override
  String toString() {
    return "$nomeItem $nomePessoa $dataEmprestimo $dataLimite $id $status";
  }
}
