import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mongodb_ex01/db/display.dart';
import 'package:mongodb_ex01/db/updateData.dart';
import 'package:mongodb_ex01/db/mongodb.dart';
import 'package:mongodb_ex01/db/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDB.connect();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        // appBar: AppBar(title: const Text('mongo db 연습')),
        body: HomePage(),
      ),
    );
  }
}
