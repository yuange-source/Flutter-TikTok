import 'package:flutter_tiktok/base/presenter/base_presenter.dart';
import 'package:flutter_tiktok/bean/home_bean_entity.dart';
import 'package:flutter_tiktok/network/api/network_api.dart';
import 'package:flutter_tiktok/network/network_util.dart';
import 'package:flutter_tiktok/pages/userPage.dart';
import 'package:flutter_tiktok/utils/PreferenceUtils.dart';

/**
 * DESC: 用户
 * Author：原哥
 * QQ: 2729404527
 * Email: 2729404527@qq.com
 */

class UserPresenter extends BasePresenter<UserPageState> {
  void checkLoginStatus() {
    Future<String> result =
        PreferenceUtils.instance.getString("login_status", "0");
    result.then((value) => {
          if (value != "1") {view.jumpLogin()} else {getAccount()}
        });
  }

  void getAccount() {
    Future<String> result =
        PreferenceUtils.instance.getString("username", null);
    result.then((value) => {view.showAccount(value)});
  }

  Future getUserVideoInfo() async {
    await requestFutureData<HomeBeanEntity>(Method.get,
        url: Api.GET_USER_VIDEOINFO,
        isShow: false,
        isClose: false,
        isList: false, onSuccess: (data) {
      if (data != null) {
      } else {}
    }, onError: (code, msg) {});
  }

  Future getUserPeronInfo() async {
    await requestFutureData<HomeBeanEntity>(Method.post,
        url: Api.GET_USER_PERONINFO,
        isShow: false,
        isClose: false,
        isList: false, onSuccess: (data) {
      if (data != null) {
      } else {}
    }, onError: (code, msg) {});
  }
}
