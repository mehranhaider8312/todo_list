import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/utils/todo_list.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _controller = TextEditingController();
  List toDoList = [
    ['Install ToDo Application', false],
  ];

  @override
  void initState() {
    super.initState();
    loadToDoList();
  }

  Future<void> saveToDoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('toDoList', jsonEncode(toDoList)); // Save as JSON string
  }

  Future<void> loadToDoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? toDoListString = prefs.getString('toDoList');
    if (toDoListString != null) {
      setState(() {
        toDoList = List<List<dynamic>>.from(
          jsonDecode(toDoListString).map((item) => List<dynamic>.from(item)),
        );
      });
    }
  }

  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
    saveToDoList();
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
    saveToDoList();
  }

  void saveNewToDo() {
    setState(() {
      toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    saveToDoList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: const Center(
          child: Text(
              "ToDo List"
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(itemCount: toDoList.length,
          itemBuilder: (BuildContext context, index) {
            return ToDoList(
              taskName: toDoList[index][0],
              taskCompleted: toDoList[index][1],
              onChanged: (value) => checkBoxChanged(index),
              deleteFunction: (context) => deleteTask(index),
            );
          }),
      floatingActionButton: Row(
          children: [
      Expanded(child: Padding(
      padding: const EdgeInsets.only(
          left: 20,
          right: 20
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
            hintText: 'Add New ToDo',
            filled: true,
            fillColor: Colors.deepPurple.shade200,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.deepPurple,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(
              color: Colors.deepPurple,
            ),
              borderRadius: BorderRadius.circular(15),)
        ),
      ),
    )),
        FloatingActionButton(
          onPressed: saveNewToDo,
          child: const Icon(Icons.add),
        ),
      ],
    ),);
  }
}