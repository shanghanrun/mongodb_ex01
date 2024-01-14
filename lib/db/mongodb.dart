import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongodb_ex01/db/constant.dart';
import 'package:mongodb_ex01/db/mongodbModel.dart';

class MongoDatabase {
  static var db, userCollection;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    print('# 몽고디비(mydatabase) 접속성공');
    // inspect(db);
    userCollection = db.collection(USER_COLLECTION);
    print('# collection(youtube) 접속성공');
  }

  static Future<String> insertData(MongoDbModel data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "Something Wrong while inserting data";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrData = await userCollection.find().toList(); // 모두 받아오기 find()
    return arrData;
  }
}
