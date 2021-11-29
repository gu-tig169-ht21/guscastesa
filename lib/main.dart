import 'package:flutter/material.dart';
import 'api_implementering.dart';
import 'todo_themedata.dart';
import 'second_page.dart';

// detta är min kod kopiera inte din lille jäkel. Mvh samuel castenström
List<ToDoPost> toDoPoster = <ToDoPost>[];

String _valdFiltrering = 'All';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do list',
      home: ToDoHome(),
      theme: CustomTheme.lightTheme,
    ),
  );
}

class _ApiInputHandling {
  Future<List<ToDoPost>> addToInputsFromApi() async {
    await APIintegration().getList();
    toDoPoster = List.from(toDoObjects);
    return toDoPoster;
  }
}

//------------------Första sidan-------------------------
class ToDoHome extends StatefulWidget {
  const ToDoHome({Key? key}) : super(key: key);
  @override
  _ToDoHomeState createState() => _ToDoHomeState();
}

class _ToDoHomeState extends State<ToDoHome> {
  Future<List<ToDoPost>>? _future;
  //APIintegration().getID();

  @override
  void initState() {
    _future = _ApiInputHandling().addToInputsFromApi();
    //_ApiInputHandling().addToInputsFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Att-göra lista'), actions: [
        DropdownButton(
          //dropdownbutton som ger värde till filtreringen
          value: _valdFiltrering,
          items: <String>['Done', 'Not Done', 'All'].map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _valdFiltrering = newValue!;
            });
          },
        )
      ]),
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'An error occured getting todolist',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              return _filtrera();
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        future: _future,
      ),
      floatingActionButton: FloatingActionButton(
          //knapp som flyttar till sidan som hanterar input
          child: const Icon(Icons.add),
          tooltip: 'Add item',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ToDoInput()),
            ).then(onGoBack);
          }),
    );
  }

  Future? onGoBack(dynamic value) {
    setState(() {
      _future = _ApiInputHandling().addToInputsFromApi();
    });
  }

  Widget _filtrera() {
    //hämtar och parsar information från API:n
    // filtrerar igenom beroende på vald filtrering i dropdownen
    //returnerar en skapaLista med den relevanta filtrerade
    //eller ofiltrerade listan

    switch (_valdFiltrering) {
      case 'Done':
        {
          return skapaLista(
              toDoPoster.where((todo) => todo.done == true).toList());
        }
      case 'Not Done':
        {
          return skapaLista(
              toDoPoster.where((todo) => todo.done == false).toList());
        }
      case 'All':
        {
          return skapaLista(toDoPoster);
        }
      default:
        return skapaLista(toDoPoster);
    }
  }

  Widget skapaLista(List<ToDoPost> skapadLista) {
    //Denna widget tar listan från filtrering och itererar igenom den
    //skapar en listview och kallar skapaRad för varje objekt i listan
    //den får
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          if (i < skapadLista.length) {
            return _skapaRad(skapadLista[i]);
          } else {
            return const Divider(
              color: Colors.white,
            );
          }
        });
  }

  Widget _skapaRad(ToDoPost post) {
    final _alreadyDone = post.getDone;
    //denna widget skapar raderna i att göra listan.
    //_toDoInputs.contains(text) ? null : _toDoInputs.add(text);
    return Card(
        child: ListTile(
      title: Text(
        post.getTitle,
        style: TextStyle(
          decoration: _alreadyDone ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Icon(
        //iconen som visas för sparade vs inte sparade
        _alreadyDone ? Icons.check_box : Icons.check_box_outline_blank_outlined,
        color: _alreadyDone ? Colors.green : null,
      ),
      onTap: () {
        //skickar information om ändrad Done till lokal och API lista
        int index = toDoPoster.indexWhere((item) => item.getId == post.getId);
        if (_alreadyDone) {
          APIintegration().updateList(post.getTitle, false, post.getId);
          setState(() {
            toDoPoster[index].setDone = false;
          });
        } else {
          APIintegration().updateList(post.getTitle, true, post.getId);
          setState(() {
            toDoPoster[index].setDone = true;
          });
        }
      },
      trailing: IconButton(
        //knappen för att ta bort något från listan
        onPressed: () {
          APIintegration().removeFromList(post.getId);
          setState(() {
            toDoPoster.removeWhere((item) => item.getId == post.getId);
          });
        },
        icon: const Icon(Icons.delete_outline),
      ),
    ));
  }
}
