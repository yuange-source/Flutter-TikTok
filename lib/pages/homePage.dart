import 'dart:io';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/base/view/base_state.dart';
import 'package:flutter_tiktok/bean/home_bean_entity.dart';
import 'package:flutter_tiktok/mock/video.dart';
import 'package:flutter_tiktok/network/api/network_api.dart';
import 'package:flutter_tiktok/network/network_util.dart';
import 'package:flutter_tiktok/other/bottomSheet.dart' as CustomBottomSheet;
import 'package:flutter_tiktok/pages/loginPage.dart';
import 'package:flutter_tiktok/pages/chatPage.dart';
import 'package:flutter_tiktok/pages/searchPage.dart';
import 'package:flutter_tiktok/pages/userPage.dart';
import 'package:flutter_tiktok/presenter/home_presenter.dart';
import 'package:flutter_tiktok/utils/log_utils.dart';
import 'package:flutter_tiktok/utils/toast.dart';
import 'package:flutter_tiktok/utils/userStatic.dart';
import 'package:flutter_tiktok/views/tikTokCommentBottomSheet.dart';
import 'package:flutter_tiktok/views/tikTokHeader.dart';
import 'package:flutter_tiktok/views/tikTokScaffold.dart';
import 'package:flutter_tiktok/views/tikTokVideo.dart';
import 'package:flutter_tiktok/views/tikTokVideoButtonColumn.dart';
import 'package:flutter_tiktok/views/tikTokVideoPlayer.dart';
import 'package:flutter_tiktok/views/tiktokTabBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safemap/safemap.dart';

import 'samecityPage.dart';

/**
 * DESC: 首页
 * Author：原哥
 * QQ: 2729404527
 * Email: 2729404527@qq.com
 */

class HomePage extends StatefulWidget {
  final TikTokPageTag type;

  const HomePage({
    Key key,
    this.type,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends BaseState<HomePage, HomePresenter>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  TikTokPageTag tabBarType = TikTokPageTag.home;

  TikTokScaffoldController tkController = TikTokScaffoldController();

  PageController _pageController = PageController();

  VideoListController _videoListController = VideoListController();

  /// 记录点赞
  Map<int, bool> favoriteMap = {};

  List<UserVideo> videoDataList = [];

  WebSocket _webSocket;

  int pageNumber = 1;

  void connect(String userName) {
    Future<WebSocket> futureWebSocket =
        WebSocket.connect(Api.WEBSOCKET_URL + "/$userName"); //socket地址
    futureWebSocket.then((WebSocket ws) {
      _webSocket = ws;
      _webSocket.readyState;
      // 监听事件
      void onData(dynamic content) {
        print('收到消息msg:' + content);
        Map<String, dynamic> map = parseData(content);
        //单聊
        if (map['code'] == "1") {
          Toast.show("亲，您有新的消息哦");
          setState(() {
            if (map['user'].toString() != UserMessage.userId.toString()) {
              mPresenter.addMessage(map['user'], map['msg'], 1);
            }
          });
        }
        //群聊
        if (map['code'] == "3") {
          Toast.show("亲，您有新的消息哦");
          setState(() {
            if (map['user'].toString() != UserMessage.userId.toString()) {
              mPresenter.addMessage("1000000", map['msg'], 1);
            }
          });
        }
      }

      _webSocket.listen(onData,
          onError: (a) => print("error"), onDone: () => print("done"));
    });
  }

  void closeSocket() {
    _webSocket.close();
  }

  void connectServer(String currentUser) {
    Log.i("home connectServer--->currentUser:" + currentUser);
    UserMessage.userId = int.parse(currentUser);
    Log.i("connectServer--->userid:" + UserMessage.userId.toString());
    connect(UserMessage.userId.toString());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      _videoListController.currentPlayer.pause();
    }
  }

  @override
  void dispose() {
    _videoListController.currentPlayer.pause();
    closeSocket();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.type != null) {
      tabBarType = widget.type;
    }
    mPresenter.getVideoList(pageNumber.toString());
    mPresenter.connectServer();
    super.initState();
  }

  void updateHome(String data) {
    if (data == null) return;
    Map<String, dynamic> map = parseData(data);
    map = map["data"];
    List list = map["result"];
    Log.i("index show data list:" + list.toString());
    list.forEach((v) {
      videoDataList.add(new UserVideo(
          url: v["videourl"], image: v["city"], desc: v["title"]));
    });

    setState(() {
      _videoListController.init(
        _pageController,
        videoDataList,
      );
    });
  }

