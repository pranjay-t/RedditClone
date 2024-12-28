import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reddit_clone/Theme/pallete.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPost extends ConsumerStatefulWidget {
  const VideoPlayerPost({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VideoPlayerPostState();
}

class _VideoPlayerPostState extends ConsumerState<VideoPlayerPost> {
  late VideoPlayerController videoController;
  File? postVideo;
  void selectPostVideo() async {
    try {
      final res = await ImagePicker().pickVideo(source: ImageSource.gallery);

      if (res != null) {
        postVideo = File(res.path);
        videoController = VideoPlayerController.file(postVideo!)
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

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;

    return GestureDetector(
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
                          alignment: AlignmentDirectional.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.contain,
                              child: SizedBox(
                                width: videoController.value.size.width,
                                height: videoController.value.size.height,
                                child: VideoPlayer(videoController),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: videoController.value.isPlaying
                                        ? const Icon(Icons.pause)
                                        : const Icon(Icons.play_arrow),
                                    onPressed: () => switchOnOff(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
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
    );
  }
}
