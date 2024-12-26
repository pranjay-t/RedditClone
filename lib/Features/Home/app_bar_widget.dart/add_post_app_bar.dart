import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Theme/pallete.dart';
import 'package:reddit_clone/core/commons/profile_icon.dart';

class AddPostAppBar extends ConsumerWidget implements PreferredSizeWidget{
  const AddPostAppBar({super.key});

  void displayMenuDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayProfileDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    return AppBar(
        title:  Text('Add Post of ',style: TextStyle(
          color: theme == ThemeMode.dark ? Pallete.appColorDark : Pallete.appColorLight, 
          fontFamily: 'carter',
          fontSize: 20
        ),),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => displayMenuDrawer(context),
            icon:  Icon(Icons.menu,size: 35,color:  (theme == ThemeMode.dark ? Pallete.appColorDark : Pallete.appColorLight),),
          );
        }),
        actions:const [
           ProfileIcon(radius: 35,),
        ],
      );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}