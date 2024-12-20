import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/posts/Resposive/responsive.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends ConsumerWidget {
  final String name;
  const ModToolsScreen({super.key,required this.name});

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name/');
  }

  void navigateToAddMod(BuildContext context) {
    Routemaster.of(context).push('/add-mod/$name/');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Mod Tools'),
      ),
      body: Center(
        child: Responsive(
          child: Column(
                children: [
                  ListTile(
                    onTap: () => navigateToAddMod(context),
                    title:const Text('Add Moderator'),
                    leading:const Icon(Icons.add),
                  ),
                  ListTile(
                    onTap: () => navigateToEditCommunity(context),
                    title:const Text('Edit Community'),
                    leading: const Icon(Icons.edit),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}