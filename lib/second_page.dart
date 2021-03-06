import 'api_implementering.dart';
import 'package:flutter/material.dart';

final _toDoController = TextEditingController();

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
            child: Container(
                alignment: Alignment.center,
                child: SizedBox(
                    width: 300,
                    height: 200,
                    child: Column(
                      children: <Widget>[
                        TextField(
                          //textfält för input
                          textInputAction: TextInputAction.done,
                          //du behöver inte trycka på lägg till knappen, textInputaction göra tt du kan trycka enter.
                          controller: _toDoController,
                          onSubmitted: (value) {
                            _inputHandling(_toDoController.text);
                          },
                          decoration: const InputDecoration(
                              labelText: 'Vad ska du göra?',
                              labelStyle: TextStyle(color: Colors.lightGreen),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.lightGreen,
                              ))),
                        ),
                        const Divider(
                          height: 20,
                        ),
                        OutlinedButton(
                            //denna knapp skickar input från textfältet till _inputHandling
                            onPressed: () {
                              _inputHandling(_toDoController.text);
                            },
                            child: const Text('lägg till')),
                      ],
                    )))));
  } //detta är min kod, sno inte mvh samuel castenström

  void _inputHandling(String text) {
    //denna metod hanterar och testar input
    if (text.isEmpty) {
      //if satsen kollar om textfältet är tomt eller om det finns en dublett i listan.
      setState(() {
        showDialog(
            //pop-up dialog med felmeddelande vid null eller dubletter
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Input error'),
                content: Text(
                  text.isEmpty
                      ? 'Du måste ange en sak att göra'
                      : 'Du kan ej ange dubletter',
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('ok'))
                ],
              );
            });
        _toDoController.clear();
      });
    } else {
      //om textinputen är ok skickas den vidare till _toDoInputs och till API:n
      APIintegration().addToList(text, false);
      setState(() {
        _toDoController.clear();
      });
    }
  }
}
