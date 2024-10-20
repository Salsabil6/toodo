import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist2/mobules/modules_archived/archivedcreen.dart';
import 'package:todolist2/mobules/modules_done/donecreen.dart';
import 'package:todolist2/mobules/modules_task/taskscreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int current = 0;
  List<Widget> screen = [const TaskScreen(), doneScreen(), ArchivedScreen()];
  List<String> title = ['New Task', 'Done Task', 'Archived Task'];

  Database? database;
  var scaffoldkey = GlobalKey<ScaffoldState>();
  bool isbuttomsheetshow = false;
  Icon editbuttomsheet = const Icon(Icons.edit);
  var tiitlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var formkey = GlobalKey<FormState>();
  List<Map> task = [];

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
      body: screen[current],
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
              
                isbuttomsheetshow = false;
                setState(() {
                  editbuttomsheet = const Icon(Icons.edit);
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
      'todooo.db',
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
          setState(() { task = value;
          print(task[0]);
            
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
     await database?.transaction(
      (txn) => txn
          .rawInsert(
              //'INSERT INTO Tasks(title,data,status,time )VALUES($tittle,$date,"new",$time) '
              'INSERT INTO Tasks(title,data,status,time )VALUES("salsabel","2020","new","20") ')

          .then((value) {
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
