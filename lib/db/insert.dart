import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mongodb_ex01/db/mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:mongodb_ex01/db/mongodbModel.dart';

class MongoInsert extends StatefulWidget {
  const MongoInsert({super.key});

  @override
  State<MongoInsert> createState() => _MongoInsertState();
}

class _MongoInsertState extends State<MongoInsert> {
  final firstNameControl = TextEditingController();
  final lastNameControl = TextEditingController();
  final addressControl = TextEditingController();

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
                  OutlinedButton(
                      onPressed: () async {
                        await _insertData(firstNameControl.text,
                            lastNameControl.text, addressControl.text);
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
    });
  }

  Future<void> _insertData(
      String firstName, String lastName, String address) async {
    var id = M.ObjectId(); // 저절로 Unique 키값을 생성해 준다.
    final data = MongoDbModel(
        id: id, firstName: firstName, lastName: lastName, address: address);
    var result = await MongoDatabase.insertData(data);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inserted ID ${id.oid}\n$result')));
    _clearAll();
  }

  void _clearAll() {
    firstNameControl.text = '';
    lastNameControl.text = '';
    addressControl.text = '';
  }
}
