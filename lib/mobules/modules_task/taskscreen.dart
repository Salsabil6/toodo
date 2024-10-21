import 'package:flutter/material.dart';
import 'package:todolist2/shard/component/components.dart';
import 'package:todolist2/shard/component/constants.dart';

class TaskScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return taskstyle(task[index]);
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 2,
          );
        },
        itemCount: task.length);
  }
}
