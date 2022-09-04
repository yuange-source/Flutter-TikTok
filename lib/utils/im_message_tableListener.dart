import 'package:sqflite/sqflite.dart';

abstract class IMTableListener {
  Future<Database> database;

  createTable();

  insert(Map<String, dynamic> values);

  queryList(String toUser);

  queryListByUser(String toUser,String fromUser);

}