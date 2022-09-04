import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dimens.dart';
import 'colors.dart';
class SysSize {
  static const double avatar = 56;
  // static const double iconBig = 40;
  static const double iconNormal = 24;
  // static const double big = 18;
  // static const double normal = 16;
  // static const double small = 12;
  static const double iconBig = 40;
  static const double big = 16;
  static const double normal = 14;
  static const double small = 12;
}

class StandardTextStyle {
  static const TextStyle big = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: SysSize.big,
    inherit: true,
  );
  static const TextStyle bigWithOpacity = const TextStyle(
    color: const Color.fromRGBO(0xff, 0xff, 0xff, .66),
    fontWeight: FontWeight.w600,
    fontSize: SysSize.big,
    inherit: true,
  );
  static const TextStyle normalW = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: SysSize.normal,
    inherit: true,
  );
  static const TextStyle normal = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: SysSize.normal,
    inherit: true,
  );
  static const TextStyle normalWithOpacity = const TextStyle(
    color: const Color.fromRGBO(0xff, 0xff, 0xff, .66),
    fontWeight: FontWeight.normal,
    fontSize: SysSize.normal,
    inherit: true,
  );
  static const TextStyle small = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: SysSize.small,
    inherit: true,
  );
  static const TextStyle smallWithOpacity = const TextStyle(
    color: const Color.fromRGBO(0xff, 0xff, 0xff, .66),
    fontWeight: FontWeight.normal,
    fontSize: SysSize.small,
    inherit: true,
  );
}

class ColorPlate {
  // 配色
  static const Color orange = const Color(0xffFFC459);
  static const Color yellow = const Color(0xffF1E300);
  static const Color green = const Color(0xff7ED321);
  static const Color red = const Color(0xffEB3838);
  static const Color darkGray = const Color(0xff4A4A4A);
  static const Color gray = const Color(0xff9b9b9b);
  static const Color lightGray = const Color(0xfff5f5f4);
  static const Color black = const Color(0xff000000);
  static const Color white = const Color(0xffffffff);
  static const Color clear = const Color(0);

  /// 深色背景
  static const Color back1 = const Color(0xff1D1F22);

  /// 比深色背景略深一点
  static const Color back2 = const Color(0xff121314);
}


class MTextStyles {
  static const TextStyle textMain12 = const TextStyle(
    fontSize: Dimens.font_sp12,
    color: MColors.app_main,
  );
  static const TextStyle textMain14 = const TextStyle(
    fontSize: Dimens.font_sp14,
    color: MColors.app_main,
  );
  static const TextStyle textNormal12 = const TextStyle(
    fontSize: Dimens.font_sp12,
    color: MColors.text_normal,
  );
  static const TextStyle textDark12 = const TextStyle(
    fontSize: Dimens.font_sp12,
    color: MColors.text_dark,
  );

  static const TextStyle textWhiteDD12 = const TextStyle(
    fontSize: Dimens.font_sp12,
    color: MColors.white_dd,
  );

  static const TextStyle textWhite12 = const TextStyle(
    fontSize: Dimens.font_sp12,
    color: MColors.white,
  );

  static const TextStyle textWhite14 = const TextStyle(
    fontSize: Dimens.font_sp14,
    color: MColors.white,
  );

  static const TextStyle textBoldWhite14 = const TextStyle(
      fontSize: Dimens.font_sp14,
      color: MColors.white,
      fontWeight: FontWeight.bold
  );


  static const TextStyle textDark14 = const TextStyle(
    fontSize: Dimens.font_sp14,
    color: MColors.text_dark,
  );

  static const TextStyle textWhiteDD14 = const TextStyle(
    fontSize: Dimens.font_sp14,
    color: MColors.white_dd,
  );

  static const TextStyle textBoldDD14 = const TextStyle(
      fontSize: Dimens.font_sp14,
      color: MColors.white_dd,
      fontWeight: FontWeight.bold
  );

  static const TextStyle textBoldWhite16 = const TextStyle(
      fontSize: Dimens.font_sp16,
      color: MColors.white,
      fontWeight: FontWeight.bold
  );

  static const TextStyle textDark16 = const TextStyle(
    fontSize: Dimens.font_sp16,
    color: MColors.text_dark,
  );
  static const TextStyle textBoldDark14 = const TextStyle(
      fontSize: Dimens.font_sp14,
      color: MColors.text_dark,
      fontWeight: FontWeight.bold
  );

  static const TextStyle textBoldDark12 = const TextStyle(
      fontSize: Dimens.font_sp12,
      color: MColors.text_dark,
      fontWeight: FontWeight.bold
  );
  static const TextStyle textBoldDark16 = const TextStyle(
      fontSize: Dimens.font_sp16,
      color: MColors.text_dark,
      fontWeight: FontWeight.bold
  );
  static const TextStyle textBoldDark18 = const TextStyle(
      fontSize: Dimens.font_sp18,
      color: MColors.text_dark,
      fontWeight: FontWeight.bold
  );
  static const TextStyle textBoldDark24 = const TextStyle(
      fontSize: 24.0,
      color: MColors.text_dark,
      fontWeight: FontWeight.bold
  );

  static const TextStyle textBoldDark20 = const TextStyle(
      fontSize: 20.0,
      color: MColors.text_dark,
      fontWeight: FontWeight.bold
  );

  static const TextStyle textBoldDark26 = const TextStyle(
      fontSize: 26.0,
      color: MColors.text_dark,
      fontWeight: FontWeight.bold
  );
  static const TextStyle textGray10 = const TextStyle(
    fontSize: Dimens.font_sp10,
    color: MColors.text_gray,
  );
  static const TextStyle textGray12 = const TextStyle(
    fontSize: Dimens.font_sp12,
    color: MColors.text_gray,
  );
  static const TextStyle textGray14 = const TextStyle(
    fontSize: Dimens.font_sp14,
    color: MColors.text_gray,
  );
  static const TextStyle textGray16 = const TextStyle(
    fontSize: Dimens.font_sp16,
    color: MColors.text_gray,
  );
}

