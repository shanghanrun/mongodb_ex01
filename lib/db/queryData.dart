import 'package:flutter/material.dart';
import 'package:mongodb_ex01/db/mongodb.dart';
import 'package:mongodb_ex01/db/mongodbModel.dart';

class QueryData extends StatefulWidget {
  const QueryData({super.key});

  @override
  State<QueryData> createState() => _QueryDataState();
}

class _QueryDataState extends State<QueryData> {
  final ageControl = TextEditingController(text:'30');
  String selectedOption = '이하';
  int _age = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
            future: MongoDB.queryData(_age, selectedOption), // 퓨처값 가져올 비동기 함수
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data'));
              } else {
                var totalData = snapshot.data!.length;
                print('Total Data: $totalData');
                final users = snapshot.data!;
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, i) {
                            final user = users[i];
                            return displayCard(MongoDBModel.fromJson(user));
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: TextField(
                        controller: ageControl,
                        decoration: const InputDecoration(
                            labelText: '나이', fillColor: Colors.blue),
                        keyboardType: TextInputType.number,
                        onTap:(){
                          ageControl.clear(); // 텍스트 필드 클리어
                        }
                      ),
                    ),
                    Row(
                      children: [
                        Radio(
                            value: '이하',
                            groupValue: selectedOption,
                            onChanged: (String? value) {
                              setState(() {
                                selectedOption = value ?? '이하';
                              });
                            }),
                        const Text('이하'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            value: '이상',
                            groupValue: selectedOption,
                            onChanged: (String? value) {
                              setState(() {
                                selectedOption = value ?? '이상';
                              });
                            }),
                        const Text('이상'),
                      ],
                    ),
                    ElevatedButton(
                      child: const Text('검색'),
                      onPressed: () {
                        setState(() {
                          _age = int.parse(ageControl.text);
                        });

                        // await MongoDB.queryData(_age, selectedOption);
                      },
                    ),
                  ],
                );
              }
            }),
      )),
    );
  }

  Widget displayCard(MongoDBModel data) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${data.firstName} ${data.lastName}'),
            Text('age: ${data.age}'),
          ],
        ),
      ),
    );
  }
}
