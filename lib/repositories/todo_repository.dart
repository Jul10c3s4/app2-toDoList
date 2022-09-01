import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

const todoListKey = "todo_List";

class TodoRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();

    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Todo.FromJson(e)).toList();
  }

  /*void saveTodoList(List<Todo> todos) {
    final String jsonString = json.encode(todos);
    sharedPreferences.setString('todo_List', jsonString);
  }*/

  void saveTodoList(List<Todo> todos) async {
    final jsonString = json.encode(todos);

    sharedPreferences.setString(todoListKey, jsonString);
  }

  /*Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Todo.FromJson(e)).toList();
  }*/
}
