import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/TodoItem.dart';

class TodoPage extends StatefulWidget {
  @override
  TodoPageState createState() => TodoPageState();
}

class TodoPageState extends State<TodoPage> {
  SharedPreferences _prefs;
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

  // 初始化 todoList（从本地存储中获取 todo 页面创建任务后保存在本地的数据）
  void initTodoListState() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      var todoStrList = _prefs.getStringList('todoList') ?? [];
      todoStrList.forEach((todoItemStr) {
        todoList.add(TodoItem.fromJson(jsonDecode(todoItemStr)));
      });
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
              // print('current task title: ${_nametextController.text}');
              // print('current task remark: ${_remarkextController.text}');
              setState(() {
                TodoItem todoItem = TodoItem.fromJson({
                  "title": _nametextController.text,
                  "remark": _remarkextController.text
                });
                todoList.add(todoItem);
                _nametextController.clear();
                _remarkextController.clear();
                var todoStrList = <String>[];
                todoList.forEach((item) {
                  todoStrList.add(jsonEncode(item));
                });
                // 创建任务后，将 todoList 最新状态存储在本地
                _prefs.setStringList('todoList', todoStrList);
              });
            }),
      ],
    );
  }

  Widget _todoListSection() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: todoList.length,
        itemBuilder: (context, i) {
          TodoItem todoItem = todoList[i];
          return ListTile(
            title: Text(todoItem.title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                )),
            subtitle: Text(todoItem.remark),
            leading: Icon(Icons.check_box_outline_blank),
            onTap: () {
              // print('complete: ${todoItem.title}');
              setState(() {
                todoList.remove(todoItem);
                var doneList = _prefs.getStringList('doneList') ?? [];
                doneList.add(jsonEncode(todoItem));
                // 完成任务后，基于本地存储中的 doneList，将该任务更新到 doneList 后再存储到本地
                _prefs.setStringList('doneList', doneList);
 
                var todoStrList = <String>[];
                todoList.forEach((item) {
                  todoStrList.add(jsonEncode(item));
                });
                // 完成任务后，将 todoList 最新状态存储在本地
                _prefs.setStringList('todoList', todoStrList);
              });
            },
          );
        });
  }
}
