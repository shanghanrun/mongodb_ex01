import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mongodb_ex01/db/mongodb.dart';
import 'package:mongodb_ex01/db/mongodbModel.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class InsertData extends StatefulWidget {
  const InsertData({super.key});

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {
  final firstNameControl = TextEditingController();
  final lastNameControl = TextEditingController();
  final addressControl = TextEditingController();
  final ageControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'Insert Data',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 50),
              Expanded(
                child: TextField(
                  controller: firstNameControl,
                  decoration: const InputDecoration(
                      labelText: 'FirstName', fillColor: Colors.blue),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: lastNameControl,
                  decoration: const InputDecoration(
                      labelText: 'LastName', fillColor: Colors.blue),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: ageControl,
                  decoration: const InputDecoration(
                      labelText: 'age', fillColor: Colors.blue),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: TextField(
                  controller: addressControl,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      labelText: 'address', fillColor: Colors.blue),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        fakeData();
                      },
                      child: const Text('Generate Data')),
                  ElevatedButton(
                      onPressed: () async {
                        await _insertData(
                            firstNameControl.text,
                            lastNameControl.text,
                            addressControl.text,
                            int.parse(ageControl.text));
                      },
                      child: const Text('Insert Data')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fakeData() {
    setState(() {
      firstNameControl.text = faker.person.firstName();
      lastNameControl.text = faker.person.lastName();
      addressControl.text =
          "${faker.address.streetName()}\n${faker.address.streetAddress()}";
      ageControl.text = (Random().nextInt(70) + 10).toString();
    });
  }

  Future<void> _insertData(
      String firstName, String lastName, String address, int age) async {
    var id = M.ObjectId(); // 저절로 Unique 키값을 생성해 준다.
    final data = MongoDBModel(
        id: id,
        firstName: firstName,
        lastName: lastName,
        address: address,
        age: age);
    var result = await MongoDB.insertData(data);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 1),
        content: Text('Inserted ID ${id.oid}\n$result')));
    _clearAllText();
  }

  void _clearAllText() {
    firstNameControl.text = '';
    lastNameControl.text = '';
    addressControl.text = '';
    ageControl.text = '';
  }
}
