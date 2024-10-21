import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist2/mobules/modules_archived/archivedcreen.dart';
import 'package:todolist2/mobules/modules_done/donecreen.dart';
import 'package:todolist2/mobules/modules_task/taskscreen.dart';
import 'package:todolist2/shard/component/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int current = 0;
  List<Widget> screen = [TaskScreen(), doneScreen(), ArchivedScreen()];
  List<String> title = ['New Task', 'Done Task', 'Archived Task'];

  Database? database;
  var scaffoldkey = GlobalKey<ScaffoldState>();
  bool isbuttomsheetshow = false;
  Icon editbuttomsheet = const Icon(Icons.edit);
  var tiitlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super
        .initState(); // انتي كنتي ناسيه دي ي  دي لازم تبقا موجوده مع  initstate
    createdatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text(title[current]),
      ),
      body: task.length == 0
          ? Center(child: CircularProgressIndicator())
          : screen[current],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: current,
        onTap: (index) {
          setState(() {
            current = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Task'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Done'),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archive')
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isbuttomsheetshow) {
            if (formkey.currentState!.validate()) {
              //معناها لو نمام يعنى كل الداتا مكتوبه اغمل هنسيرت و اقفل ال
              //sheet
              InsertToDatabase(
                      tittle: tiitlecontroller.text,
                      time: timecontroller.text,
                      date: datecontroller.text)
                  .then((value) {
                Navigator.pop(context);
                setState(() {
                  
                  tiitlecontroller.clear();
                  timecontroller.clear();
                  datecontroller.clear();
                  isbuttomsheetshow = false;
                  editbuttomsheet = const Icon(Icons.edit);
                  //print(task);
                });
              });

              /* Navigator.pop(context);
            isbuttomsheetshow = false;
            setState(() {
              editbuttomsheet = const Icon(Icons.edit);
            });*/
            }
          } else {
            scaffoldkey.currentState!
                .showBottomSheet((context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formkey,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'tittle must not be empty ';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          controller: tiitlecontroller,
                          decoration: const InputDecoration(
                            label: Text('Tittle'),
                            border: OutlineInputBorder(),
                            prefix: Icon(Icons.title_outlined),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'time must not be empty ';
                            }
                            return null;
                          },
                          onTap: () {
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                .then((value) {
                              timecontroller.text =
                                  value!.format(context).toString();
                              print(value.format(context));
                            });
                          },
                          keyboardType: TextInputType.datetime,
                          controller: timecontroller,
                          decoration: const InputDecoration(
                            label: Text('time'),
                            border: OutlineInputBorder(),
                            prefix: Icon(Icons.watch_later_outlined),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.parse('2024-11-20'),
                            ).then((value) {
                              datecontroller.text =
                                  DateFormat.yMMMMd().format(value!);
                              print(DateFormat.yMMMd().format(value));

                              // datecontroller.text = DateTime.utc()
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'date must not be empty ';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          controller: datecontroller,
                          decoration: const InputDecoration(
                            label: Text('date'),
                            border: OutlineInputBorder(),
                            prefix: Icon(Icons.date_range_rounded),
                          ),
                        ),
                      ]),
                    ),
                  );
                })
                .closed //عشان لو قفلت الشيت بيدى عادى يتقبل ده ومش يدينى ايرور
                .then((value) {
                  isbuttomsheetshow = false;
                  setState(() {
                    editbuttomsheet = const Icon(Icons.edit);
                  });
                });
            isbuttomsheetshow = true;
            setState(() {
              editbuttomsheet = Icon(Icons.add);
            });
          }
        },
        child: editbuttomsheet,
      ),
    );
  }

  void createdatabase() async {
    database = await openDatabase(
      'todoooo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
          'CREATE TABLE Tasks(id INTEGER PRIMARY KEY, title TEXT, data TEXT, status TEXT,time Text)',
        )
            .then((value) {
          print('table is created');
        }).catchError((onError) {
          print(onError.toString());
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database).then((value) {
          setState(() {
            task = value;
            print(task);
            print(task[0]['title']);
          });
        });
        print('database opened');
      },
    );
  }

  Future InsertToDatabase(
      {required String tittle,
      required String time,
      required String date}) async {
    return await database?.transaction(
      (txn) => txn
          .rawInsert(
              'INSERT INTO Tasks(title,data,status,time )VALUES($tittle,$date,"new",$time) ')
          //'INSERT INTO Tasks(title,data,status,time )VALUES("salsabel","2020","new","20") ')
          .then((value) {
        getDataFromDatabase(database).then((value) {
          setState(() {
            task = value;
          });
        });

        print('$value insert successfuly');
      }).catchError((Error) {
        print(Error.toString());
      }),
    );
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    return await database.rawQuery('SELECT * FROM Tasks ');
  }
}



