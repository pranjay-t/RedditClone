import 'package:flutter/material.dart';
import 'package:reddit_clone/Features/Community/Screens/add_mod_screen.dart';
import 'package:reddit_clone/Features/Community/Screens/community_screen.dart';
import 'package:reddit_clone/Features/Community/Screens/create_community_screens.dart';
import 'package:reddit_clone/Features/Community/Screens/edit_community_screen.dart';
import 'package:reddit_clone/Features/Community/Screens/mod_tools_screen.dart';
import 'package:reddit_clone/Features/auths/screens/login_screen.dart';
import 'package:reddit_clone/Features/posts/screen/add_post_screen.dart';
import 'package:reddit_clone/Features/posts/screen/add_post_type_screen.dart';
import 'package:reddit_clone/Features/posts/screen/comments_screen.dart';
import 'package:reddit_clone/Home/screens/home_screens.dart';
import 'package:reddit_clone/user_profile/screens/edit_profile.dart';
import 'package:reddit_clone/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {

  '/': (_) => const MaterialPage(child: HomeScreens()),

  '/mod-tools/:name': (routeData) =>  MaterialPage(child: ModToolsScreen(
    name: routeData.pathParameters['name']!,
  )),

  '/edit-community/:name': (routeData) =>  MaterialPage(child: EditCommunityScreen(
    name: routeData.pathParameters['name']!,
  )),

  '/create-community': (_) => const MaterialPage(child: CreateCommunityScreens()),
  
  '/r/:name': (route) => MaterialPage(child: CommunityScreen(name: route.pathParameters['name']!,)),

  '/add-mod/:name': (route) => MaterialPage(child: AddModScreen(name: route.pathParameters['name']!,)),

  '/user-profile/:uid': (route) => MaterialPage(child: UserProfileScreen(uid: route.pathParameters['uid']!,)),

  '/edit-profile/:uid': (route) => MaterialPage(child: EditProfile(uid: route.pathParameters['uid']!,)),

  '/add-post/:type': (route) => MaterialPage(child: AddPostTypeScreen(type: route.pathParameters['type']!,)),

  '/post/:postId/comments': (route) => MaterialPage(child: CommentsScreen(postId: route.pathParameters['postId']!,)),

  '/add-posts': (_) => const MaterialPage(child: AddPostScreen()),

});