import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Theme/pallete.dart';
import 'package:reddit_clone/core/commons/profile_icon.dart';

class ChatAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  void displayMenuDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);
    return AppBar(
      title: Text(
        'Chats ',
        style: TextStyle(
          fontFamily: 'carter',
          color: theme == Pallete.darkModeAppTheme
              ? Pallete.appColorDark 
              : Pallete.appColorLight,
        ),
      ),
      centerTitle: false,
      leading: Builder(builder: (context) {
        return IconButton(
          onPressed: () => displayMenuDrawer(context),
          icon: Icon(
            Icons.menu,
            size: 35,
            color: theme == Pallete.darkModeAppTheme
                ? Pallete.appColorDark
                : Pallete.appColorLight,
          ),
        );
      }),
      actions: const [
        ProfileIcon(
          radius: 35,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
