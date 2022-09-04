import 'dart:io';

Socket socket;
const mockImage =
    'https://v-cdn.zjol.com.cn/280443.mp4';
const mockVideo =
    'https://v-cdn.zjol.com.cn/276982.mp4';
const mV2 =
    'https://v-cdn.zjol.com.cn/276984.mp4';
const mV3 =
    'https://v-cdn.zjol.com.cn/276985.mp4';
const mV4 =
    'https://media.w3.org/2010/05/sintel/trailer.mp4';

const mV5 =
    'http://vfx.mtime.cn/Video/2019/03/19/mp4/190319222227698228.mp4';
class UserVideo {
  final String url;
  final String image;
  final String desc;

  UserVideo({
    this.url: mockVideo,
    this.image: mockImage,
    this.desc,
  });

  static UserVideo get test =>
      UserVideo(image: '', url: mV2, desc: 'MV_TEST_2');

  static List<UserVideo> fetchVideo() {
    List<UserVideo> list = [];
    list.add(UserVideo(image: '', url: mockVideo, desc: '张三'));
    list.add(UserVideo(image: '', url: mV2, desc: 'MV_TEST_2'));
    list.add(UserVideo(image: '', url: mV3, desc: 'MV_TEST_3'));
    list.add(UserVideo(image: '', url: mV4, desc: 'MV_TEST_4'));
    list.add(UserVideo(image: '', url: mV5, desc: 'MV_TEST_5'));
    return list;
  }

  @override
  String toString() {
    return 'image:$image' '\nvideo:$url';
  }
}
