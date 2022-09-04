import 'dart:convert';
import 'dart:io';

import 'package:flutter_tiktok/base/presenter/base_presenter.dart';
import 'package:flutter_tiktok/bean/home_bean_entity.dart';
import 'package:flutter_tiktok/network/api/network_api.dart';
import 'package:flutter_tiktok/network/network_util.dart';
import 'package:flutter_tiktok/pages/homePage.dart';
import 'package:flutter_tiktok/utils/PreferenceUtils.dart';
import 'package:flutter_tiktok/utils/db_utils.dart';
import 'package:flutter_tiktok/utils/log_utils.dart';
import 'package:flutter_tiktok/utils/time_format_util.dart';
import 'package:flutter_tiktok/utils/toast.dart';
import 'package:qiniu_flutter_sdk/qiniu_flutter_sdk.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

/**
 * DESC: 首页
 * Author：原哥
 * QQ: 2729404527
 * Email: 2729404527@qq.com
 */

class HomePresenter extends BasePresenter<HomePageState> {
  String fileName, picName;
  bool isUpload;

  Future getVideoList(String pageNumber) async {
    Map<String, dynamic> queryParams = Map();
    queryParams["pageNumber"] = pageNumber;
    await requestFutureData<String>(Method.get,
        url: Api.GET_VIDEO_LIST,
        queryParams: queryParams,
        isShow: false, onSuccess: (data) {
      if (data != null) {
        view.updateHome(data);
      }
    }, onError: (code, msg) {});
  }

  void handleUploadCheck() {
    Future<String> result =
        PreferenceUtils.instance.getString("login_status", "0");
    result.then((value) => {
          if (value.toString() == "1")
            {view.showSelectionDialog(0)}
          else
            {view.jumpLogin()}
        });
  }

  Future getQiniuToken(String path) async {
    await requestFutureData<String>(Method.post,
        url: Api.GET_QN_TOKEN, isShow: true, onSuccess: (data) {
      Map<String, dynamic> map = parseData(data);
      map = map['data'];
      data = map['result'];
      if (data != null) {
        view.publishVideo(data, path);
      }
    }, onError: (code, msg) {
    });
  }

  void publish(String token, String path) {
    Future<String> result =
        PreferenceUtils.instance.getString("username", null);
    result.then((value) {
      this.isUpload = false;
      fileName =
          value.toString() + TimeFormatUtil.currentTimeMillis().toString();
      picName = value.toString() +
          "_pic_" +
          TimeFormatUtil.currentTimeMillis().toString();
      view.showProgressMsg("上传中");
      // 创建 storage 对象m
      Storage storage = Storage();
      // 创建 Controller 对象
      PutController putController = PutController();
      // 添加任务进度监听
      putController.addProgressListener((percent) {
        print('任务进度变化：已发送：$percent');
      });
      // 添加任务状态监听
      putController.addStatusListener((StorageStatus status) {
        print('状态变化: 当前任务状态：$status');
        if (status == StorageStatus.Success || status == StorageStatus.Error) {
          view.closeProgress();
        }
        if (status == StorageStatus.Success) {
          // Toast.show("上传成功");
          if (this.isUpload) return;
          this.isUpload = true;
          publishVideo(Api.QINIU_URL + fileName, value, "今天开心哈哈",
              Api.QINIU_URL + picName);
        }
        if (status == StorageStatus.Error) {
          Toast.show("上传失败");
        }
      });
      // 使用 storage 的 putFile 对象进行文件上传
      storage.putFile(File(path), token,
          options: PutOptions(
              controller: putController, key: fileName, forceBySingle: true));
      storage.putFile(File("/sdcard/temp.jpg"), token,
          options: PutOptions(
              controller: putController, key: picName, forceBySingle: true));
    });
  }

  void cropVideo(String path) {
    view.showProgressMsg("视频处理中...");
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    var arguments = [
      "-y",
      "-i",
      path,
      "-vcodec",
      "copy",
      "-acodec",
      "copy",
      "-ss",
      "00:00:00",
      "-t",
      "00:00:10",
      "/sdcard/temp.mp4"
    ];
    _flutterFFmpeg.executeWithArguments(arguments).then((rc) {
      print("FFmpeg process exited with rc $rc");
      getPicFromFrame("/sdcard/temp.mp4");
    });
  }

  void getPicFromFrame(String path) {
    view.showProgressMsg("视频处理中...");
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    var arguments = [
      "-y",
      "-i",
      path,
      "-ss",
      "1",
      "-f",
      "image2",
      "/sdcard/temp.jpg"
    ];
    _flutterFFmpeg.executeWithArguments(arguments).then((rc) {
      print("FFmpeg process exited with rc $rc");
      view.closeProgress();
      view.getQiniuToken("/sdcard/temp.mp4");
    });
  }

  Future publishVideo(
      String videourl, String username, String title, String picurl) async {
    Map<String, dynamic> queryParams = Map();
    queryParams["videourl"] = videourl;
    queryParams["username"] = username;
    queryParams["title"] = title;
    queryParams["picurl"] = picurl;
    await requestFutureData<String>(Method.post,
        url: Api.PUBLISH_VIDEO,
        isShow: true,
        queryParams: queryParams, onSuccess: (data) {
      Log.i("upload send result:" + data);
      Map<String, dynamic> map = parseData(data);
      int result = map['data'];
      if (result == 1) {
        view.showToast("发表成功");
      } else {
        view.showToast("发表失败");
      }
    }, onError: (code, msg) {
      view.closeProgress();
    });
  }

  Future addMessage(String toUser, String msg, int messageType) async {
    DBManager.instance.initDB();
    Future<String> result =
        PreferenceUtils.instance.getString("username", null);
    result.then((value) async {
      Map<String, dynamic> map = {};
      map["from_user"] = value;
      map["to_user"] = toUser;
      map["im_msg"] = msg;
      map["message_type"] = messageType;
      map["update_time"] = TimeFormatUtil.getCurrentDate();
      DBManager.instance.imMessageTable.insert(map);
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
