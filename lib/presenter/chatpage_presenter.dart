import 'package:flutter_tiktok/base/presenter/base_presenter.dart';
import 'package:flutter_tiktok/pages/chatPage.dart';
import 'package:flutter_tiktok/utils/PreferenceUtils.dart';
import 'package:flutter_tiktok/utils/db_utils.dart';
import 'package:flutter_tiktok/utils/log_utils.dart';
import 'package:flutter_tiktok/utils/time_format_util.dart';

/**
 * DESC: 聊天
 * Author：原哥
 * QQ: 2729404527
 * Email: 2729404527@qq.com
 */

class ChatPagePresenter extends BasePresenter<ChatPageState> {
  Future checkChatStatus() async {
    Future<String> status =
        PreferenceUtils.instance.getString("chat_status", null);
    status.then((value) => {initChatInfo(value.toString())});
  }

  Future initChatInfo(String res) async {
    await DBManager.instance.initDB();
    Future<String> result =
        PreferenceUtils.instance.getString("username", null);
    result.then((value) async {
      if (res != "1") {
        Map<String, dynamic> map = {};
        map["from_user"] = "13888888888";
        map["to_user"] = value;
        map["im_msg"] = "你好，我是13888888888";
        map["message_type"] = 1;
        map["update_time"] = TimeFormatUtil.getCurrentDate();
        await DBManager.instance.imMessageTable.insert(map);
        map["from_user"] = "15888888888";
        map["to_user"] = value;
        map["im_msg"] = "你好，我是15888888888";
        map["message_type"] = 1;
        map["update_time"] = TimeFormatUtil.getCurrentDate();
        await DBManager.instance.imMessageTable.insert(map);
        map["from_user"] = "16888888888";
        map["to_user"] = value;
        map["im_msg"] = "你好，我是16888888888";
        map["message_type"] = 1;
        map["update_time"] = TimeFormatUtil.getCurrentDate();
        await DBManager.instance.imMessageTable.insert(map);
        map["from_user"] = "17888888888";
        map["to_user"] = value;
        map["im_msg"] = "你好，我是17888888888";
        map["message_type"] = 1;
        map["update_time"] = TimeFormatUtil.getCurrentDate();
        await DBManager.instance.imMessageTable.insert(map);
        map["from_user"] = "18888888888";
        map["to_user"] = value;
        map["im_msg"] = "你好，我是18888888888";
        map["message_type"] = 1;
        map["update_time"] = TimeFormatUtil.getCurrentDate();
        await DBManager.instance.imMessageTable.insert(map);
        map["from_user"] = "19888888888";
        map["to_user"] = value;
        map["im_msg"] = "你好，我是19888888888";
        map["message_type"] = 1;
        map["update_time"] = TimeFormatUtil.getCurrentDate();
        await DBManager.instance.imMessageTable.insert(map);
        map["from_user"] = "1000000";
        map["to_user"] = value;
        map["im_msg"] = "大家好，我是群聊哦";
        map["message_type"] = 1;
        map["update_time"] = TimeFormatUtil.getCurrentDate();
        await DBManager.instance.imMessageTable.insert(map);
        PreferenceUtils.instance.saveString("chat_status", "1");
      }
      await DBManager.instance.imMessageTable
          .queryList(value)
          .then((maps) => {view.showMessage(maps)});
    });
  }

  void checkLoginStatus() {
    Future<String> result =
        PreferenceUtils.instance.getString("login_status", "0");
    result.then((value) => {
          if (value != "1") {view.jumpLogin()} else {view.initChatInfo()}
        });
  }
}
