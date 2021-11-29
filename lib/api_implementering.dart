import 'package:http/http.dart' as http;
import 'dart:convert';

String apiNyckel = "cb27666f-8559-4bbc-8f83-83f9d40249a3";
List<ToDoPost> toDoObjects = <ToDoPost>[];

class ToDoPost {
  String id, title;
  bool done;
  ToDoPost(this.id, this.title, this.done);

  factory ToDoPost.fromJson(dynamic json) {
    return ToDoPost(
        json['id'] as String, json['title'] as String, json['done'] as bool);
  }

  @override
  String toString() {
    return title;
  }

  bool get getDone {
    return done;
  }

  String get getId {
    return id;
  }

  String get getTitle {
    return title;
  }

  set setDone(bool isDone) {
    done = isDone;
  }
}

class APIintegration {
  Future<List<ToDoPost>> getList() async {
    //getID();
    String link =
        'https://todoapp-api-pyq5q.ondigitalocean.app/todos?key=$apiNyckel';

    http.Response _todos = await http.get(Uri.parse(link));
    if (_todos.statusCode == 200) {
      var todoObjsJson = jsonDecode(_todos.body) as List;
      toDoObjects =
          todoObjsJson.map((todoJson) => ToDoPost.fromJson(todoJson)).toList();
      return toDoObjects;
    } else {
      throw Exception('failed to get todo list');
    }
  }

  // Future<String> getID() async {
  //   http.Response respons = await http.get(
  //       Uri.parse('https://todoapp-api-pyq5q.ondigitalocean.app/register'));
  //   if (respons.statusCode == 200) {
  //     apiNyckel = respons.body;
  //     return apiNyckel;
  //   } else {
  //     throw Exception('failed to det todo list id');
  //   }
  // }

  List<ToDoPost> returnList() {
    return toDoObjects;
  }

  Future addToList(String titel, bool done) async {
    String link =
        'https://todoapp-api-pyq5q.ondigitalocean.app/todos?key=$apiNyckel';
    final respons = await http.post(
      Uri.parse(link),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "title": titel,
        "done": done,
      }),
    );
    if (respons.statusCode == 200) {
      var responsObjsJson = jsonDecode(respons.body) as List;
      toDoObjects = responsObjsJson
          .map((responsJson) => ToDoPost.fromJson(responsJson))
          .toList();
      return toDoObjects;
    } else {
      throw Exception('failed to update todo list');
    }
  }

  Future updateList(String titel, bool done, String id) async {
    String link =
        'https://todoapp-api-pyq5q.ondigitalocean.app/todos/$id?key=$apiNyckel';
    final respons = await http.put(
      Uri.parse(link),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{
        "title": titel,
        "done": done,
      }),
    );
    if (respons.statusCode == 200) {
      var responsObjsJson = jsonDecode(respons.body) as List;
      toDoObjects =
          responsObjsJson.map((object) => ToDoPost.fromJson(object)).toList();
      return toDoObjects;
    } else {
      throw Exception('failed to update todo list');
    }
  }

  Future removeFromList(String id) async {
    String link =
        'https://todoapp-api-pyq5q.ondigitalocean.app/todos/$id?key=$apiNyckel';
    final http.Response respons = await http.delete(
      Uri.parse(link),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
    );

    if (respons.statusCode == 200) {
      var responsObjsJson = jsonDecode(respons.body) as List;
      toDoObjects = responsObjsJson
          .map((responsJson) => ToDoPost.fromJson(responsJson))
          .toList();
      return toDoObjects;
    } else {
      throw Exception('failed to delete todo');
    }
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
