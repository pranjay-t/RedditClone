import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reddit_clone/Features/Community/controller/community_controller.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
import 'package:reddit_clone/Resposive/responsive.dart';
import 'package:reddit_clone/Features/posts/controller/post_controller.dart';
import 'package:reddit_clone/Theme/pallete.dart';
import 'package:reddit_clone/core/commons/loader.dart';
import 'package:reddit_clone/core/constants/carousel_post.dart';
import 'package:reddit_clone/core/constants/error_text.dart';
import 'package:reddit_clone/core/constants/video_player_post.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/core/constants/utils.dart';
import 'package:video_player/video_player.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  List<CommunityModel> communities = [];
  CommunityModel? selectedCommunity;
  List<XFile> postImageList = [];
  File? postImage;
  
  Uint8List? webPostImage;

  void selectPostImage() async {
    final res = await ImagePicker().pickMultiImage();
    if (res.isNotEmpty) {
      // if (kIsWeb) {
      //   setState(() {
      //     webPostImage = res.files.first.bytes;
      //   });
      // }
      setState(() {
        postImageList.addAll(res);
      });
    }
  }

  

  void sharePost(BuildContext context) {
    if (widget.type == 'image' &&
        (postImage != null || webPostImage != null) &&
        titleController.text.isNotEmpty) {
      ref.watch(postControllerProvider.notifier).shareImagePost(
          context: context,
          title: titleController.text,
          file: postImage,
          selectedcommunity: selectedCommunity ?? communities[0],
          webFile: webPostImage);
    } else if (widget.type == 'text' &&
        titleController.text.isNotEmpty &&
        descController.text.isNotEmpty) {
      ref.watch(postControllerProvider.notifier).shareTextPost(
          context: context,
          title: titleController.text,
          description: descController.text,
          selectedcommunity: selectedCommunity ?? communities[0]);
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.watch(postControllerProvider.notifier).shareLinkPost(
          context: context,
          title: titleController.text,
          link: linkController.text,
          selectedcommunity: selectedCommunity ?? communities[0]);
    } else {
      showSnackBar(context, 'Pls fill up all the fields!');
    }
  }
  @override
  void dispose() {
    titleController.dispose();
    linkController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeVideo = widget.type == 'video';
    final isTypetext = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final isLoading = ref.watch(postControllerProvider);
    final user = ref.watch(userProvider)!;
    final theme = ref.watch(themeNotifierProvider.notifier).mode;

    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          'Post ${widget.type}',
          style: TextStyle(
            fontFamily: 'carter',
            color: theme == ThemeMode.dark
                ? Pallete.appColorDark
                : Pallete.appColorLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => sharePost(context),
            child: Text(
              'share',
              style: TextStyle(
                fontFamily: 'carter',
                color: theme == ThemeMode.dark
                    ? Pallete.appColorDark
                    : Pallete.appColorLight,
              ),
            ),
          )
        ],
      ),
      body: isLoading
          ? const Loader()
          : Center(
              child: Responsive(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextField(
                        controller: titleController,
                        maxLength: 30,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Enter a Title',
                          hintStyle: const TextStyle(
                            fontFamily: 'carter',
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: theme == ThemeMode.dark
                                    ? Pallete.appColorDark
                                    : Pallete.appColorLight,
                              )),
                          contentPadding: const EdgeInsets.all(18),
                        ),
                      ),
                      if (isTypeImage)
                        GestureDetector(
                          onTap: selectPostImage,
                          child: DottedBorder(
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                            color: theme == ThemeMode.dark
                                ? Pallete.appColorDark
                                : Pallete.appColorLight,
                            child: Container(
                                clipBehavior: Clip.antiAlias,
                                height: 300,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: webPostImage != null
                                    ? Image.memory(webPostImage!)
                                    : postImageList.isNotEmpty
                                        // ? Image.file(postImage!,
                                        //     fit: BoxFit.cover)
                                        ? CarouselPost(
                                            postImageList: postImageList)
                                        : Center(
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              color: theme == ThemeMode.dark
                                                  ? Pallete.appColorDark
                                                  : Pallete.appColorLight,
                                              size: 50,
                                            ),
                                          )),
                          ),
                        ),
                      if(isTypeVideo)
                        const VideoPlayerPost(),
                      if (isTypetext)
                        TextField(
                          controller: descController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Enter description here',
                            hintStyle: const TextStyle(
                              fontFamily: 'carter',
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: theme == ThemeMode.dark
                                    ? Pallete.appColorDark
                                    : Pallete.appColorLight,
                              ),
                            ),
                          ),
                        ),
                      if (isTypeLink)
                        TextField(
                          controller: linkController,
                          maxLength: 30,
                          decoration: InputDecoration(
                            filled: true,
                            hintStyle: const TextStyle(
                              fontFamily: 'carter',
                            ),
                            hintText: 'Enter link here',
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: theme == ThemeMode.dark
                                    ? Pallete.appColorDark
                                    : Pallete.appColorLight,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text('Select Community'),
                      ),
                      ref.watch(userCommunityProvider(user.uid)).when(
                            data: (data) {
                              if (data.isEmpty) {
                                return const SizedBox();
                              }
                              communities = data;

                              return DropdownButton(
                                menuMaxHeight: 250,
                                value: selectedCommunity ?? data[0],
                                items: data
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    selectedCommunity = val;
                                  });
                                },
                              );
                            },
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
