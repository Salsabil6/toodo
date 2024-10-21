import 'package:flutter/material.dart';

Widget taskstyle( Map models){
  return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          CircleAvatar(
            radius: 44,
            child: Text(
              '${models['time']}',
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
            
            Text('${models['title']}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),),
            Text('${models['date']}',
            style: TextStyle(color: Colors.grey),)
            
          ],)
        ],
      ),
    );
}