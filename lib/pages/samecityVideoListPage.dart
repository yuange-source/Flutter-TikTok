import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/mock/video.dart';

/// 单独修改了bottomSheet组件的高度
import 'package:flutter_tiktok/other/bottomSheet.dart' as CustomBottomSheet;
import 'package:flutter_tiktok/pages/cameraPage.dart';
import 'package:flutter_tiktok/pages/searchPage.dart';
import 'package:flutter_tiktok/views/tikTokCommentBottomSheet.dart';
import 'package:flutter_tiktok/views/tikTokScaffold.dart';
import 'package:flutter_tiktok/views/tikTokVideo.dart';
import 'package:flutter_tiktok/views/tikTokVideoButtonColumn.dart';
import 'package:flutter_tiktok/views/tikTokVideoPlayer.dart';
import 'package:flutter_tiktok/views/tiktokTabBar.dart';
import 'package:flutter_tiktok/views/tilTokAppBar.dart';
import 'package:safemap/safemap.dart';

/**
 * DESC: 同城视频列表
 * Author：原哥
 * QQ: 2729404527
 * Email: 2729404527@qq.com
 */

class SameCityVideoListPage extends StatefulWidget {
  @override
  _SameCityVideoListPageState createState() => _SameCityVideoListPageState();
}

class _SameCityVideoListPageState extends State<SameCityVideoListPage>
    with WidgetsBindingObserver {
  TikTokPageTag tabBarType = TikTokPageTag.home;

  TikTokScaffoldController tkController = TikTokScaffoldController();

  PageController _pageController = PageController();

  VideoListController _videoListController = VideoListController();

  /// 记录点赞
  Map<int, bool> favoriteMap = {};

  List<UserVideo> videoDataList = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      _videoListController.currentPlayer.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _videoListController.currentPlayer.pause();
    super.dispose();
  }

  @override
  void initState() {
    videoDataList = UserVideo.fetchVideo();
    WidgetsBinding.instance.addObserver(this);
    _videoListController.init(
      _pageController,
      videoDataList,
    );
    tkController.addListener(
      () {
        if (tkController.value == TikTokPagePositon.middle) {
          _videoListController.currentPlayer.start();
        } else {
          _videoListController.currentPlayer.pause();
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    Widget head = TikTokAppbar(
      title: '',
    );
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
            _videoListController.currentPlayer.start();
          } else {
            _videoListController.currentPlayer.pause();
          }
        });
      },
      onAddButton: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => CameraPage(),
          ),
        );
      },
    );

    var searchPage = SearchPage(
      onPop: tkController.animateToMiddle,
    );

    // 组合
    return TikTokScaffold(
      controller: tkController,
      hasBottomPadding: hasBackground,
      tabBar: null,
      header: head,
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
          // Center(
          //   child: Text(_currentIndex.toString()),
          // )
        ],
      ),
    );
  }
}
