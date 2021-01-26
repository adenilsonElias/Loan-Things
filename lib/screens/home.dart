import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rent_thing/cards/emprestimo.dart';
import 'package:rent_thing/controller/emprestimoController.dart';
import 'package:rent_thing/controller/homeController.dart';
import 'package:rent_thing/model/emprestimo.dart';
import 'package:rent_thing/screens/create_edit.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SlidableController _slidableController = SlidableController();
  HomeController _homeController;
  EmprestimoController _emprestimoController;

  @override
  void initState() {
    _emprestimoController = context.read<EmprestimoController>();
    _homeController = HomeController(_emprestimoController);
    _homeController.loadList();
    super.initState();
  }

  @override
  void dispose() {
    _homeController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emprestimo"),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(Icons.sort),
            ),
            onSelected: (String value) {
              _homeController.loadList(filter: value);
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text("Item"),
                  value: NOMEITEM,
                ),
                PopupMenuItem(
                  child: Text("Pessoa"),
                  value: NOMEPESSOA,
                ),
                PopupMenuItem(
                  child: Text("Data"),
                  value: DATAEMPRESTIMO,
                ),
                PopupMenuItem(
                  child: Text("Status"),
                  value: STATUS,
                ),
              ];
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push<bool>(MaterialPageRoute(
            builder: (context) => CreateEditEmprestimo(_emprestimoController),
          ))
              .then((value) {
            if (value == true) {
              _homeController.loadList();
            }
          });
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: Observer(builder: (_) {
        return Container(
          color: Colors.transparent,
          padding: EdgeInsets.all(10),
          child: _homeController.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  itemBuilder: (context, index) {
                    if (_homeController.observableListLoan.length != index) {
                      return Slidable(
                          controller: _slidableController,
                          actionPane: SlidableScrollActionPane(),
                          key: Key(_homeController.observableListLoan[index].id
                              .toString()),
                          child: LoanCard(
                              _homeController.observableListLoan[index]),
                          actions: _actions(
                              index,
                              _homeController
                                  .observableListLoan[index].status));
                    }
                    return Container(
                      height: 70,
                    );
                  },
                  itemCount: _homeController.observableListLoan.length + 1,
                ),
        );
      }),
    );
  }

  List<Widget> _actions(int index, int status) {
    List<Widget> actions = [
      Container(
        height: 100,
        child: IconSlideAction(
          iconWidget: Icon(
            Icons.edit,
            size: 40,
          ),
          closeOnTap: false,
          onTap: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute<bool>(
                builder: (context) => CreateEditEmprestimo(
                  _emprestimoController,
                  loan: _homeController.observableListLoan[index],
                ),
              ),
            )
                .then((value) {
              if (value == true) {
                _homeController.loadList();
              }
            });
            _slidableController.activeState.close();
          },
        ),
      ),
      Container(
        height: 100,
        child: IconSlideAction(
          iconWidget: Icon(
            Icons.delete,
            size: 40,
            color: Colors.red,
          ),
          closeOnTap: false,
          onTap: () {
            _homeController
                .deleteEmprestimo(_homeController.observableListLoan[index].id);
          },
        ),
      ),
    ];
    if (status == DEVOLVIDO || status == DEVOLVIDOATRASADO) {
      return actions;
    }
    actions.insert(
      0,
      Container(
        height: 100,
        child: IconSlideAction(
          iconWidget: Icon(
            Icons.done,
            color: Colors.green,
            size: 40,
          ),
          closeOnTap: false,
          onTap: () {
            _homeController
                .returnLoan(_homeController.observableListLoan[index]);
            _slidableController.activeState.close();
          },
        ),
      ),
    );
    return actions;
  }
}
