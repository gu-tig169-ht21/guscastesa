import 'package:flutter/material.dart';
import 'api_implementering.dart';
import 'todo_themedata.dart';
import 'second_page.dart';
import 'package:get/get.dart';

// detta är min kod kopiera inte din lille jäkel. Mvh samuel castenström
List<ToDoPost> toDoPosts = <ToDoPost>[];
bool _darkTheme = true;
String _chosenFilter = 'All';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do list',
      home: const ToDoHome(),
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: ThemeMode.system,
    ),
  );
}

class _ApiInputHandling {
  Future<List<ToDoPost>> addToInputsFromApi() async {
    await APIintegration().getList();
    toDoPosts = List.from(toDoObjects);
    return toDoPosts;
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
      appBar: AppBar(
          title: const Text('Att-göra lista'),
          leading: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                if (_darkTheme) {
                  setState(() {
                    Get.changeThemeMode(ThemeMode.light);
                    _darkTheme = false;
                  });
                } else {
                  setState(() {
                    Get.changeThemeMode(ThemeMode.dark);
                    _darkTheme = true;
                  });
                }
              }),
          actions: [
            DropdownButton(
              //dropdownbutton som ger värde till filtreringen
              value: _chosenFilter,

              items: <String>['Done', 'Not Done', 'All'].map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _chosenFilter = newValue!;
                });
              },
              style: TextStyle(
                color: _darkTheme ? Colors.white : Colors.black,
              ),
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
              return _listFiltering();
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

  Widget _listFiltering() {
    //hämtar och parsar information från API:n
    // filtrerar igenom beroende på vald filtrering i dropdownen
    //returnerar en skapaLista med den relevanta filtrerade
    //eller ofiltrerade listan

    switch (_chosenFilter) {
      case 'Done':
        {
          return _createList(
              toDoPosts.where((todo) => todo.done == true).toList());
        }
      case 'Not Done':
        {
          return _createList(
              toDoPosts.where((todo) => todo.done == false).toList());
        }
      case 'All':
        {
          return _createList(toDoPosts);
        }
      default:
        return _createList(toDoPosts);
    }
  }

  Widget _createList(List<ToDoPost> skapadLista) {
    //Denna widget tar listan från filtrering och itererar igenom den
    //skapar en listview och kallar skapaRad för varje objekt i listan
    //den får
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          if (i < skapadLista.length) {
            return _createRow(skapadLista[i]);
          } else {
            return const Divider();
          }
        });
  }

  Widget _createRow(ToDoPost post) {
    final _alreadyDone = post.getDone;
    //denna widget skapar raderna i att göra listan.
    //_toDoInputs.contains(text) ? null : _toDoInputs.add(text);
    return Card(
        child: ListTile(
      title: Text(
        post.getTitle,
        style: TextStyle(
          color: _darkTheme ? Colors.white : Colors.black,
          decoration: _alreadyDone ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Icon(
        //iconen som visas för sparade vs inte sparade
        _alreadyDone ? Icons.check_box : Icons.check_box_outline_blank_outlined,
        color: _darkTheme
            ? _alreadyDone
                ? Colors.lightGreen
                : Colors.white54
            : _alreadyDone
                ? Colors.lightGreen
                : null,
      ),
      onTap: () {
        //skickar information om ändrad Done till lokal och API lista
        int index = toDoPosts.indexWhere((item) => item.getId == post.getId);
        if (_alreadyDone) {
          APIintegration().updateList(post.getTitle, false, post.getId);
          setState(() {
            toDoPosts[index].setDone = false;
          });
        } else {
          APIintegration().updateList(post.getTitle, true, post.getId);
          setState(() {
            toDoPosts[index].setDone = true;
          });
        }
      },
      trailing: IconButton(
        //knappen för att ta bort något från listan
        onPressed: () {
          APIintegration().removeFromList(post.getId);
          setState(() {
            toDoPosts.removeWhere((item) => item.getId == post.getId);
          });
        },
        icon: Icon(
          Icons.delete_outline,
          color: _darkTheme ? Colors.white54 : null,
        ),
      ),
    ));
  }
}
