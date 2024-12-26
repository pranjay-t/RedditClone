import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
import 'package:reddit_clone/Theme/pallete.dart';

class ProfileIcon extends ConsumerWidget {
  final int radius;
  const ProfileIcon({super.key,required this.radius});
  void displayProfileDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    final user = ref.watch(userProvider)!;
    return Builder(builder: (context) {
          return IconButton(
            onPressed: () => displayProfileDrawer(context),
            icon: Container(
              width: radius.toDouble(),
              height: radius.toDouble(),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:  (theme == ThemeMode.dark ? Pallete.appColorDark : Pallete.appColorLight),
                  width: 2,
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(user.profilePic),
                ),
              ),
            ),
          );
        });
  }
}