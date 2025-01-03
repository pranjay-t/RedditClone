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
  XFile? postVideo;
  Uint8List? webPostImage;
  late VideoPlayerController videoController;

  void selectPostVideo() async {
    try {
      final res = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (res != null) {
        postVideo = res;
        final video = File(postVideo!.path);
        videoController = VideoPlayerController.file(video)
          ..initialize().then((_) {
            if (mounted) {
              setState(() {});
            }
          });
      } else {
        print('Nobita');
      }
      setState(() {});
    } catch (e) {
      print('Virat: $e');
    }
  }

  @override
  void dispose() {
    videoController.dispose();
    titleController.dispose();
    linkController.dispose();
    descController.dispose();
    super.dispose();
  }

  void switchOnOff() {
    videoController.value.isPlaying
        ? setState(() {
            videoController.pause();
          })
        : setState(() {
            videoController.play();
          });
  }

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
        (postImageList.isNotEmpty || webPostImage != null) &&
        titleController.text.isNotEmpty) {
      ref.watch(postControllerProvider.notifier).shareFilePost(
            context: context,
            title: titleController.text,
            files: postImageList,
            selectedcommunity: selectedCommunity ?? communities[0],
            webFile: webPostImage,
            isVideo: false,
          );
    } else if (widget.type == 'video' &&
        (postVideo != null) &&
        titleController.text.isNotEmpty) {
      ref.watch(postControllerProvider.notifier).shareFilePost(
            context: context,
            title: titleController.text,
            files: [postVideo!],
            selectedcommunity: selectedCommunity ?? communities[0],
            webFile: webPostImage,
            isVideo: true,
          );
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
          link: [linkController.text],
          selectedcommunity: selectedCommunity ?? communities[0]);
    } else {
      showSnackBar(context, 'Pls fill up all the fields!');
    }
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
          : SingleChildScrollView(
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
                    if (isTypeVideo)
                      GestureDetector(
                        onTap: selectPostVideo,
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
                            child: (postVideo != null)
                                ? Container(
                                    clipBehavior: Clip.antiAlias,
                                    height: 350,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: videoController.value.isInitialized
                                        ? Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.contain,
                                                child: SizedBox(
                                                  width: videoController
                                                      .value.size.width,
                                                  height: videoController
                                                      .value.size.height,
                                                  child: VideoPlayer(
                                                      videoController),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                  children: [
                                                    IconButton(
                                                      icon: videoController
                                                              .value.isPlaying
                                                          ? const Icon(
                                                              Icons.pause)
                                                          : const Icon(Icons
                                                              .play_arrow),
                                                      onPressed: () =>
                                                          switchOnOff(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : const Center(
                                            child:
                                                CircularProgressIndicator(),
                                          ),
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.play_circle,
                                      color: theme == ThemeMode.dark
                                          ? Pallete.appColorDark
                                          : Pallete.appColorLight,
                                      size: 50,
                                    ),
                                  ),
                          ),
                        ),
                      ),
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
                      child: Text('Select Community',style: TextStyle(fontFamily: 'carter',fontSize: 17),),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ref.watch(userCommunityProvider(user.uid)).when(
                          data: (data) {
                            if (data.isEmpty) {
                              return const SizedBox();
                            }
                            communities = data;
            
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: theme == ThemeMode.dark
                                      ? Pallete.appColorDark
                                      : Pallete.appColorLight,
                                ),
                              ),
                              child: DropdownButton(
                                underline: const SizedBox(),
                                iconEnabledColor:theme == ThemeMode.dark
                                      ? Pallete.appColorDark
                                      : Pallete.appColorLight,
                                iconSize: 40,
                                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                borderRadius: BorderRadius.circular(10),
                                menuMaxHeight: 250,
                                value: selectedCommunity ?? data[0],
                                items: data
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(e.avatar),
                                              radius: 15,
                                            ),
                                            const SizedBox(width: 10,),
                                            Text(e.name,style:const TextStyle(fontFamily: 'carter'),),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    selectedCommunity = val;
                                  });
                                },
                              ),
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
