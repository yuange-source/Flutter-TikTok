import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/base/view/base_state.dart';
import 'package:flutter_tiktok/mock/video.dart';
import 'package:flutter_tiktok/pages/userDetailPage.dart';
import 'package:flutter_tiktok/presenter/user_presenter.dart';
import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter_tiktok/utils/log_utils.dart';
import 'package:flutter_tiktok/views/topToolRow.dart';
import 'package:tapped/tapped.dart';
import 'loginPage.dart';

List<UserVideo> videoDataList = [];

// don't forget to dispose refreshController
@override
void dispose() {
  // TODO: implement dispose
}

class UserPage extends StatefulWidget {
  final bool canPop;
  final Function onPop;
  final Function onSwitch;

  const UserPage({Key key, this.canPop: false, this.onPop, this.onSwitch})
      : super(key: key);

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends BaseState<UserPage, UserPresenter> {
  String account = "";

  @override
  void initState() {
    super.initState();
    mPresenter.checkLoginStatus();
  }

  void jumpLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (cxt) => LoginPage(),
    ));
  }

  void showAccount(String account) {
    setState(() {
      this.account = account;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      height: 120 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(left: 18),
      alignment: Alignment.bottomLeft,
      child: OverflowBox(
        alignment: Alignment.bottomLeft,
        minHeight: 20,
        maxHeight: 300,
        child: Container(
          height: 74,
          width: 74,
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(44),
            color: Colors.orange,
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              "https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
    Widget body = ListView(
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: <Widget>[
        Container(height: 20),
        // 头像与关注
        Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[avatar],
        ),
        Container(
          color: ColorPlate.back1,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 18),
                color: ColorPlate.back1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      this.account,
                      style: StandardTextStyle.big,
                    ),
                    Container(height: 8),
                    Text(
                      '骚年，撸起袖子加油干！',
                      style: StandardTextStyle.smallWithOpacity.apply(
                        color: Colors.white,
                      ),
                    ),
                    Container(height: 10),
                    Row(
                      children: <Widget>[
                        _UserTag(tag: '幽默'),
                        _UserTag(tag: '机智'),
                        _UserTag(tag: '枯燥'),
                        _UserTag(tag: '狮子座'),
                      ],
                    ),
                    Container(height: 10),
                  ],
                ),
              ),
              Container(
                color: ColorPlate.back1,
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextGroup('356', '关注'),
                    TextGroup('145万', '粉丝'),
                    TextGroup('1423万', '获赞'),
                  ],
                ),
              ),
              Container(
                height: 10,
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              _UserVideoTable(),
            ],
          ),
        ),
      ],
    );
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: <Color>[
            Colors.orange,
            Colors.red,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 400),
            height: double.infinity,
            width: double.infinity,
            color: ColorPlate.back1,
          ),
          body,
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 62,
            child: TopToolRow(
              canPop: widget.canPop,
              onPop: widget.onPop,
              right: Tapped(
                child: Container(
                  width: 30,
                  height: 30,
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.36),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.more_horiz,
                    size: 24,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => UserDetailPage(),
                  ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  UserPresenter createPresenter() {
    // TODO: implement createPresenter
    return UserPresenter();
  }
}

class _UserTag extends StatelessWidget {
  final String tag;

  const _UserTag({
    Key key,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        tag ?? '标签',
        style: StandardTextStyle.smallWithOpacity,
      ),
    );
  }
}

class _UserVideoTable extends StatelessWidget {
  const _UserVideoTable({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget gd = GridView.count(
      //水平子Widget之间间距
      crossAxisSpacing: 10.0,
      //垂直子Widget之间间距
      mainAxisSpacing: 10.0,
      //GridView内边距
      padding: EdgeInsets.all(20.0),
      //一行的Widget数量
      crossAxisCount: 2,
      //子Widget宽高比例
      childAspectRatio: 1.0,
      //子Widget列表
      children: getWidgetList(),
    );

    return Column(
      children: <Widget>[
        Container(
          color: ColorPlate.back1,
          padding: EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _PointSelectTextButton(true, '作品'),
              _PointSelectTextButton(false, '关注'),
              _PointSelectTextButton(false, '喜欢'),
            ],
          ),
        ),
        Container(height: 300, width: double.infinity, child: gd),
      ],
    );
  }
}

class _PointSelectTextButton extends StatelessWidget {
  final bool isSelect;
  final String title;
  final Function onTap;

  const _PointSelectTextButton(
    this.isSelect,
    this.title, {
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isSelect
              ? Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: ColorPlate.orange,
                    borderRadius: BorderRadius.circular(3),
                  ),
                )
              : Container(),
          Container(
            padding: EdgeInsets.only(left: 2),
            child: Text(
              title,
              style: isSelect
                  ? StandardTextStyle.small
                  : StandardTextStyle.smallWithOpacity,
            ),
          )
        ],
      ),
    );
  }
}

List<String> getDataList() {
  List<String> list = [];
  for (int i = 0; i < 100; i++) {
    list.add(i.toString());
  }
  return list;
}

List<Widget> getWidgetList() {
  return getDataList().map((item) => getItemContainer(item)).toList();
}

Widget getItemContainer(String item) {
  return Container(
    child: AspectRatio(
      aspectRatio: 3 / 4.0,
      child: Container(
        decoration: BoxDecoration(
          color: ColorPlate.darkGray,
          border: Border.all(color: Colors.black),
        ),
        alignment: Alignment.center,
        child: Text(
          '作品',
          style: TextStyle(
            color: Colors.white.withOpacity(0.1),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    ),
  );
}

class TextGroup extends StatelessWidget {
  final String title, tag;
  final Color color;

  const TextGroup(
    this.title,
    this.tag, {
    Key key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            title,
            style: StandardTextStyle.big.apply(color: color),
          ),
          Container(width: 4),
          Text(
            tag,
            style: StandardTextStyle.smallWithOpacity.apply(
              color: color?.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
