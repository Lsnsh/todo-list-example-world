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
