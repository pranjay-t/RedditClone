import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/Community/controller/community_controller.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
import 'package:reddit_clone/Features/posts/controller/post_controller.dart';
import 'package:reddit_clone/Theme/pallete.dart';
import 'package:reddit_clone/core/commons/loader.dart';
import 'package:reddit_clone/core/commons/post_card.dart';
import 'package:reddit_clone/core/constants/error_text.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final theme = ref.watch(themeNotifierProvider.notifier).mode;

    if (!isGuest) {
      return ref.watch(userCommunityProvider(user.uid)).when(
          data: (communities) {
            if (communities.isEmpty) {
              return  Center(child: Text('No communities joined.',style: TextStyle(color: theme == ThemeMode.dark ? Pallete.appColorDark:Pallete.appColorLight,fontFamily: 'carter'),));
            }
            return ref.watch(userPostsProvider(communities)).when(
                data: (posts) {
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = posts[index];
                      return PostCard(
                        post: post,
                      );
                    },
                  );
                },
                error: (error, stackTrace) {
                  return ErrorText(error: error.toString());
                },
                loading: () => const Loader());
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader());
    }
    return ref.watch(userCommunityProvider(user.uid)).when(
        data: (communities) {
          return ref.watch(getPostForGuestProvider).when(
              data: (posts) {
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final post = posts[index];
                    return PostCard(
                      post: post,
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                return ErrorText(error: error.toString());
              },
              loading: () => const Loader());
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
