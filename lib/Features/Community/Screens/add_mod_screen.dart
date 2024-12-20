import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/Community/controller/community_controller.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
import 'package:reddit_clone/Resposive/responsive.dart';
import 'package:reddit_clone/core/commons/loader.dart';
import 'package:reddit_clone/core/constants/error_text.dart';

class AddModScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModScreenState();
}

class _AddModScreenState extends ConsumerState<AddModScreen> {
  Set<String> uids = {};

  void addMod(String uid){
    setState(() {
      uids.add(uid);
    });
  }

  void removeMod(String uid){
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods(String communityName,List<String>uids,BuildContext context,WidgetRef ref){
    ref.watch(communityControllerProvider.notifier).addMods(communityName, uids, context);
  }
  
  int ctr = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () => saveMods(widget.name,uids.toList(),context,ref), icon: const Icon(Icons.done)),
        ],
      ),
      body: ref.watch(communityByNameProvider(widget.name)).when(
            data: (community) {
              if(ctr == 0 ) {
                uids = community.mods.toSet();
              }
              ctr++;
              return Center(
                child: Responsive(
                  child: ListView.builder(
                    itemCount: community.members.length,
                    itemBuilder: (BuildContext context, int index) {
                      final member = community.members[index];
                      return ref.read(getUserDataProvider(member)).when(
                            data: (user) {
                              return CheckboxListTile(
                                value: uids.contains(member),
                                onChanged: (val) {
                                  if(val!){
                                    addMod(member);
                                  }
                                  else {
                                    removeMod(member);
                                  }
                                },
                                title: Text(user.name),
                              );
                            },
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          );
                    },
                  ),
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
