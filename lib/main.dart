// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_crud_sqlite/routes/app_routes.dart';
import 'package:flutter_crud_sqlite/views/home_list.dart';
import 'package:flutter_crud_sqlite/views/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CRUD Flutter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: AppRoutes.LOGIN,
        routes: {
          AppRoutes.HOME_LIST: (_) => const HomeListScreen(), 
          AppRoutes.LOGIN: (context) =>  LoginScreen(),
        }
    );
  }
}
