import 'package:flutter/material.dart';

final List<String> _toDoInputs = <String>[];
final _toDoController = TextEditingController();
final _done = <String>[];

void main() {
  runApp(
    const MaterialApp(
      title: 'To-Do list',
      home: ToDoHome(),
    ),
  );
}

class ToDoHome extends StatefulWidget {
  const ToDoHome({Key? key}) : super(key: key);
  @override
  _ToDoHomeState createState() => _ToDoHomeState();
}

class _ToDoHomeState extends State<ToDoHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Add and remove items',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ToDoInput()),
              ).then((value) => setState(() {}));
            }),
        title: const Text('Att-göra lista'),
      ),
      body: skapaLista(),
    );
  }

  Widget _skapaRad(String text) {
    final _alreadyDone = _done.contains(text);

    _toDoInputs.contains(text) ? null : _toDoInputs.add(text);
    return Card(
        child: ListTile(
      title: Text(
        text,
        style: TextStyle(
          decoration: _alreadyDone ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Icon(
        _alreadyDone ? Icons.check_box : Icons.check_box_outline_blank_outlined,
        color: _alreadyDone ? Colors.green : null,
      ),
      onTap: () {
        setState(() {
          _alreadyDone ? _done.remove(text) : _done.add(text);
        });
      },
      trailing: IconButton(
        onPressed: () {
          setState(() {
            _toDoInputs.remove(text);
          });
        },
        icon: const Icon(Icons.delete_outline),
      ),
    ));
  }

  Widget skapaLista() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          if (i < _toDoInputs.length) {
            return _skapaRad(_toDoInputs[i]);
          } else {
            return const Divider(
              color: Colors.white,
            );
          }
        });
  }
}

class ToDoInput extends StatefulWidget {
  const ToDoInput({Key? key}) : super(key: key);
  @override
  _ToDoInputState createState() => _ToDoInputState();
}

class _ToDoInputState extends State<ToDoInput> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('lägg till sak att göra'),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            TextField(controller: _toDoController),
            const Divider(
              height: 20,
            ),
            OutlinedButton(
                onPressed: () {
                  setState(() {
                    _toDoInputs.add(_toDoController.text);
                    _toDoController.clear();
                  });
                },
                child: const Text('lägg till')),
          ],
        )));
  }

//  void addInputToList() {
//    setState(() {

//    });
//  }
}



//class _ToDoListState extends State<toDoHome>{
//
//  Widget addItem(String userInput){
//  setState((){
//      _toDoInputs.add(userInput);
//  });
//  )
//}
//}         FIXA EN TEXTSTYLE OCH EN BUTTONSTYLE
