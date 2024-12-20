import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/Community/controller/community_controller.dart';
import 'package:reddit_clone/Resposive/responsive.dart';
import 'package:reddit_clone/core/commons/loader.dart';

class CreateCommunityScreens extends ConsumerStatefulWidget {
  const CreateCommunityScreens({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreensState();
}

class _CreateCommunityScreensState
    extends ConsumerState<CreateCommunityScreens> {

  final communityNameController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity(){
    ref.watch(communityControllerProvider.notifier).createCommunity(communityNameController.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a community'),
      ),
      body: Center(
        child: Responsive(
          child: Container(
            margin: const EdgeInsets.all(10),
            child:isLoading ? const Loader() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Community name'),
                const SizedBox(
                  height: 15,
                ),
                 TextField(
                  controller: communityNameController,
                  maxLength: 20,
                  decoration:const InputDecoration(
                    hintText: 'r/Commmunity_name',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: createCommunity,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize:const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                    child: const Text(
                      "Create Community",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
