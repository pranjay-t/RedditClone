import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/Community/controller/community_controller.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
import 'package:reddit_clone/Resposive/responsive.dart';
import 'package:reddit_clone/Features/posts/controller/post_controller.dart';
import 'package:reddit_clone/Theme/pallete.dart';
import 'package:reddit_clone/core/commons/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/constants/error_text.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  void deletePost(WidgetRef ref, BuildContext context, Post post) async {
    ref.watch(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvote(Post post, WidgetRef ref) async {
    ref.watch(postControllerProvider.notifier).upvote(post);
  }

  void downvote(Post post, WidgetRef ref) async {
    ref.watch(postControllerProvider.notifier).downvote(post);
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) async {
    ref
        .read(postControllerProvider.notifier)
        .awardPost(post: post, award: award, context: context);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/user-profile/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    final currentTheme = ref.watch(themeNotifierProvider);
    final theme = ref.watch(themeNotifierProvider.notifier).mode;

    return Column(
      children: [
        Responsive(
          child: Container(
            decoration: BoxDecoration(
              color: currentTheme.drawerTheme.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              if(kIsWeb)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () => isGuest ? null : upvote(post, ref),
                      icon: Icon(
                        Icons.thumb_up,
                        size: 30,
                        color: post.upvotes.contains(user.uid)
                            ? Pallete.blueColor
                            : null,
                      ),
                    ),
                    Text(
                      '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                      style: const TextStyle(fontSize: 17),
                    ),
                    IconButton(
                      onPressed: () => isGuest ? null : downvote(post, ref),
                      icon: Icon(
                        Icons.thumb_down,
                        size: 30,
                        color: post.downvotes.contains(user.uid)
                            ? Pallete.redColor
                            : null,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => navigateToCommunity(context),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          post.communityProfilePic,
                                        ),
                                        radius: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'r/${post.communityName}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                navigateToUser(context),
                                            child: Text(
                                              'u/${post.username}',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (post.uid == user.uid)
                                  IconButton(
                                    onPressed: () =>
                                        deletePost(ref, context, post),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Pallete.redColor,
                                    ),
                                  ),
                              ],
                            ),
                            if (post.awards.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 25,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: post.awards.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final award = post.awards[index];
                                    return Image.asset(
                                      Constants.awards[award]!,
                                      height: 23,
                                    );
                                  },
                                ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                post.title,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isTypeImage)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: double.infinity,
                                child: Image.network(
                                  post.link!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (isTypeLink)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: (post.link != null &&
                                        post.link!.isNotEmpty &&
                                        Uri.tryParse(post.link!) != null)
                                    ? AnyLinkPreview(
                                        displayDirection:
                                            UIDirection.uiDirectionVertical,
                                        link: post.link!,
                                        errorBody:
                                            'Failed to load link preview.',
                                      )
                                    : const Text('Error loading url'),
                              ),
                            if (isTypeText)
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Text(
                                  post.description!,
                                  style: TextStyle(
                                    fontFamily: 'reddo',
                                    fontWeight: FontWeight.w600,
                                    color: theme == ThemeMode.light
                                        ? Colors.black
                                        : const Color.fromARGB(
                                            255, 211, 208, 208),
                                  ),
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (!kIsWeb)
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            isGuest ? null : upvote(post, ref),
                                        icon: Icon(
                                          // Constants.up,
                                          Icons.thumb_up,
                                          size: 30,
                                          color: post.upvotes.contains(user.uid)
                                              ? Pallete.blueColor
                                              : null,
                                        ),
                                      ),
                                      Text(
                                        '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                      IconButton(
                                        onPressed: () => isGuest
                                            ? null
                                            : downvote(post, ref),
                                        icon: Icon(
                                          // Constants.down,
                                          Icons.thumb_down,
                                          size: 30,
                                          color:
                                              post.downvotes.contains(user.uid)
                                                  ? Pallete.redColor
                                                  : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          navigateToComments(context),
                                      icon: const Icon(
                                        Icons.comment,
                                      ),
                                    ),
                                    Text(
                                      '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                                ref
                                    .watch(communityByNameProvider(
                                        post.communityName))
                                    .when(
                                      data: (community) {
                                        if (community.mods.contains(user.uid)) {
                                          return IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.admin_panel_settings,
                                              size: 28,
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                      error: (error, stackTrace) => ErrorText(
                                        error: error.toString(),
                                      ),
                                      loading: () => const Loader(),
                                    ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: LayoutBuilder(
                                                builder: (BuildContext context,
                                                    BoxConstraints
                                                        constraints) {
                                                  double maxWidth = kIsWeb
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.8; 

                                                  double maxHeight = kIsWeb
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.6 
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.8;
                                                  return ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      maxWidth: maxWidth,
                                                      maxHeight: maxHeight,
                                                    ),
                                                    child: GridView.builder(
                                                      shrinkWrap: true,
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: kIsWeb ? 8 : 4,
                                                      ),
                                                      itemCount:
                                                          user.awards.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        final award =
                                                            user.awards[index];
                                                        return GestureDetector(
                                                          onTap: () => isGuest
                                                              ? null
                                                              : awardPost(
                                                                  ref,
                                                                  award,
                                                                  context),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Image.asset(
                                                                Constants
                                                                        .awards[
                                                                    award]!),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.card_giftcard),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
