import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/Community/controller/community_controller.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
import 'package:reddit_clone/Theme/pallete.dart';
import 'package:reddit_clone/core/commons/loader.dart';
import 'package:reddit_clone/core/commons/post_card.dart';
import 'package:reddit_clone/core/constants/error_text.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name/');
  }

  void joinCommunity(
      CommunityModel community, BuildContext context, WidgetRef ref) {
    ref
        .watch(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final theme = ref.watch(themeNotifierProvider.notifier).mode;

    final uid = user.uid;
    const desc = 'fhoshofwihf0wh0h0whf0h0wh0';
    return Scaffold(
      body: ref.watch(communityByNameProvider(name)).when(
            data: (community) {
              return Center(
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            size: 30,
                            color: theme == ThemeMode.dark
                                ? Pallete.appColorDark
                                : Pallete.appColorLight,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        expandedHeight: 150,
                        floating: true,
                        snap: true,
                        flexibleSpace: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                community.banner,
                                fit: BoxFit.cover,
                              ),
                            )
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              FittedBox(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: (theme == ThemeMode.dark
                                                    ? Pallete.appColorDark
                                                    : Pallete.appColorLight),
                                                width: 3,
                                              ),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image:NetworkImage(community.avatar),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'r/${community.name}',
                                              style: const TextStyle(
                                                fontSize: 19,
                                                fontFamily: 'carter',
                                              ),
                                            ),
                                            Text(
                                                '${community.members.length} members',
                                                style:const TextStyle(fontFamily: 'carter',fontSize: 13),
                                                ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 15,),
                                    if (!isGuest)
                                      community.mods.contains(uid)
                                          ? OutlinedButton(
                                              onPressed: () =>
                                                  navigateToModTools(context),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:theme == ThemeMode.dark ? Pallete.appColorDark : Pallete.appColorLight,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  side: BorderSide.none,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                ),
                                              ),
                                              child:  Text(
                                                'Mod Tools',
                                                style: TextStyle(fontSize: 13,fontFamily: 'carter',color: theme == ThemeMode.dark ? Colors.black:Colors.white,),
                                              ),
                                            )
                                          : OutlinedButton(
                                              onPressed: () => joinCommunity(
                                                  community, context, ref),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:theme == ThemeMode.dark ? Pallete.appColorDark : Pallete.appColorLight,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  side: BorderSide.none,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14),
                                              ),
                                              child: Text(
                                                community.members.contains(uid)
                                                    ? 'Joined'
                                                    : 'Join',
                                                style:
                                                     TextStyle(fontSize: 13,fontFamily: 'carter',color: theme == ThemeMode.dark ? Colors.black:Colors.white,),
                                              ),
                                            )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                desc,
                                style: TextStyle(fontSize: 12,fontFamily: 'carter'),
                              ),
                            ],
                          ),
                        ),
                      )
                    ];
                  },
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ref
                        .watch(getUserCommunityPostProvider(community.name))
                        .when(
                          data: (posts) {
                            return ListView.builder(
                              padding: const EdgeInsets.all(0),
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
                            return ErrorText(
                              error: error.toString(),
                            );
                          },
                          loading: () => const Loader(),
                        ),
                  ),
                ),
              );
            },
            error: (error, stackTrace) {
              // print('pranjay : $stackTrace');
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
