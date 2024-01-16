import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

MongoDBModel MongoDBModelFromJson(String str) =>
    MongoDBModel.fromJson(json.decode(str));

String MongoDBModelToJson(MongoDBModel data) => json.encode(data.toJson());

class MongoDBModel {
  ObjectId id;
  String firstName;
  String lastName;
  String address;
  int age;

  MongoDBModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.age,
  });

  factory MongoDBModel.fromJson(Map<String, dynamic> json) => MongoDBModel(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        address: json["address"],
        age: json["age"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "address": address,
        "age": age,
      };
}
