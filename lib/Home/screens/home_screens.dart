import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
import 'package:reddit_clone/Home/drawers/community_list_drawer.dart';
import 'package:reddit_clone/Home/drawers/profile_drawer.dart';
import 'package:reddit_clone/Theme/pallete.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/delegates/search_community_delegate.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreens extends ConsumerStatefulWidget {
  const HomeScreens({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreensState();
  }

  class _HomeScreensState extends ConsumerState<HomeScreens>{
  
  void displayMenuDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayProfileDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void navigateToAddPost(BuildContext context){
    Routemaster.of(context).push('/add-posts');
  }
  int _page = 0;

  void pageChange(int page){
    setState(() {
      _page = page;
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => displayMenuDrawer(context),
            icon: const Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
            onPressed: () => showSearch(
                context: context, delegate: SearchCommunityDelegate(ref: ref)),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => navigateToAddPost(context),
            icon:const Icon(Icons.add),
          ),
          Builder(builder: (context) {
            return IconButton(
                onPressed: () => displayProfileDrawer(context),
                icon: CircleAvatar(
                  radius: 17,
                  backgroundImage: NetworkImage(user.profilePic),
                ));
          }),
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer:isGuest ? null : const ProfileDrawer(),
      body: Constants.tabWidgets[_page],
      bottomNavigationBar: isGuest || kIsWeb ? null : CupertinoTabBar(
        backgroundColor:currentTheme.dialogBackgroundColor, 
        activeColor: currentTheme.iconTheme.color,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: ''
          ),
          
        ],
        onTap: pageChange,
        currentIndex: _page,
      ),
    );
  }
  
  }
