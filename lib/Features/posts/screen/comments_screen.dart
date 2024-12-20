import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
import 'package:reddit_clone/Features/posts/Resposive/responsive.dart';
import 'package:reddit_clone/Features/posts/controller/post_controller.dart';
import 'package:reddit_clone/Features/posts/widgets/comment_card.dart';
import 'package:reddit_clone/commons/loader.dart';
import 'package:reddit_clone/commons/post_card.dart';
import 'package:reddit_clone/core/constants/error_text.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(String postId) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          postId: postId,
        );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (post) {
              return Center(
                child: Responsive(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        PostCard(post: post),
                        if (!isGuest)
                          TextField(
                            onSubmitted: (val) => addComment(post.id),
                            controller: commentController,
                            decoration: const InputDecoration(
                              hintText: 'Comment your thoughts!',
                              filled: true,
                              border: InputBorder.none,
                            ),
                          ),
                        ref.watch(getPostCommentProvider(widget.postId)).when(
                              data: (data) {
                                return Expanded(
                                  child: ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final comment = data[index];
                                      return CommentCard(comment: comment);
                                    },
                                  ),
                                );
                              },
                              error: (error, stackTrace) {
                                // print(error);
                                return ErrorText(
                                  error: error.toString(),
                                );
                              },
                              loading: () => const Loader(),
                            ),
                      ],
                    ),
                  ),
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
