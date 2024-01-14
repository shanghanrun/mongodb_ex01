import 'package:flutter/material.dart';
import 'package:mongodb_ex01/db/insert.dart';
import 'package:mongodb_ex01/db/mongodb.dart';
import 'package:mongodb_ex01/db/mongodbModel.dart';

class MongoDbUpdate extends StatefulWidget {
  const MongoDbUpdate({super.key});

  @override
  State<MongoDbUpdate> createState() => _MongoDbUpdateState();
}

class _MongoDbUpdateState extends State<MongoDbUpdate> {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip(
                    message: data.id.oid,
                    child: Text(data.id.oid.substring(0, 16))),
                const SizedBox(height: 5),
                Text(data.firstName),
                const SizedBox(height: 5),
                Text(data.lastName),
                const SizedBox(height: 5),
                Text(data.address.substring(0, 20)),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MongoDbInsert(),
                      settings: RouteSettings(arguments: data),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
