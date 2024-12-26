// ignore_for_file: deprecated_member_use

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
import 'package:reddit_clone/Features/Home/drawers/community_list_drawer.dart';
import 'package:reddit_clone/Features/Home/drawers/profile_drawer.dart';
import 'package:reddit_clone/Theme/pallete.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreens extends ConsumerStatefulWidget {
  const HomeScreens({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreensState();
}

class _HomeScreensState extends ConsumerState<HomeScreens> {
  void displayMenuDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayProfileDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void navigateToAddPost(BuildContext context) {
    Routemaster.of(context).push('/add-posts');
  }

  final _pageController = NotchBottomBarController();

  void pageChange(int page) {
    setState(() {
      _pageController.index = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    return Scaffold(
      appBar: Constants.appBarWidget[_pageController.index],
      drawer: const CommunityListDrawer(),
      endDrawer: isGuest ? null : const ProfileDrawer(),
      body: Constants.tabWidgets[_pageController.index],
      bottomNavigationBar: isGuest || kIsWeb
          ? null
          : AnimatedNotchBottomBar(
              notchBottomBarController: _pageController,
              notchColor: theme == ThemeMode.dark
                  ? Pallete.appColorDark
                  : Pallete.appColorLight,
              color: theme == ThemeMode.dark
                  ? const Color.fromARGB(255, 47, 47, 47)
                  :const Color(0XFFe5e5e5),
              showShadow: false,
              bottomBarHeight: 10,
              durationInMilliSeconds: 1,
              itemLabelStyle: TextStyle(
                color: theme == ThemeMode.dark
                    ? Colors.white
                    : const Color.fromARGB(255, 83, 81, 81),
                fontFamily: 'carter',
                fontSize: 12,
              ),
              onTap: pageChange,
              bottomBarItems: [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_outlined,
                    color: theme == ThemeMode.dark
                        ? Colors.white
                        : const Color.fromARGB(255, 83, 81, 81),
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: theme == ThemeMode.dark ? Colors.black : Colors.white,
                  ),
                  itemLabel: 'Home',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.add,
                    color: theme == ThemeMode.dark
                        ? Colors.white
                        : const Color.fromARGB(255, 83, 81, 81),
                  ),
                  activeItem: Icon(
                    Icons.add,
                    color: theme == ThemeMode.dark ? Colors.black : Colors.white,
                  ),
                  itemLabel: 'Create',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.chat_bubble_outline,
                    color: theme == ThemeMode.dark
                        ? Colors.white
                        : const Color.fromARGB(255, 83, 81, 81),
                  ),
                  activeItem: Icon(
                    Icons.chat_bubble,
                    color: theme == ThemeMode.dark ? Colors.black : Colors.white,
                  ),
                  itemLabel: 'Chat',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.notifications_outlined,
                    color: theme == ThemeMode.dark
                        ? Colors.white
                        : const Color.fromARGB(255, 83, 81, 81),
                  ),
                  activeItem: Icon(
                    Icons.notifications,
                    color: theme == ThemeMode.dark ? Colors.black : Colors.white,
                  ),
                  itemLabel: 'Notification',
                ),
              ],
              kIconSize: 20,
              kBottomRadius: 20,
            ),
    );
  }
}
