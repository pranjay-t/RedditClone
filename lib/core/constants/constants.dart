import 'package:flutter/material.dart';
import 'package:reddit_clone/Features/Home/app_bar_widget.dart/home_app_bar.dart';
import 'package:reddit_clone/Features/Home/app_bar_widget.dart/add_post_app_bar.dart';
import 'package:reddit_clone/Features/Home/app_bar_widget.dart/chat_app_bar.dart';
import 'package:reddit_clone/Features/Home/app_bar_widget.dart/notification_app_bar.dart';
import 'package:reddit_clone/Features/chat/screens/chat_screen.dart';
import 'package:reddit_clone/Features/feeds/screens/feed_screen.dart';
import 'package:reddit_clone/Features/notification/notification_screen.dart';
import 'package:reddit_clone/Features/posts/screen/add_post_screen.dart';

class Constants {
  static const logoPath = 'assets/images/logo.png';
  static const loginEmotePath = 'assets/images/login.png';
  static const googlePath = 'assets/images/google.png';

  static const bannerDefault =
  'https://i.pinimg.com/736x/e2/d4/5c/e2d45c1474a5b514be7d10cd47ed26b4.jpg';
  static const avatarDefault =
  'https://i.pinimg.com/736x/0f/13/19/0f131979792bca37c3437cc7d18f3c32.jpg';

  static const tabWidgets = [
    FeedScreen(),
    AddPostScreen(),
    ChatScreen(),
    NotificationScreen(),
  ];

  static final List<PreferredSizeWidget> appBarWidget = [
    const HomeAppBar(),
    const AddPostAppBar(),
    const ChatAppBar(),
    const NotificationAppBar(),
  ];


  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': '${Constants.awardsPath}/awesomeanswer.png',
    'gold': '${Constants.awardsPath}/gold.png',
    'platinum': '${Constants.awardsPath}/platinum.png',
    'helpful': '${Constants.awardsPath}/helpful.png',
    'plusone': '${Constants.awardsPath}/plusone.png',
    'rocket': '${Constants.awardsPath}/rocket.png',
    'thankyou': '${Constants.awardsPath}/thankyou.png',
    'til': '${Constants.awardsPath}/til.png',
  };
}