import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_twitter_app/core/constants/assets_constants.dart';
import 'package:flutter_twitter_app/core/theme/pallete.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    // TweetList(),
    // ExploreView(),
    // NotificationView(),
  ];
}
