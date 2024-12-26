import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';



class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context,String type){
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardSize = kIsWeb ? 360 : 120;
    double iconSize = kIsWeb ? 90 : 50;
    return Scaffold(
     
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => navigateToType(context,'image'),
            child: SizedBox(
              height: cardSize,
              width: cardSize,
              child: Card(
                child: Icon(Icons.image_outlined,size: iconSize,),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => navigateToType(context,'link'),
            child: SizedBox(
              height: cardSize,
              width: cardSize,
              child: Card(
                child: Icon(Icons.link,size: iconSize,),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => navigateToType(context,'text'),
            child: SizedBox(
              height: cardSize,
              width: cardSize,
              child: Card(
                child: Icon(Icons.text_format,size: iconSize,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}