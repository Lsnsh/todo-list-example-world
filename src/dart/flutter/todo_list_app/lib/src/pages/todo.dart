import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  @override
  TodoPageState createState() => TodoPageState();
}

class TodoPageState extends State<TodoPage> {
  TextEditingController _nametextController;
  TextEditingController _remarkextController;
  var todoList = <TodoItem>[];

  @override
  void initState() {
    super.initState();
    _nametextController = TextEditingController(text: '');
    _remarkextController = TextEditingController(text: '');
    initTodoListState();
  }

  void initTodoListState() {
    var initTodoList = """[
      {
        "title": "one",
        "remark": "one' sub title."
      },
      {
        "title": "two",
        "remark": "two' sub title."
      },
      {
        "title": "third",
        "remark": "third' sub title."
      },
      {
        "title": "four",
        "remark": "four' sub title."
      },
      {
        "title": "five",
        "remark": "five' sub title."
      }
    ]""";

    List<dynamic> list = jsonDecode(initTodoList);
    list.forEach((item) {
      todoList.add(TodoItem.fromJson(item));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo Page"),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          )
        ],
      ),
      body: Wrap(
        children: <Widget>[
          _addTodoSection(),
          Divider(),
          _todoListSection(),
        ],
      ),
    );
  }

  Widget _addTodoSection() {
    return Column(
      children: <Widget>[
        TextField(
            autofocus: true,
            decoration: InputDecoration(
                labelText: "Title",
                hintText: "Please input title",
                prefixIcon: Icon(Icons.title)),
            controller: _nametextController),
        TextField(
            autofocus: true,
            decoration: InputDecoration(
                labelText: "Remark", prefixIcon: Icon(Icons.info_outline)),
            controller: _remarkextController),
        RaisedButton(
            child: Text('Create'),
            color: Colors.blue[500],
            textColor: Colors.white,
            onPressed: () {
              print('current task title: ${_nametextController.text}');
              print('current task remark: ${_remarkextController.text}');
              setState(() {
                todoList.add(TodoItem.fromJson({
                  "title": _nametextController.text,
                  "remark": _remarkextController.text
                }));
                _nametextController.clear();
                _remarkextController.clear();
              });
            }),
        RaisedButton(
            child: Text('Print todo list JSON string'),
            onPressed: () {
              var jsonStr = jsonEncode(todoList);
              print('current todo list json string:\n$jsonStr');
            })
      ],
    );
  }

  Widget _todoListSection() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: todoList.length,
        itemBuilder: (context, i) {
          var todoItem = todoList[i];
          return ListTile(
            title: Text(todoItem.title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                )),
            subtitle: Text(todoItem.remark),
            leading: Icon(Icons.check_box_outline_blank),
            onTap: () {
              print('complete: ${todoItem.title}');
              setState(() {
                todoList.remove(todoItem);
              });
            },
          );
        });
  }
}

class TodoItem {
  String title;
  String remark;

  TodoItem(
    this.title,
    this.remark,
  );

  // TodoItem.fromJson(Map<String, dynamic> json)
  //     : title = json['title'],
  //       remark = json['remark'];
  // The following code is the same as the above function
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(json['title'], json['remark']);
  }

  // jsonEncode method fallback
  Map<String, dynamic> toJson() => {
        'title': title,
        'remark': remark,
      };
}
