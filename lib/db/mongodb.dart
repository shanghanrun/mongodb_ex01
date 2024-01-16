import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongodb_ex01/db/constant.dart';
import 'package:mongodb_ex01/db/mongodbModel.dart';

class MongoDB {
  // static var db, userCollection;
  static late Db db;
  static late DbCollection userCollection;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    print('# 몽고디비(mydatabase) 접속성공');
    // inspect(db);
    userCollection = db.collection(USER_COLLECTION);
    print('# collection(youtube) 접속성공');
  }

  static Future<String> insertData(MongoDBModel data) async {
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

  static Future<String> updateData(MongoDBModel data) async {
    try {
      var result = await userCollection.updateOne({
        '_id': data.id
      }, {
        '\$set': {
          'firstName': data.firstName,
          'lastName': data.lastName,
          'address': data.address,
          'age': data.age
        }
      });
      if (result.isSuccess) {
        return "Data Updated";
      } else {
        return "Something went wrong while updating data";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  static Future<String> deleteData(MongoDBModel data) async {
    var id = data.id;
    try {
      var result = await userCollection.deleteOne({'_id': id});
      //  await userCollection.remove(where.id(data.id));
      if (result.isSuccess) {
        return "Deleted Successfully";
      } else {
        return "Document not found or deletion failed";
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

  static Future<List<Map<String, dynamic>>> queryData(
      int age, String option) async {
    if (option == '이하') {
      final arrData = await userCollection
          .find(where.lte('age', age))
          // .find(where.gte('age', 20).lt('age', 50))
          // .find(where.eq('firstName', 'Glen'))
          // .find(where.gt('age', 20).eq('firstName', 'Glen'))
          .toList();
      return arrData;
    } else {
      final arrData = await userCollection.find(where.gte('age', age)).toList();
      return arrData;
    }
  }
}
