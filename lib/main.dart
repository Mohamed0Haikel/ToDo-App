import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:stover/layout/home_layout.dart';
import 'package:stover/modules/counter/counter_screen.dart';
import 'package:stover/modules/home/home_screen.dart';
import 'package:stover/modules/login/login_screen.dart';
import 'package:stover/modules/messenger/messenger_screen.dart';
import 'package:stover/modules/users/users_screen.dart';
import 'package:stover/shared/bloc_observer.dart';

void main()
{
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
