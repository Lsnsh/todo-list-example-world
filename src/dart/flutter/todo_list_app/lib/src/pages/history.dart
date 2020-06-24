import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/TodoItem.dart';

class HistoryPage extends StatefulWidget {
  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  SharedPreferences _prefs;
  var doneList = <TodoItem>[];

  @override
  void initState() {
    super.initState();
    initDoneListState();
  }

  // 初始化 doneList（从本地存储中获取 todo 页面完成任务后保存在本地的数据）
  initDoneListState() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      var doneStrList = _prefs.getStringList('doneList') ?? [];
      doneStrList.forEach((doneItemStr) {
        doneList.add(TodoItem.fromJson(jsonDecode(doneItemStr)));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History Page"),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                setState(() {
                  doneList.clear();
                });
                // 清理本地存储
                _prefs.remove('doneList');
              })
        ],
      ),
      body: Wrap(
        children: <Widget>[_doneListSection()],
      ),
    );
  }

  Widget _doneListSection() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: doneList.length,
        itemBuilder: (context, i) {
          var doneItem = doneList[i];
          return ListTile(
            title: Text(doneItem.title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                )),
            subtitle: Text(doneItem.remark),
            // leading: Icon(Icons.check_box, color: Colors.green),
            // trailing: Icon(Icons.delete_outline, color: Colors.red),
            // onTap: () {},
          );
        });
  }
}
