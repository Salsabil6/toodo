import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist2/mobules/modules_archived/archivedcreen.dart';
import 'package:todolist2/mobules/modules_done/donecreen.dart';
import 'package:todolist2/mobules/modules_task/taskscreen.dart';
//import 'package:todolist2/nnn.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //const HomeScreen({super.key});
  int current = 0;
  List<Widget> screen = [TaskScreen(), doneScreen(), ArchivedScreen()];
  List<String> tittle = ['New Task', 'Done Task', 'Archived Task'];
  //Database ?database;
  
  Database? database;
  
 

  @override
  void initState() {
    createdatabase();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tittle[current]),
      ),
      body: screen[current],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: current,
          onTap: (index) {
            setState(() {
              current = index;
            });
            // print(index);
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Task'),
            BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Done'),
            BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archive')
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            var name = await getname();
            print(name);
          } catch (error) {
            print(error);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

Future<String> getname() async {
  return 'batta sayed';
}

void createdatabase() async {
  widget.database =
      await openDatabase('todo.db', version: 1, onCreate: (database, version) {
    print('database created');
    database
        .execute(
            'create table Tasks(id integer primary key,tittle text,data text.time text,status text)')
        .then((Value) {
      print('table is created');
    }).catchError((onError) {
      print(onError.toString());
    });
  }, onOpen: (database) {
    print('database opened');
  });
}

/*void inserttodatabase() {
  database.t;
}*/
