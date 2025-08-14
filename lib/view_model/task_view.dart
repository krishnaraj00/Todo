import 'package:flutter/material.dart';
import '../data/task_data.dart';
import '../model/model_class.dart';


enum Filter { all, completed, pending }

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [];
  Filter _filter = Filter.all;

  List<Task> get tasks {
    switch (_filter) {
      case Filter.completed:
        return _tasks.where((t) => t.isCompleted).toList();
      case Filter.pending:
        return _tasks.where((t) => !t.isCompleted).toList();
      case Filter.all:
      default:
        return _tasks;
    }
  }

  Filter get filter => _filter;

  void setFilter(Filter filter) {
    _filter = filter;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _tasks = await DatabaseHelper().getTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await DatabaseHelper().insertTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await DatabaseHelper().updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper().deleteTask(id);
    await loadTasks();
  }
}
