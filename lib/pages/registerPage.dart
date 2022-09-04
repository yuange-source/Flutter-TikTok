import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/base/view/base_state.dart';
import 'package:flutter_tiktok/pages/loginPage.dart';
import 'package:flutter_tiktok/presenter/register_presenter.dart';
import 'package:flutter_tiktok/utils/toast.dart';

import 'homePage.dart';

/**
 * DESC: 注册
 * Author：原哥
 * QQ: 2729404527
 * Email: 2729404527@qq.com
 */

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends BaseState<RegisterPage, RegPresenter> {
  bool showPassword = false;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void regSuccess() {
    Toast.show("注册成功");
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new HomePage()),
          (route) => route == null,
    );
  }

  void regError() {
    Toast.show("注册失败");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(30),
        child: ListView(
          children: [
            TextField(
              keyboardType: TextInputType.phone,
              controller: _usernameController,
              decoration: InputDecoration(labelText: '用户名', hintText: '请输入用户名'),
            ),
            Padding(padding: EdgeInsets.all(10)),
            TextField(
              controller: _passwordController,
              obscureText: !showPassword,
              decoration: InputDecoration(labelText: '密码', hintText: '请输入密码'),
            ),
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
                mPresenter.regsiter(username, password);
              },
              child: Text(
                '注册',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('有账号，'),
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (cxt) => LoginPage(),
                      ));
                    },
                    child: Text(
                      '去登录',
                      style: TextStyle(color: Colors.green),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  createPresenter() {
    // TODO: implement createPresenter
    return RegPresenter();
  }
}
