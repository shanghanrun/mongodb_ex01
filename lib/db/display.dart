import 'package:flutter/material.dart';
import 'package:mongodb_ex01/db/mongodb.dart';
import 'package:mongodb_ex01/db/mongodbModel.dart';

class MongoDbDisplay extends StatefulWidget {
  const MongoDbDisplay({super.key});

  @override
  State<MongoDbDisplay> createState() => _MongoDbDisplayState();
}

class _MongoDbDisplayState extends State<MongoDbDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
            future: MongoDatabase.getData(), // 퓨처값 가져올 비동기 함수
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
                return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, i) {
                      final user = users[i];
                      return displayCard(MongoDbModel.fromJson(user));
                    });
              }
            }),
      )),
    );
  }

  Widget displayCard(MongoDbModel data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.id.oid),
            const SizedBox(height: 5),
            Text(data.firstName),
            const SizedBox(height: 5),
            Text(data.lastName),
            const SizedBox(height: 5),
            Text(data.address),
          ],
        ),
      ),
    );
  }
}
