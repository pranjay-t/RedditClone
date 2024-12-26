import 'package:flutter/material.dart';
import 'package:reddit_clone/Features/Home/app_bar_widget.dart/home_app_bar.dart';
import 'package:reddit_clone/Features/Home/app_bar_widget.dart/add_post_app_bar.dart';
import 'package:reddit_clone/Features/Home/app_bar_widget.dart/chat_app_bar.dart';
import 'package:reddit_clone/Features/Home/app_bar_widget.dart/notification_app_bar.dart';
import 'package:reddit_clone/Features/chat/chat_screen.dart';
import 'package:reddit_clone/Features/feeds/screens/feed_screen.dart';
import 'package:reddit_clone/Features/notification/notification_screen.dart';
import 'package:reddit_clone/Features/posts/screen/add_post_screen.dart';

class Constants {
  static const logoPath = 'assets/images/logo.png';
  static const loginEmotePath = 'assets/images/loginEmote.png';
  static const googlePath = 'assets/images/google.png';

  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

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

  // TextTheme textFont(BuildContext context){
  //   return GoogleFonts.robotoTextTheme(
  //         Theme.of(context).textTheme,
  //       );
  // }

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