import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reddit_clone/Theme/pallete.dart';

class Loader extends ConsumerStatefulWidget {
  final bool toShow;
  const Loader({super.key, this.toShow = true});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoaderState();
}

class _LoaderState extends ConsumerState<Loader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 5), // Set longer duration for slower rotation
    )..repeat(); // Repeat the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    return widget.toShow 
    ? Center(
      child: SpinKitSpinningCircle(
        controller: _controller,
        size: 70.0,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme == ThemeMode.dark
                    ? Pallete.appColorDark
                    : Pallete.appColorLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SizedBox(
                  width: 35.0, // Adjust the width for the desired image size
                  height: 35.0, // Adjust the height for the desired image size
                  child: Image.asset(
                    theme == ThemeMode.dark
                    ?'assets/images/app_logo_black.png'
                    :'assets/images/app_logo_white.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    )
    : const SizedBox();
  }
}
