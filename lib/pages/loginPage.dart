import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/base/view/base_state.dart';
import 'package:flutter_tiktok/pages/registerPage.dart';
import 'package:flutter_tiktok/pages/homePage.dart';
import 'package:flutter_tiktok/presenter/login_presenter.dart';
import 'package:flutter_tiktok/utils/toast.dart';
import 'package:flutter_tiktok/views/tiktokTabBar.dart';

/**
 * DESC: 登录
 * Author：原哥
 * QQ: 2729404527
 * Email: 2729404527@qq.com
 */

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends BaseState<LoginPage, LoginPresenter> {
  bool showPassword = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void loginSuccess() {
    Toast.show("登录成功");
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new HomePage()),
      (route) => route == null,
    );
  }

  void loginError() {
    Toast.show("账号或密码错误");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text('登录'),
          ),
          body: SafeArea(
            minimum: EdgeInsets.all(30),
            child: ListView(
              children: [
                TextField(
                  keyboardType: TextInputType.phone,
                  decoration:
                      InputDecoration(labelText: '用户名', hintText: '请输入用户名'),
                  controller: _usernameController,
                ),
                Padding(padding: EdgeInsets.all(10)),
                TextField(
                    obscureText: !showPassword,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: '密码',
                      hintText: '请输入密码',
                    )),
                Padding(padding: EdgeInsets.all(10)),
                // ignore: deprecated_member_use
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    if (TextUtil.isEmpty(username)) {
                      Toast.show("亲，用户名不能为空");
                      return;
                    }
                    if (TextUtil.isEmpty(password)) {
                      Toast.show("亲，密码不能为空");
                      return;
                    }
                    if (username.length < 6 && password.length < 6) {
                      Toast.show("亲，用户名和密码都不能低于6位哦");
                      return;
                    }

                    mPresenter.login(
                        _usernameController.text, _passwordController.text);
                  },
                  child: Text(
                    '登录',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('还没有账号，'),
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (cxt) => RegisterPage(),
                          ));
                        },
                        child: Text(
                          '去注册',
                          style: TextStyle(color: Colors.green),
                        ))
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Future<bool> _requestPop() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(
          builder: (context) => new HomePage(type: TikTokPageTag.home)),
      (route) => route == null,
    );
    return Future.value(false);
  }

  @override
  LoginPresenter createPresenter() {
    // TODO: implement createPresenter
    return LoginPresenter();
  }
}