  void jumpLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (cxt) => LoginPage(),
    ));
  }

  void publishVideo(String token, String path) {
    mPresenter.publish(token, path);
  }

  void cropVideo(String path) {
    mPresenter.cropVideo(path);
  }

  void getQiniuToken(String path) {
    mPresenter.getQiniuToken(path);
  }

  Future getImage(ImageSource source, int type) async {
    var image = await ImagePicker.pickVideo(source: source);
    setState(() {
      mPresenter.cropVideo(image.path);
    });
  }

  void showSelectionDialog(int type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (ctx) {
        return Container(
          color: Colors.grey,
          height: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // GestureDetector(
              //   child: _itemCreat(context, '相机'),
              //   onTap: () {
              //     print('选中相机');
              //     Navigator.pop(context);
              //     getImage(ImageSource.camera, type);
              //   },
              // ),
              GestureDetector(
                child: _itemCreat(context, '相册'),
                onTap: () {
                  print('选中相册');
                  Navigator.pop(context);
                  Toast.show("敬请期待哦");
                  // getImage(ImageSource.gallery, type);
                },
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: _itemCreat(context, '取消'),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;

    switch (tabBarType) {
      case TikTokPageTag.home:
        break;
      case TikTokPageTag.follow:
        currentPage = SameCityPage();
        break;
      case TikTokPageTag.msg:
        currentPage = ChatPage();
        break;
      case TikTokPageTag.me:
        currentPage = UserPage();
        break;
    }
    double a = MediaQuery.of(context).size.aspectRatio;
    bool hasBottomPadding = a < 0.55;

    bool hasBackground = hasBottomPadding;
    hasBackground = tabBarType != TikTokPageTag.home;
    if (hasBottomPadding) {
      hasBackground = true;
    }
    Widget tikTokTabBar = TikTokTabBar(
      hasBackground: hasBackground,
      current: tabBarType,
      onTabSwitch: (type) async {
        setState(() {
          tabBarType = type;
          if (type == TikTokPageTag.home) {
            if (_videoListController.currentPlayer != null) {
              _videoListController.currentPlayer.start();
            }
          } else {
            if (_videoListController.currentPlayer != null) {
              _videoListController.currentPlayer.pause();
            }
          }
        });
      },
      onAddButton: () {
        mPresenter.handleUploadCheck();
      },
    );

    var searchPage = SearchPage(
      onPop: tkController.animateToMiddle,
    );

    var header = tabBarType == TikTokPageTag.home
        ? TikTokHeader(
            onSearch: () {
              tkController.animateToLeft();
            },
          )
        : Container();

    // 组合
    return TikTokScaffold(
      controller: tkController,
      hasBottomPadding: hasBackground,
      tabBar: tikTokTabBar,
      header: header,
      leftPage: searchPage,
      enableGesture: tabBarType == TikTokPageTag.home,
      // onPullDownRefresh: _fetchData,
      page: Stack(
        // index: currentPage == null ? 0 : 1,
        children: <Widget>[
          PageView.builder(
            key: Key('home'),
            controller: _pageController,
            pageSnapping: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: _videoListController.videoCount,
            itemBuilder: (context, i) {
              // 拼一个视频组件出来
              var data = videoDataList[i];
              bool isF = SafeMap(favoriteMap)[i].boolean ?? false;
              var player = _videoListController.playerOfIndex(i);
              // 右侧按钮列
              Widget buttons = TikTokButtonColumn(
                isFavorite: isF,
                onAvatar: () {
                  tkController.animateToPage(TikTokPagePositon.right);
                },
                onFavorite: () {
                  setState(() {
                    favoriteMap[i] = !isF;
                  });
                  // showAboutDialog(context: context);
                },
                onComment: () {
                  CustomBottomSheet.showModalBottomSheet(
                    backgroundColor: Colors.white.withOpacity(0),
                    context: context,
                    builder: (BuildContext context) =>
                        TikTokCommentBottomSheet(),
                  );
                },
                onShare: () {},
              );
              // video
              Widget currentVideo = Center(
                child: FijkView(
                  fit: FijkFit.fitHeight,
                  player: player,
                  color: Colors.black,
                  panelBuilder: (_, __, ___, ____, _____) => Container(),
                ),
              );

              currentVideo = TikTokVideoPage(
                hidePauseIcon: player.state != FijkState.paused,
                aspectRatio: 9 / 16.0,
                key: Key(data.url + '$i'),
                tag: data.url,
                backgroundImage: data.image,
                bottomPadding: hasBottomPadding ? 16.0 : 16.0,
                userInfoWidget: VideoUserInfo(
                  desc: data.desc,
                  bottomPadding: hasBottomPadding ? 16.0 : 50.0,
                  // onGoodGift: () => showDialog(
                  //   context: context,
                  //   builder: (_) => FreeGiftDialog(),
                  // ),
                ),
                onSingleTap: () async {
                  mPresenter.getVideoList(pageNumber.toString());
                  if (player.state == FijkState.started) {
                    await player.pause();
                  } else {
                    await player.start();
                  }
                  setState(() {});
                },
                onAddFavorite: () {
                  setState(() {
                    favoriteMap[i] = true;
                  });
                },
                rightButtonColumn: buttons,
                video: currentVideo,
              );
              return currentVideo;
            },
          ),
          Opacity(
            opacity: 1,
            child: currentPage ?? Container(),
          ),
        ],
      ),
    );
  }

  Widget _itemCreat(BuildContext context, String title) {
    return Container(
      color: Colors.white,
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  HomePresenter createPresenter() {
    // TODO: implement createPresenter
    return HomePresenter();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
