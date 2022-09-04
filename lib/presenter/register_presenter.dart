import 'package:flutter_tiktok/base/presenter/base_presenter.dart';
import 'package:flutter_tiktok/network/api/network_api.dart';
import 'package:flutter_tiktok/network/network_util.dart';
import 'package:flutter_tiktok/pages/registerPage.dart';
import 'package:flutter_tiktok/utils/PreferenceUtils.dart';
import 'package:flutter_tiktok/utils/log_utils.dart';

/**
 * DESC: 注册
 * Author：原哥
 * QQ: 2729404527
 * Email: 2729404527@qq.com
 */

class RegPresenter extends BasePresenter<RegisterPageState> {
  Future regsiter(String username, String password) async {
    Map<String, dynamic> queryParams = Map();
    queryParams["username"] = username;
    queryParams["password"] = password;
    await requestFutureData<String>(Method.post,
        url: Api.REGSITER,
        isShow: true,
        isClose: false,
        queryParams: queryParams, onSuccess: (data) {
      Log.e("reg----->" + data);
      Map<String, dynamic> map = parseData(data);
      int result = map['data'];
      if (result == 1) {
        PreferenceUtils.instance.saveString("username", username);
        PreferenceUtils.instance.saveString("password", password);
        PreferenceUtils.instance.saveString("login_status", "1");
        view.regSuccess();
      } else {
        view.regError();
      }
    }, onError: (code, msg) {});
  }
}
