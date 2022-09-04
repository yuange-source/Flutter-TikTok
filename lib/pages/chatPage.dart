import 'package:flutter/material.dart';
import 'package:flutter_tiktok/base/view/base_state.dart';
import 'package:flutter_tiktok/bean/chatUsersModel.dart';
import 'package:flutter_tiktok/presenter/chatpage_presenter.dart';
import '../widgets/conversationList.dart';
import 'loginPage.dart';

/**
 * DESC: 聊天
 * Author：原哥
 * QQ: 2729404527
 * Email: 2729404527@qq.com
 */
class ChatPage extends StatefulWidget {
  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends BaseState<ChatPage, ChatPagePresenter> {
  List<ChatUsers> chatUsers = [];

  void jumpLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (cxt) => LoginPage(),
    ));
  }

  void initChatInfo() {
    mPresenter.checkChatStatus();
  }

  @override
  void initState() {
    super.initState();
    mPresenter.checkLoginStatus();
  }

  showMessage(List<Map<String, dynamic>> maps) {
    setState(() {
      maps.forEach((element) {
        chatUsers.add(ChatUsers(
            name: element["from_user"],
            messageText: element["im_msg"],
            imageURL: "lib/assets/images/icon_head.png",
            time: element["update_time"]));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "消息",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ConversationList(
                  name: chatUsers[index].name,
                  messageText: chatUsers[index].messageText,
                  imageUrl: chatUsers[index].imageURL,
                  time: chatUsers[index].time,
                  isMessageRead: (index == 0 || index == 3) ? true : false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  ChatPagePresenter createPresenter() {
    return ChatPagePresenter();
  }
}
