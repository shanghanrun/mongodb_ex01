import 'package:flutter/material.dart';
import 'package:mongodb_ex01/db/queryData.dart';
import 'package:mongodb_ex01/db/updateData.dart';
import 'package:mongodb_ex01/db/insertData.dart';
import 'package:mongodb_ex01/db/mongodb.dart';
import 'package:mongodb_ex01/db/mongodbModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const InsertData()));
            },
          ),
          ElevatedButton(
            child: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const QueryData()));
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
            future: MongoDB.getData(), // 퓨처값 가져올 비동기 함수
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
                      return displayCard(MongoDBModel.fromJson(user));
                    });
              }
            }),
      )),
    );
  }

  Widget displayCard(MongoDBModel data) {
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
                Text(data.address.substring(0, 18)),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpdateData(),
                      settings: RouteSettings(arguments: data),
                    )).then((value) => setState(() {}));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await deleteData(data);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteData(MongoDBModel data) async {
    var result = await MongoDB.deleteData(data);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1), content: Text('A record was deleted')));
    setState(() {});
  }
}
