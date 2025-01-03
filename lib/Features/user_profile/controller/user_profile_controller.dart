import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
import 'package:reddit_clone/core/enums/enums.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/user_models.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/Features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_clone/core/constants/utils.dart';
import 'package:routemaster/routemaster.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(cloudinaryStorageProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  final userProfileController =
      ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserPosts(uid);
});



class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _userProfileRepository = userProfileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void editCommunity({
    required List<XFile> profileFile,
    required List<XFile> bannerFile,
    required Uint8List? webProfileFile,
    required Uint8List? webBannerFile,
    required BuildContext context,
    required String? name,
    required UserModels user,
  }) async {
    state = true;
    if (profileFile.isNotEmpty || webProfileFile != null) {
      final res = await _storageRepository.storeFiles(
        path: 'users/profile',
        id: user.uid,
        files: profileFile,
        webFile: webProfileFile,
        isVideo: false, 
      );
      res.fold((l) {
        // print(l.message);
        showSnackBar(context, l.message);
      }, (r) {
        // print('PROFILE URL : $r');
        user = user.copyWith(profilePic: r[0]);
      });
    }
    if (bannerFile.isNotEmpty || webBannerFile != null) {
      final res = await _storageRepository.storeFiles(
        path: 'users/banner',
        id: user.uid,
        files: bannerFile,
        webFile: webBannerFile,
        isVideo: false,
      );
      res.fold((l) => showSnackBar(context, l.message), (r) {
        // print('BANNER URL : $r');
        user = user.copyWith(banner: r[0]);
      });
    }
    if (name != null) {
      user = user.copyWith(name: name);
    }
    final res = await _userProfileRepository.editCommunity(user);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Routemaster.of(context).pop();
      showSnackBar(context, 'Saved sucessfully');
    });
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPosts(uid);
  }

  void updateKarma(UserKarma uKarma) async{
    UserModels user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + uKarma.karma);
    final res = await _userProfileRepository.updateKarma(user);
    res.fold((l) => null, (r)=>_ref.read(userProvider.notifier).update((state) => user));

  }
}