/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist2/mobules/modules_archived/archivedcreen.dart';
import 'package:todolist2/mobules/modules_done/donecreen.dart';
import 'package:todolist2/mobules/modules_task/taskscreen.dart';
import 'package:todolist2/shard/component/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int current = 0;
  List<Widget> screen = [ TaskScreen(), doneScreen(), ArchivedScreen()];
  List<String> title = ['New Task', 'Done Task', 'Archived Task'];

  Database? database;
  var scaffoldkey = GlobalKey<ScaffoldState>();
  bool isbuttomsheetshow = false;
  Icon editbuttomsheet = const Icon(Icons.edit);
  var tiitlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    createdatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text(title[current]),
      ),
      body: screen[current], // تأكد من أن شاشة المهام تعرض البيانات
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: current,
        onTap: (index) {
          setState(() {
            current = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Task'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Done'),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archive')
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isbuttomsheetshow) {
            if (formkey.currentState!.validate()) {
              insertToDatabase(
                      title: tiitlecontroller.text,
                      time: timecontroller.text,
                      date: datecontroller.text)
                  .then((value) {
                isbuttomsheetshow = false;
                setState(() {
                  editbuttomsheet = const Icon(Icons.edit);
                  tiitlecontroller.clear();
                  timecontroller.clear();
                  datecontroller.clear();
                });
              });
            }
          } else {
            scaffoldkey.currentState!
                .showBottomSheet((context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formkey,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Title must not be empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          controller: tiitlecontroller,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                            border: OutlineInputBorder(),
                            prefix: Icon(Icons.title_outlined),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Time must not be empty';
                            }
                            return null;
                          },
                          onTap: () {
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                .then((value) {
                              timecontroller.text =
                                  value!.format(context).toString();
                            });
                          },
                          keyboardType: TextInputType.datetime,
                          controller: timecontroller,
                          decoration: const InputDecoration(
                            label: Text('Time'),
                            border: OutlineInputBorder(),
                            prefix: Icon(Icons.watch_later_outlined),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.parse('2024-11-20'),
                            ).then((value) {
                              datecontroller.text =
                                  DateFormat.yMMMMd().format(value!);
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Date must not be empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          controller: datecontroller,
                          decoration: const InputDecoration(
                            label: Text('Date'),
                            border: OutlineInputBorder(),
                            prefix: Icon(Icons.date_range_rounded),
                          ),
                        ),
                      ]),
                    ),
                  );
                })
                .closed
                .then((value) {
                  isbuttomsheetshow = false;
                  setState(() {
                    editbuttomsheet = const Icon(Icons.edit);
                  });
                });
            isbuttomsheetshow = true;
            setState(() {
              editbuttomsheet = const Icon(Icons.add);
            });
          }
        },
        child: editbuttomsheet,
      ),
    );
  }

  void createdatabase() async {
    database = await openDatabase(
      'todoooo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
          'CREATE TABLE Tasks(id INTEGER PRIMARY KEY, title TEXT, data TEXT, status TEXT, time TEXT)',
        )
            .then((value) {
          print('table is created');
        }).catchError((onError) {
          print(onError.toString());
        });
      },
      onOpen: (database) async {
        getDataFromDatabase(database).then((value) {
          setState(() {
            task = value;
            print(task[0]['title']);
            print('Data loaded: $task');
          });
        });
        print('database opened');
      },
    );
  }

  Future insertToDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await database?.transaction(
      (txn) {
        return txn
            .rawInsert(
                'INSERT INTO Tasks(title, data, status, time) VALUES("$title", "$date", "new", "$time")')
            .then((value) {
          print('$value insert successfully');
          getDataFromDatabase(database).then((value) {
            setState(() {
              task = value;
            });
          });
        }).catchError((error) {
          print('Error when inserting new task: ${error.toString()}');
        });
      },
    );
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    return await database.rawQuery('SELECT * FROM Tasks');
  }
}*/
