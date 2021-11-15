import 'package:http/http.dart' as http;
import 'dart:convert';

String apiNyckel = '';
List<ToDoPost> toDoObjects = <ToDoPost>[];

class ToDoPost {
  String id, title;
  bool done;
  ToDoPost(this.id, this.title, this.done);

  factory ToDoPost.fromJson(dynamic json) {
    return ToDoPost(
        json["id"] as String, json["title"] as String, json["done"] as bool);
  }
}

class APIintegration {
  Future _getList() async {
    http.Response _todos = await http.get(Uri.parse(
        'https://todoapp-api-pyq5q.ondigitalocean.app/todos?=$apiNyckel'));

    var todoObjsJson = jsonDecode(_todos.body)['todos'] as List;
    toDoObjects =
        todoObjsJson.map((todoJson) => ToDoPost.fromJson(todoJson)).toList();
  }

  Future<String> _getID() async {
    http.Response respons = await http.get(
        Uri.parse('https://todoapp-api-pyq5q.ondigitalocean.app/register'));
    apiNyckel = respons.body;
    return apiNyckel;
  }

  List<ToDoPost> returnList() {
    _getID();
    _getList();
    return toDoObjects;
  }

  // void _addToInputs(List<_ToDoPost> lista) {
  //   lista.forEach((_ToDoPost) {
  //     _toDoInputs.add(_ToDoPost.title);

  //     if (_ToDoPost.done) {
  //       _done.add(_ToDoPost.title);
  //     }
  //   });
  // }
}
