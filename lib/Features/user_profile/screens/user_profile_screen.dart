import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
import 'package:reddit_clone/Theme/pallete.dart';
import 'package:reddit_clone/core/commons/loader.dart';
import 'package:reddit_clone/core/commons/post_card.dart';
import 'package:reddit_clone/core/constants/error_text.dart';
import 'package:reddit_clone/Features/user_profile/controller/user_profile_controller.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  void navigateToEditProfile(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/${widget.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(widget.uid)).when(
            data: (user) {
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 200,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              user.banner,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10, left: 16),
                              child: OutlinedButton(
                                onPressed: () => navigateToEditProfile(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Pallete.greyColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide.none,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                  ),
                                ),
                                child: const Text(
                                  'Edit Profile',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 70, left: 30),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(user.profilePic),
                                radius: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'u/${user.name}',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('${user.karma} karma'),
                            )
                          ],
                        ),
                      ),
                    )
                  ];
                },
                body: Padding(
                  padding:const EdgeInsets.symmetric(horizontal: 10),
                  child: ref.watch(getUserPostsProvider(user.uid)).when(
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
                          // print(error);
                            return ErrorText(error: error.toString());},
                        loading: () => const Loader(),
                      ),
                ),
              );
            },
            error: (error, stackTrace) {
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
