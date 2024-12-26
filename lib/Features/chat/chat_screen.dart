import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return const Scaffold(
      
      body: Text("Chat Screen",style: TextStyle(),),
    );
  }
}