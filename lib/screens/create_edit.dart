import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rent_thing/controller/create_edit_controller.dart';
import 'package:rent_thing/controller/emprestimoController.dart';
import 'package:rent_thing/model/emprestimo.dart';

class CreateEditEmprestimo extends StatefulWidget {
  final LoanModel loan;
  final EmprestimoController controller;

  CreateEditEmprestimo(this.controller, {this.loan});

  @override
  _CreateEditEmprestimoState createState() => _CreateEditEmprestimoState();
}

class _CreateEditEmprestimoState extends State<CreateEditEmprestimo> {
  MaskTextInputFormatter maskTextInputFormatter = MaskTextInputFormatter(
    mask: "##/##/####",
  );
  TextEditingController _nomeItemController = TextEditingController();
  TextEditingController _nomePessoaController = TextEditingController();
  TextEditingController _dataEmprestimoController = TextEditingController();
  TextEditingController _dataLimiteController = TextEditingController();
  EmprestimoController _emprestimoController;

  Loan loan;

  @override
  void initState() {
    _nomeItemController.addListener(() {
      loan.nomeItem = _nomeItemController.text;
    });
    _nomePessoaController.addListener(() {
      loan.nomePessoa = _nomePessoaController.text;
    });
    _dataLimiteController.addListener(() {
      loan.dataLimite = _dataLimiteController.text;
    });
    _dataEmprestimoController.addListener(() {
      loan.dataEmprestimo = _dataEmprestimoController.text;
    });
    super.initState();
    _emprestimoController = widget.controller;
    if (widget.loan != null) {
      loan = Loan.withLoan(widget.loan);
      _nomeItemController.text = widget.loan.nomeItem;
      _nomePessoaController.text = widget.loan.nomePessoa;
      _dataEmprestimoController.text = widget.loan.formatedDataEmprestimo;
      _dataLimiteController.text = widget.loan.formatedDataLimite;
      return;
    }
    loan = Loan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.loan == null ? "Adicionar" : "Editar"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                if (widget.loan == null) {
                  loan.createEmprestimo(_emprestimoController).then((value) {
                    if (value) {
                      Navigator.of(context).pop(true);
                    }
                  });
                } else {
                  loan.editEmprestimo(_emprestimoController).then((value) {
                    if (value == true) {
                      Navigator.of(context).pop(true);
                    }
                  });
                }
              })
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Observer(builder: (_) {
                    return TextField(
                      controller: _nomeItemController,
                      decoration: InputDecoration(
                          hintText: "Nome do item",
                          errorText:
                              loan.nomeItemValid ? null : "Nome invalido"),
                    );
                  }),
                  Observer(builder: (_) {
                    return TextField(
                      controller: _nomePessoaController,
                      decoration: InputDecoration(
                          hintText: "Nome da pessoa",
                          errorText:
                              loan.nomePessoaValid ? null : "Nome invalido"),
                    );
                  }),
                  Observer(builder: (_) {
                    return TextField(
                      enabled: widget.loan == null
                          ? true
                          : widget.loan.status == EMPRESTADO ||
                              widget.loan.status == ATRASADO,
                      controller: _dataEmprestimoController,
                      decoration: InputDecoration(
                        hintText: "Data do emprestimo",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(
                                  2999,
                                )).then((DateTime value) {
                              _dataEmprestimoController.value =
                                  TextEditingValue(
                                text:
                                    "${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}",
                              );
                            });
                          },
                        ),
                        errorText:
                            loan.dataEmprestimoValid ? null : "Data invalida",
                      ),
                      inputFormatters: [maskTextInputFormatter],
                      keyboardType: TextInputType.datetime,
                    );
                  }),
                  Observer(builder: (_) {
                    return TextField(
                      enabled: widget.loan == null
                          ? true
                          : widget.loan.status == EMPRESTADO ||
                              widget.loan.status == ATRASADO,
                      controller: _dataLimiteController,
                      decoration: InputDecoration(
                        hintText: "Data limite do emprestimo",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(
                                  2999,
                                )).then((DateTime value) {
                              _dataLimiteController.value = TextEditingValue(
                                text:
                                    "${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}",
                              );
                            });
                          },
                        ),
                        errorText:
                            loan.dataLimiteValid ? null : "Data invalida",
                      ),
                      inputFormatters: [maskTextInputFormatter],
                      keyboardType: TextInputType.datetime,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
