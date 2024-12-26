import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
import 'package:reddit_clone/Features/posts/controller/post_controller.dart';
import 'package:reddit_clone/Theme/pallete.dart';
import 'package:reddit_clone/models/post_model.dart';

class HomeShowModalDialog extends ConsumerWidget {
  final Post post;
  const HomeShowModalDialog({super.key,required this.post});
  
  void deletePost(WidgetRef ref, BuildContext context, Post post) async {
    ref.watch(postControllerProvider.notifier).deletePost(post, context);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    final user = ref.watch(userProvider)!;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: theme == ThemeMode.dark
              ? Pallete.appColorDark
              : Pallete.appColorLight,
          context: context,
          builder: (BuildContext context) {
            return Wrap(
              children: [
                if (post.uid == user.uid)
                  ListTile(
                    leading: IconButton(
                      onPressed: () {
                        deletePost(ref, context, post);
                        Navigator.pop(context);
                      },
                      icon: theme == ThemeMode.dark
                          ? Icon(
                              Icons.delete,
                              color: Pallete.redColor,
                            )
                          : const Icon(
                              Icons.delete_outlined,
                              color: Colors.white,
                            ),
                    ),
                    title: Text(
                      'Delete',
                      style: TextStyle(
                        fontFamily: 'carter',
                        color: (theme == ThemeMode.dark
                            ? Colors.black
                            : Colors.white),
                      ),
                    ),
                    onTap: () {
                      deletePost(ref, context, post);
                      Navigator.pop(context);
                    },
                  ),
                ListTile(
                  leading: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bookmark_outline,
                      color: (theme == ThemeMode.dark
                          ? Colors.black
                          : Colors.white),
                    ),
                  ),
                  title: Text(
                    'save',
                    style: TextStyle(
                      fontFamily: 'carter',
                      color:
                          theme == ThemeMode.dark ? Colors.black : Colors.white,
                    ),
                  ),
                  onTap: () {},
                )
              ],
            );
          },
        );
      },
      child: const Icon(Icons.more_vert),
    );
  }
}
