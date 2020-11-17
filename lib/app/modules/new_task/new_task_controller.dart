import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:todo_list/app/repositories/todos_repository.dart';

class NewTaskController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TodosRepository repository;
  final dateFormat = DateFormat('dd/MM/yyyy');
  DateTime daySelected;
  TextEditingController nomeTaskController = TextEditingController();
  bool saved = false;
  bool loading = false;
  String error;

  String get dayFormated => dateFormat.format(daySelected);

  NewTaskController({@required this.repository, String day}) {
    daySelected = dateFormat.parse(day);
  }

  Future<void> save() async {
    try {
      if (formKey.currentState.validate()) {
        loading = true;
        saved = false;
        await repository.saveTodo(daySelected, nomeTaskController.text);
        saved = true;
        loading = false;
      }
    } catch (e) {
      error = 'Erro ao salvar Todo';
    }
    this.notifyListeners();
  }
}
