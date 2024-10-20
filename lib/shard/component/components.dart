import 'package:flutter/material.dart';

Widget taskstyle(){
  return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          CircleAvatar(
            radius: 44,
            child: Text(
              'task time ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
            Text('task tittle',style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),),
            Text('oct-4-6',
            style: TextStyle(color: Colors.grey),)
            
          ],)
        ],
      ),
    );
}