import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mongodb_ex01/db/mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:mongodb_ex01/db/mongodbModel.dart';

class UpdateData extends StatefulWidget {
  const UpdateData({super.key});

  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  final firstNameControl = TextEditingController();
  final lastNameControl = TextEditingController();
  final addressControl = TextEditingController();
  final ageControl = TextEditingController();
  late MongoDBModel data;
  late M.ObjectId id;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as MongoDBModel;
    id = data.id;
    firstNameControl.text = data.firstName;
    lastNameControl.text = data.lastName;
    addressControl.text = data.address;
    ageControl.text = (data.age).toString();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'Update Data',
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await _updateData(
                            id,
                            firstNameControl.text,
                            lastNameControl.text,
                            addressControl.text,
                            int.parse(ageControl.text));
                      },
                      child: const Text('Update Data')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateData(M.ObjectId id, String firstName, String lastName,
      String address, int age) async {
    final data = MongoDBModel(
        id: id,
        firstName: firstName,
        lastName: lastName,
        address: address,
        age: age);
    await MongoDB.updateData(data)
        .whenComplete(() => Navigator.of(context).pop());
  }
}
