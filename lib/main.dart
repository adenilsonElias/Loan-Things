import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_thing/controller/emprestimoController.dart';
import 'package:rent_thing/model/database.dart';
import 'package:rent_thing/screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var database = DatabaseLoan();
  database.createDbConnection().then((value) {
    var controller = EmprestimoController(database.db);
    runApp(MyApp(controller));
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  EmprestimoController _emprestimoController;
  MyApp(this._emprestimoController);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rent Thing Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(bodyText2: TextStyle(fontWeight: FontWeight.w500)),
        scaffoldBackgroundColor: Color(0xFF0CB8E8),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 36,
            ),
          ),
        ),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Color(0xFF0085FF)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Provider(
        create: (context) => _emprestimoController,
        child: HomeScreen(),
      ),
    );
  }
}
