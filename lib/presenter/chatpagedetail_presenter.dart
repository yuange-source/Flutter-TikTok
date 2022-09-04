import 'package:flutter_tiktok/base/presenter/base_presenter.dart';
import 'package:flutter_tiktok/network/api/network_api.dart';
import 'package:flutter_tiktok/network/network_util.dart';
import 'package:flutter_tiktok/pages/chatDetailPage.dart';
import 'package:flutter_tiktok/utils/PreferenceUtils.dart';
import 'package:flutter_tiktok/utils/db_utils.dart';
import 'package:flutter_tiktok/utils/log_utils.dart';
import 'package:flutter_tiktok/utils/time_format_util.dart';

/**
 * DESC: 聊天室
 * Author：原哥
 * QQ: 2729404527
 * Email: 2729404527@qq.com
 */
class ChatPageDetailPresenter extends BasePresenter<ChatDetailPageState> {
  Future getChatInfoDetail(String fromUser) async {
    Log.i("getChatInfoDetail--->" + fromUser);
    DBManager.instance.initDB();
    Future<String> result =
        PreferenceUtils.instance.getString("username", null);
    result.then((value) {
      Log.i("getChatInfoDetail value--->" + value);
      DBManager.instance.imMessageTable
          .queryListByUser(value.toString(), fromUser)
          .then((maps) => view.showMessageDetail(maps));
    });
  }

  Future getSessionIDByUser(String toUser, bool isFirst) async {
    Log.i("get用户session user:" + toUser);
    Map<String, dynamic> queryParams = Map();
    queryParams["user"] = toUser;
    await requestFutureData<String>(Method.post,
        url: Api.GET_SESSION_ID_BY_USER,
        isShow: false,
        queryParams: queryParams, onSuccess: (data) {
      Map<String, dynamic> map = parseData(data);
      if (map['data'] != "无返回信息") {
        String id = map['data'];
        Log.i("获取用户session:" + id.toString());
        view.setSessionID(id.toString());
        if (!isFirst) {
          view.sendMsg();
        }
      } else {
        view.setSessionID(null);
        if (!isFirst) {
          view.showToast("亲，对方不在线哦");
        }
      }
    }, onError: (code, msg) {
      view.setSessionID(null);
      if (!isFirst) {
        view.showToast("亲，对方不在线哦");
      }
    });
  }

  Future addMessage(String toUser, String msg, int messageType) async {
    DBManager.instance.initDB();
    Future<String> result =
        PreferenceUtils.instance.getString("username", null);
    result.then((value) async {
      Map<String, dynamic> map = {};
      map["from_user"] = value.toString();
      map["to_user"] = toUser;
      map["im_msg"] = msg;
      map["message_type"] = messageType;
      map["update_time"] = TimeFormatUtil.getCurrentDate();
      DBManager.instance.imMessageTable.insert(map);
      getChatInfoDetail(toUser);
    });
  }

  void connectServer() {
    Future<String> result =
        PreferenceUtils.instance.getString("username", null);
    result.then((value) {
      view.connectServer(value.toString());
    });
  }
}
