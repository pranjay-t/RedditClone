import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Theme/pallete.dart';
import 'package:reddit_clone/core/commons/profile_icon.dart';
import 'package:reddit_clone/delegates/search_community_delegate.dart';
import 'package:routemaster/routemaster.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});
  
  void displayMenuDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  

  void navigateToAddPost(BuildContext context) {
    Routemaster.of(context).push('/add-posts');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);
    return AppBar(
      title: Text(
        'SoSoulize',
        style: TextStyle(
            color: theme == Pallete.darkModeAppTheme
              ? Pallete.appColorDark 
              : Pallete.appColorLight,
            fontFamily: 'carter',
            fontSize: 30),
      ),
      centerTitle: false,
      leading: Builder(builder: (context) {
        return IconButton(
          onPressed: () => displayMenuDrawer(context),
          icon:const Icon(
            Icons.menu,
            weight: 2,
            size: 35,
          ),
        );
      }),
      actions: [
        IconButton(
          onPressed: () => showSearch(
              context: context, delegate: SearchCommunityDelegate(ref: ref)),
          icon:const Icon(
            Icons.search,
            size: 30,
          ),
        ),
        if (kIsWeb)
          IconButton(
            onPressed: () => navigateToAddPost(context),
            icon: const Icon(Icons.add),
          ),
        const ProfileIcon(radius: 35,),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
