import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/database/migrations/database_admin_connection.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/new_task/new_task_controller.dart';
import 'package:todo_list/app/modules/new_task/new_task_page.dart';
import 'package:todo_list/app/repositories/todos_repository.dart';

import 'app/modules/home/home_page.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  DatabaseAdminConnection databaseAdminConnection = DatabaseAdminConnection();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(databaseAdminConnection);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(databaseAdminConnection);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => TodosRepository(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo List',
        theme: ThemeData(
          primaryColor: Color(0xFFFF9129),
          buttonColor: Color(0xFFFF9129),
          textTheme: GoogleFonts.robotoTextTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          NewTaskPage.routerName: (_) => ChangeNotifierProvider(
                child: NewTaskPage(),
                create: (context) {
                  var day = ModalRoute.of(_).settings.arguments;
                  return NewTaskController(
                    repository: context.read<TodosRepository>(),
                    day: day,
                  );
                },
              )
        },
        home: ChangeNotifierProvider(
          child: HomePage(),
          create: (context) => HomeController(
            repository: context.read<TodosRepository>(),
          ),
        ),
      ),
    );
  }
}
