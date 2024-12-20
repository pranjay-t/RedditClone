import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
import 'package:reddit_clone/Resposive/responsive.dart';
import 'package:reddit_clone/core/commons/loader.dart';
import 'package:reddit_clone/core/commons/sign_in_buttons.dart';
import 'package:reddit_clone/core/constants/constants.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGuest(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInWithGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.logoPath,
          height: 35,
        ),
        centerTitle: true,
        actions: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                  onPressed: () => signInWithGuest(ref, context),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ))),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: isLoading
            ? const Loader()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Dive into Anything !",
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Image.asset(
                    Constants.loginEmotePath,
                    height : 400,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Responsive(child: SignInButtons()),
                ],
              ),
      ),
    );
  }
}
