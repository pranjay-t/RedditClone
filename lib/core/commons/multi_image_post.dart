import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Theme/pallete.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MultiImagePost extends ConsumerStatefulWidget {
  final List<String> imagesList;
  const MultiImagePost({super.key,required this.imagesList});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MultiImagePostState();
}

class _MultiImagePostState extends ConsumerState<MultiImagePost> {
  int activePage = 0;
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: widget.imagesList.length,
          itemBuilder: (context, index, realIndex) {
            final image = widget.imagesList[index];
            return Container(
              width: double.infinity,
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            );
          },
          options: CarouselOptions(
            height: 300,
            enableInfiniteScroll: false,
            viewportFraction: 1.1,
            enlargeCenterPage: true,
            onPageChanged: (index,reason){
              setState(() {
                activePage = index;
              });
            }
          ),
        ),
      if(widget.imagesList.length != 1)
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedSmoothIndicator(
            activeIndex: activePage,
            count: widget.imagesList.length,
            effect: ExpandingDotsEffect(
              dotWidth: 10,
              dotHeight: 10,
              activeDotColor: theme == ThemeMode.dark
                  ? Pallete.appColorDark
                  : Pallete.appColorLight,
            ),
          ),
        )
      ],
    );
  }
}