import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stover/modules/Todo%20App/archived_tasks/archived_tasks_screen.dart';
import 'package:stover/modules/Todo%20App/done_tasks/done_tasks_screen.dart';
import 'package:stover/modules/Todo%20App/new_tasks/new_tasks_screen.dart';
import 'package:stover/shared/components/components.dart';
import 'package:stover/shared/components/constants.dart';
import 'package:stover/shared/cubit/cubit.dart';
import 'package:stover/shared/cubit/states.dart';

// 1. create database
// 2. create tables
// 3. open database
// 4. insert to database
// 5. get from database
// 6. update in database
// 7. delete from database

class HomeLayout extends StatelessWidget {
  // const HomeLayout({Key? key}) : super(key: key);



  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state)
        {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilderRec(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                    );
                    // insertToDatabase(
                    //   title: titleController.text,
                    //   time: timeController.text,
                    //   date: dateController.text,
                    // ).then((value) {
                    //   getDataFromDatabase(database).then((value) {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   isBottomSheetShown = false;
                    //     //   fabIcon = Icons.edit;
                    //     //
                    //     //   tasks = value;
                    //     //   print(tasks);
                    //     // });
                    //   });
                    // });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(
                        20.0,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                              controller: titleController,
                              type: TextInputType.text,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Title must not be empty';
                                }
                                return null;
                              },
                              label: 'Task Title',
                              prefix: Icons.title,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                              controller: timeController,
                              type: TextInputType.datetime,
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text =
                                      value!.format(context).toString();
                                });
                              },
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Time must not be empty';
                                }
                                return null;
                              },
                              label: 'Task Time',
                              prefix: Icons.watch_later_outlined,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                              controller: dateController,
                              type: TextInputType.datetime,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2025-12-31'),
                                ).then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
                                });
                              },
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Date must not be empty';
                                }
                                return null;
                              },
                              label: 'Task Date',
                              prefix: Icons.calendar_month,
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  )
                      .closed
                      .then((value)
                  {
                        cubit.changeBottomSheetState(
                          isShow: false,
                          icon: Icons.edit,
                        );
                    // isBottomSheetShown = false;
                    // setState(() {
                    //   fabIcon = Icons.edit;
                    // });
                  });
                  cubit.changeBottomSheetState(
                    isShow: true,
                    icon: Icons.add,
                  );
                  //isBottomSheetShown = true;
                  // setState(() {
                  //   fabIcon = Icons.add;
                  // });
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
                // setState(() {
                //   currentIndex = index;
                // });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Future<String> getName() async {
  //   return 'Haikel';
  // }


}

// Future insertToDatabase({
//   required String title,
//   required String time,
//   required String date,
// }) async {
//   return await database.transaction((txn) async {
//     try {
//       final value = await txn.rawInsert(
//           'INSERT INTO tasks(title, date, time, status) VALUES("$title","$time","$date","new")'
//       );
//       print('$value Inserted Successfully');
//     } catch(error) {
//       print('Error When Inserting New Record ${error.toString()}');
//     }
//   });
// }

///________________________________NOTES_________________________________________
// try{
//   var name = await getName();
//   print(name);
//   print('Mo');
//
//   //throw('some error !!!!!');
// }catch(error){
//   print('error ${error.toString()}');
// }

// getName().then((value) {
// print(value);
// print('Mo');
// //throw('انا عملت ايرور !!!');
// }).catchError((error) {
// print('error is ${error.toString()}');
// });

