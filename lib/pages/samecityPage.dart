import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/pages/samecityVideoListPage.dart';
import 'package:flutter_tiktok/views/tilTokAppBar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/**
 * DESC: 同城
 * Author：原哥
 * QQ: 2729404527
 * Email: 2729404527@qq.com
 */

RefreshController _refreshController = RefreshController(initialRefresh: true);

void _onRefresh() async {
  // monitor network fetch
  await Future.delayed(Duration(milliseconds: 1000));
  // if failed,use refreshFailed()
  _refreshController.refreshCompleted();
}

void _onLoading() async {
  // monitor network fetch
  await Future.delayed(Duration(milliseconds: 1000));
  _refreshController.loadComplete();
}

@override
void dispose() {
  // TODO: implement dispose
  _refreshController.dispose();
}

class SameCityPage extends StatefulWidget {
  @override
  _SameCityPageState createState() => _SameCityPageState();
}

BuildContext _buildContext;

class _SameCityPageState extends State<SameCityPage> {
  int select = 0;

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
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
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else {
              body = Text("没有数据了");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: gd,
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
  return new GestureDetector(
    onTap: () {
      //处理点击事件
      Navigator.of(_buildContext).push(
        MaterialPageRoute(
          fullscreenDialog: false,
          builder: (context) => SameCityVideoListPage(),
        ),
      );
    },
    child: Column(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              child: Image.network(
            'https://img1.baidu.com/it/u=305769238,1603489955&fm=253&fmt=auto&app=120&f=JPEG?w=1200&h=750',
            width: 220,
            height: 230,
            fit: BoxFit.cover,
          )),
          Container(
              alignment: Alignment.center,
              height: 20,
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              // padding: const EdgeInsets.all(10.0),
              child: Text(
                "小姐姐  20岁", style: TextStyle(fontSize: 14), //设置行距的方法
              )),
        ]),
  );
}
