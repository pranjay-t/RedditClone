import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/Community/controller/community_controller.dart';
import 'package:reddit_clone/Features/posts/Resposive/responsive.dart';
import 'package:reddit_clone/Theme/pallete.dart';
import 'package:reddit_clone/commons/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/constants/error_text.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/utils.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;
  Uint8List? webBannerFile;
  Uint8List? webProfileFile;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      if (kIsWeb) {
        setState(() {
          webBannerFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      if (kIsWeb) {
        setState(() {
          webProfileFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }
    }
  }

  void saveFile(CommunityModel community) {
    ref.watch(communityControllerProvider.notifier).editCommunity(
        profileFile: profileFile,
        bannerFile: bannerFile,
        webBannerFile: webBannerFile,
        webProfileFile: webProfileFile,
        context: context,
        community: community,
        );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(communityByNameProvider(widget.name)).when(
          data: (community) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Edit Community'),
                actions: [
                  TextButton(
                    onPressed: () => saveFile(community),
                    child: const Text('save'),
                  ),
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
                              SizedBox(
                                height: 250,
                                child: Stack(children: [
                                  GestureDetector(
                                    onTap: selectBannerImage,
                                    child: DottedBorder(
                                      radius: const Radius.circular(15),
                                      borderType: BorderType.RRect,
                                      dashPattern: const [10, 4],
                                      strokeCap: StrokeCap.round,
                                      color: currentTheme
                                          .textTheme.bodyMedium!.color!,
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        height: 200,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: webBannerFile != null
                                            ? Image.memory(webBannerFile!)
                                            : bannerFile != null
                                                ? Image.file(bannerFile!,
                                                    fit: BoxFit.cover)
                                                : community.banner.isEmpty ||
                                                        community.banner ==
                                                            Constants
                                                                .bannerDefault
                                                    ? const Center(
                                                        child: Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          size: 50,
                                                        ),
                                                      )
                                                    : Image.network(
                                                        community.banner,
                                                        fit: BoxFit.cover,
                                                      ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 17,
                                    left: 20,
                                    child: GestureDetector(
                                      onTap: selectProfileImage,
                                      child: webProfileFile != null
                                          ? CircleAvatar(
                                            radius: 33,
                                            backgroundImage: MemoryImage(webProfileFile!),
                                            )
                                          : profileFile != null
                                              ? CircleAvatar(
                                                  radius: 33,
                                                  backgroundImage:
                                                      FileImage(profileFile!),
                                                )
                                              : CircleAvatar(
                                                  radius: 33,
                                                  backgroundImage: NetworkImage(
                                                      community.avatar),
                                                ),
                                    ),
                                  )
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}