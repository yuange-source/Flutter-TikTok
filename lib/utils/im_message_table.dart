import 'package:flutter_tiktok/utils/log_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'im_message_tableListener.dart';

class IMMessageTable implements IMTableListener {

  @override
  Future<Database> database;

  final String imMessageTable = 'IMMessageTable';

  @override
  createTable() {
    return "CREATE TABLE IF NOT EXISTS $imMessageTable ("
        "im_id INTEGER PRIMARY KEY,"
        " from_user TEXT,"
        " to_user TEXT,"
        " update_time TEXT,"
        " message_type INTEGER,"
        " im_msg TEXT)";
  }

  @override
  insert(Map<String, dynamic> values) async {
    final Database db = await database;
    try {
      Batch batch = db.batch();
        batch.insert(
          imMessageTable,
          values,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      await batch.commit();
      Log.i("im--->insert-->success");
    } catch (err) {
      Log.i("im--->insert-->err:"+err);
      throw err;
    }
  }

  @override
   queryList(String toUser) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(imMessageTable,
        where: 'to_user = '+toUser+' and from_user!='+toUser+' ',
        groupBy: 'from_user',
        orderBy: 'update_time DESC');
    Log.i("im--->queryList-->success:"+toUser+","+maps.toString());
    return maps;
  }

  @override
   queryListByUser(String toUser, String fromUser) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(imMessageTable,
        where: ' ( to_user = '+toUser+' and from_user ='+fromUser+' ) or  ( to_user = '+fromUser+' and from_user = '+toUser+' ) ',
        orderBy: 'update_time asc');
    return maps;
  }



}