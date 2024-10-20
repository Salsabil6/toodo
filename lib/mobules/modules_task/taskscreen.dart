import 'package:flutter/material.dart';
import 'package:todolist2/shard/component/components.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return taskstyle();
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 2,
            
          );
        },
        itemCount: 4);
  }
}
