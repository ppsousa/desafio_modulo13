import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:todo_list/app/models/todo_model.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/new_task/new_task_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _scaffoldkey = GlobalKey<ScaffoldState>();

  showAlertDialog(
      BuildContext context, HomeController controller, TodoModel todo) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Excluir"),
      onPressed: () {
        setState(
          () {
            controller.repository.removerTodo(todo);
          },
        );
        _scaffoldkey.currentState.showSnackBar(
          SnackBar(
            content: Text('Todo ${todo.descricao} excluído com sucesso!!!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
        controller.findAllForWeek();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Excluir Atividade"),
      content: Text("Confirma a exclusão da atividade ${todo.descricao}?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, HomeController controller, _) {
        return Scaffold(
          key: _scaffoldkey,
          appBar: AppBar(
            title: Text(
              'Atividades',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          bottomNavigationBar: FFNavigationBar(
            onSelectTab: (index) => controller.changeSeletadTab(context, index),
            selectedIndex: controller.selectedTab,
            items: [
              FFNavigationBarItem(
                iconData: Icons.check_circle,
                label: 'Finalizados',
              ),
              FFNavigationBarItem(
                iconData: Icons.view_week,
                label: 'Semanal',
              ),
              FFNavigationBarItem(
                iconData: Icons.calendar_today,
                label: 'Selecionar Data',
              ),
            ],
            theme: FFNavigationBarTheme(
              itemWidth: 60,
              barHeight: 70,
              barBackgroundColor: Theme.of(context).primaryColor,
              unselectedItemIconColor: Colors.white,
              unselectedItemLabelColor: Colors.white,
              selectedItemBorderColor: Colors.white,
              selectedItemIconColor: Colors.white,
              selectedItemBackgroundColor: Theme.of(context).primaryColor,
              selectedItemLabelColor: Colors.black,
            ),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: controller.listTodos?.keys?.length ?? 0,
              itemBuilder: (_, index) {
                var dateFormat = DateFormat('dd/MM/yyyy');
                var listTodos = controller.listTodos;
                var dayKey = listTodos.keys.elementAt(index);
                var day = dayKey;
                var todos = listTodos[dayKey];

                if (todos.isEmpty && controller.selectedTab == 0) {
                  return SizedBox.shrink();
                }

                var today = DateTime.now();
                if (dayKey == dateFormat.format(today)) {
                  day = 'HOJE';
                } else if (dayKey ==
                    dateFormat.format(today.add(Duration(days: 1)))) {
                  day = 'AMANHÃ';
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            day,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          )),
                          IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () async {
                              await Navigator.of(context).pushNamed(
                                  NewTaskPage.routerName,
                                  arguments: dayKey);
                              controller.update();
                            },
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: todos.length,
                      itemBuilder: (_, index) {
                        var todo = todos[index];
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (bool value) =>
                                    controller.checkedOrUncheck(todo),
                                value: todo.finalizado,
                              ),
                              Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  todo.descricao,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      decoration: todo.finalizado
                                          ? TextDecoration.lineThrough
                                          : null),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '${todo.dataHora.hour.toString().padLeft(2, '0')}:${todo.dataHora.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        decoration: todo.finalizado
                                            ? TextDecoration.lineThrough
                                            : null),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      showAlertDialog(
                                          context, controller, todo);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
