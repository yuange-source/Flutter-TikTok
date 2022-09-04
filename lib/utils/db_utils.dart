
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'im_message_table.dart';

class DBManager {
  // 单例公开访问点
  factory DBManager() => _sharedInstance();

  static DBManager get instance => _sharedInstance();

  // 静态私有成员，没有初始化
  static DBManager _instance;

  // 私有构造函数
  DBManager._() {
    // 具体初始化代码
  }

  // 静态、同步、DBManager
  static DBManager _sharedInstance() {
    if (_instance == null) {
      _instance = DBManager._();
    }
    return _instance;
  }

  /// init db
  Future<Database> database;
  final IMMessageTable imMessageTable = IMMessageTable();
  // final SessionChatTable sessionChatTable = SessionChatTable();

  initDB() async {
    try {
      // String uid = UserManager.instance.userInfo.uid;
      database = openDatabase(
        // Set the path to the database.
        // 需要升级可以直接修改数据库名称
        join(await getDatabasesPath(), 'message_database_v1.db'),
        // When the database is first created, create a table to store dogs.
        onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
          try {
            Batch batch = db.batch();
            _createTable().forEach((element) {
              batch.execute(element);
            });
            batch.commit();
          } catch (err) {
            throw (err);
          }
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) {
          try {
            Batch batch = db.batch();
            _createTable().forEach((element) {
              batch.execute(element);
            });
            batch.commit();
          } catch (err) {
            throw (err);
          }
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
      );
      imMessageTable.database = database;
      // sessionChatTable.database = database;
    } catch (err) {
      throw (err);
    }
  }

  /// close db
  closeDB() async {
    await database
      ..close();
  }

  /// create table
  List<String> _createTable() {
    return [imMessageTable.createTable()];
  }
}