///____________________________________OLD CODE___________________________________________
// class HomeLayout extends StatefulWidget
// {
//   const HomeLayout({Key? key}) : super(key: key);
//
//   @override
//   State<HomeLayout> createState() => _HomeLayoutState();
// }
//
//
//
// class _HomeLayoutState extends State<HomeLayout>
// {
//   // const HomeLayout({Key? key}) : super(key: key);
//
//   int currentIndex = 0;
//   List<Widget> screens = [
//     NewTasksScreen(),
//     DoneTasksScreen(),
//     ArchivedTasksScreen(),
//   ];
//   List<String> titles = [
//     'New Tasks',
//     'Done Tasks',
//     'Archived Tasks',
//   ];
//
//   late Database database;
//   var scaffoldKey = GlobalKey<ScaffoldState>();
//   var formKey = GlobalKey<FormState>();
//   bool isBottomSheetShown = false;
//   IconData fabIcon = Icons.edit;
//   var titleController = TextEditingController();
//   var timeController = TextEditingController();
//   var dateController = TextEditingController();
//
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     createDatabase();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//         title: Text(
//           titles[currentIndex],
//         ),
//       ),
//       body: ConditionalBuilderRec(
//         condition: tasks.length > 0,
//         builder: (context) => screens[currentIndex],
//         fallback: (context) => Center(child: CircularProgressIndicator()),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           if (isBottomSheetShown) {
//             if(formKey.currentState!.validate()){
//               insertToDatabase(
//                 title: titleController.text,
//                 time: timeController.text,
//                 date: dateController.text,
//               ).then((value)
//               {
//                 getDataFromDatabase(database).then((value)
//                 {
//                   Navigator.pop(context);
//                   setState(() {
//                     isBottomSheetShown = false;
//                     fabIcon = Icons.edit;
//
//                     tasks = value;
//                     print(tasks);
//                   });
//                 });
//               });
//             }
//           } else
//           {
//             scaffoldKey.currentState!.showBottomSheet(
//                   (context) => Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.all(20.0,),
//                 child: Form(
//                   key: formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       defaultFormField(
//                         controller: titleController,
//                         type: TextInputType.text,
//                         validate: (value){
//                           if(value!.isEmpty){
//                             return 'Title must not be empty';
//                           }
//                           return null;
//                         },
//                         label: 'Task Title',
//                         prefix: Icons.title,
//                       ),
//                       const SizedBox(
//                         height:15.0,
//                       ),
//                       defaultFormField(
//                         controller: timeController,
//                         type: TextInputType.datetime,
//                         onTap: (){
//                           showTimePicker(
//                             context: context,
//                             initialTime: TimeOfDay.now(),
//                           ).then((value){
//                             timeController.text = value!.format(context).toString();
//                           });
//                         },
//                         validate: (value){
//                           if(value!.isEmpty){
//                             return 'Time must not be empty';
//                           }
//                           return null;
//                         },
//                         label: 'Task Time',
//                         prefix: Icons.watch_later_outlined,
//                       ),
//                       const SizedBox(
//                         height:15.0,
//                       ),
//                       defaultFormField(
//                         controller: dateController,
//                         type: TextInputType.datetime,
//                         onTap: (){
//                           showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate: DateTime.now(),
//                             lastDate: DateTime.parse('2025-12-31'),
//                           ).then((value){
//                             dateController.text = DateFormat.yMMMd().format(value!);
//                           });
//                         },
//                         validate: (value){
//                           if(value!.isEmpty){
//                             return 'Date must not be empty';
//                           }
//                           return null;
//                         },
//                         label: 'Task Date',
//                         prefix: Icons.calendar_month,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               elevation: 20.0,
//             ).closed.then((value) {
//               isBottomSheetShown = false;
//               setState(() {
//                 fabIcon = Icons.edit;
//               });
//             });
//             isBottomSheetShown = true;
//             setState(() {
//               fabIcon = Icons.add;
//             });
//           }
//         },
//         child: Icon(
//           fabIcon,
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: currentIndex,
//         onTap: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.menu,
//             ),
//             label: 'Tasks',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.check_circle_outline,
//             ),
//             label: 'Done',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.archive_outlined,
//             ),
//             label: 'Archived',
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Future<String> getName() async {
//   //   return 'Haikel';
//   // }
//
//   void createDatabase() async {
//     database = await openDatabase(
//       'todo.db',
//       version: 1,
//       onCreate: (database, version) {
//         // id integer
//         // title String
//         // date String
//         // time String
//         // status String
//         print('database created');
//         database
//             .execute(
//             'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
//             .then((value) {
//           print('table created');
//         }).catchError((error) {
//           print('Error When Creating Table ${error.toString()}');
//         });
//       },
//       onOpen: (database)
//       {
//         getDataFromDatabase(database).then((value)
//         {
//           setState(() {
//             tasks = value;
//             print(tasks);
//           });
//         });
//
//         print('database opened');
//       },
//     );
//   }
//
//   Future insertToDatabase({
//     required String title,
//     required String time,
//     required String date,
//   }) async {
//     return await database.transaction((txn) async {
//       await txn
//           .rawInsert(
//           'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
//           .then((value) {
//         print('$value Inserted Successfully');
//       }).catchError((error) {
//         print('Error When Inserting New Record ${error.toString()}');
//       });
//     });
//   }
//
//   Future<List<Map>> getDataFromDatabase(database) async {
//     return await database.rawQuery('SELECT * FROM tasks');
//   }
//
// }
