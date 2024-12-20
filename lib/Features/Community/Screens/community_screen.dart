import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/Community/controller/community_controller.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
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
    final uid = user.uid;
    return Scaffold(
      body: ref.watch(communityByNameProvider(name)).when(
            data: (community) {
              return Center(
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
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
                              Align(
                                alignment: Alignment.topLeft,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(community.avatar),
                                  radius: 40,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'r/${community.name}',
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                if(!isGuest)
                                  community.mods.contains(uid)
                                      ? OutlinedButton(
                                          onPressed: () =>
                                              navigateToModTools(context),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              side: BorderSide.none,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                          ),
                                          child: const Text('Mod Tools'),
                                        )
                                      : OutlinedButton(
                                          onPressed: () => joinCommunity(
                                              community, context, ref),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              side: BorderSide.none,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                          ),
                                          child: Text(
                                              community.members.contains(uid)
                                                  ? 'Joined'
                                                  : 'Join'),
                                        )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child:
                                    Text('${community.members.length} members'),
                              )
                            ],
                          ),
                        ),
                      )
                    ];
                  },
                  body: Padding(
                    padding:const EdgeInsets.symmetric(horizontal: 10),
                    child: ref
                        .watch(getUserCommunityPostProvider(community.name))
                        .when(
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
                            print(error);
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
