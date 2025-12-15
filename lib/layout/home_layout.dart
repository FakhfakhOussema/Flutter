import 'package:app_examen/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../modules/archived_tasks/archived_tasks_screen.dart';
import '../modules/done_tasks/done_tasks_screen.dart';
import '../modules/new_tasks/new_tasks_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;

  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;
  IconData  fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDatabase();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[currentIndex],),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(isBottomSheetShown)
            {
              Navigator.pop(context);
              isBottomSheetShown = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            }
          else
            {
              scaffoldKey.currentState!.showBottomSheet(
                      (context) => Container(
                        color: Colors.grey[300],
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(controller: titleController, type: TextInputType.text, label: 'Task Title', prefix: Icons.title,
                                validator: (value)
                                {
                                  if(value!.isEmpty)
                                  {
                                    return 'title must be not empty';
                                  }
                                  else
                                  {
                                    return null;
                                  }
                                }
                            ),
                          SizedBox(height: 15,),
                            defaultFormField(controller: timeController, type: TextInputType.datetime, label: 'Task Time', prefix: Icons.watch_later_outlined,
                                validator: (value)
                                {
                                  if(value!.isEmpty)
                                  {
                                    return 'title must be not empty';
                                  }
                                  else
                                  {
                                    return null;
                                  }
                                },
                              onTap: (){
                              print('Timming tapped');
                              }
                            ),

                          ],
                        ),
                      )
              );
              isBottomSheetShown = true;
              setState(() {
                fabIcon = Icons.add;
              });
            }
        },
        child: Icon(fabIcon),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type:BottomNavigationBarType.fixed,
          elevation: 10,
          currentIndex: currentIndex,
          onTap: (index){
          setState(() {
            currentIndex = index;
          });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.menu),label: 'Tasks'),
            BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline_rounded),label: 'Done'),
            BottomNavigationBarItem(icon: Icon(Icons.archive_outlined),label: 'Archived'),
      ]),
    );
  }

  void createDatabase() async {
    database = await openDatabase(
      'flutter_todo.db',
      version: 1,
      onCreate: (db, version) async {
        print('database created');

        await db.execute(
            'CREATE TABLE Task ('
                'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'title TEXT, '
                'date TEXT, '
                'time TEXT, '
                'status TEXT'
                ')'
        );

        print('table created');
      },
      onOpen: (db) {
        print('database opened');
      },
    );
  }


  void insertToDatabase() async
  {
    await database.transaction((txn) async
    {
      await txn.rawInsert(
        'INSERT INTO Task(title,date,time,status) VALUES("First Task","6541","46846","NEW")'
      ).then((value) {
        print('inserted successfully - ID: $value');
      }).catchError((error) {
        print('error when inserting new record ${error.toString()}');
      });
    });
  }

}
