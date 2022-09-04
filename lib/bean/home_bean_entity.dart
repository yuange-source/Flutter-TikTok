import 'package:flutter_tiktok/utils/log_utils.dart';

class HomeBeanEntity {
  String url;
  String image;
  String desc;

  HomeBeanEntity({
    this.url,
    this.image,
    this.desc,
  });

  List<HomeBeanEntity> list;

  HomeBeanEntity.fromJson(Map<String, dynamic> json) {
    List<dynamic> result = json['result'];
    if (result != null) {
      list = new List<HomeBeanEntity>();
        result.forEach((v) {
        url = v['videourl'];
        image = v['city'];
        desc = v['title'];
        list.add(new HomeBeanEntity(url: url, image: image, desc: desc));
      });
    }
  }
}
