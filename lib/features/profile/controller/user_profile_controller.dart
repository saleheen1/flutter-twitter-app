import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_app/core/enums/notification_type_enum.dart';
import 'package:flutter_twitter_app/core/utils.dart';
import 'package:flutter_twitter_app/features/notifications/controller/notification_controller.dart';
import 'package:flutter_twitter_app/models/tweet_model.dart';
import 'package:flutter_twitter_app/models/user_model.dart';
import 'package:flutter_twitter_app/repositories/storage_repository.dart';
import 'package:flutter_twitter_app/repositories/tweet_repository.dart';
import 'package:flutter_twitter_app/repositories/user_repository.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    tweetRepo: ref.watch(tweetRepositoryProvider),
    storageRepo: ref.watch(storageRepoProvider),
    userRepo: ref.watch(userRepoProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier),
  );
});

final getUserTweetsProvider = FutureProvider.family((ref, String uid) async {
  final userProfileController =
      ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserTweets(uid);
});

final getLatestUserProfileDataProvider = StreamProvider((ref) {
  final userRepo = ref.watch(userRepoProvider);
  return userRepo.getLatestUserProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final TweetRepositoryImpl _tweetRepositoryImpl;
  final StorageRepository _storageRepo;
  final UserRepositoryImpl _userRepositoryImpl;
  final NotificationController _notificationController;
  UserProfileController({
    required TweetRepositoryImpl tweetRepo,
    required StorageRepository storageRepo,
    required UserRepositoryImpl userRepo,
    required NotificationController notificationController,
  })  : _tweetRepositoryImpl = tweetRepo,
        _storageRepo = storageRepo,
        _userRepositoryImpl = userRepo,
        _notificationController = notificationController,
        super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {
    final tweets = await _tweetRepositoryImpl.getUserTweets(uid);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    if (bannerFile != null) {
      final bannerUrl = await _storageRepo.uploadImage([bannerFile]);
      userModel = userModel.copyWith(
        bannerPic: bannerUrl[0],
      );
    }

    if (profileFile != null) {
      final profileUrl = await _storageRepo.uploadImage([profileFile]);
      userModel = userModel.copyWith(
        profilePic: profileUrl[0],
      );
    }

    final res = await _userRepositoryImpl.updateUserData(userModel);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.pop(context),
    );
  }

  void followUser({
    required UserModel user,
    required BuildContext context,
    required UserModel currentUser,
  }) async {
    // already following
    if (currentUser.following.contains(user.uid)) {
      user.followers.remove(currentUser.uid);
      currentUser.following.remove(user.uid);
    } else {
      user.followers.add(currentUser.uid);
      currentUser.following.add(user.uid);
    }

    user = user.copyWith(followers: user.followers);
    currentUser = currentUser.copyWith(
      following: currentUser.following,
    );

    final res = await _userRepositoryImpl.followUser(user);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      final res2 = await _userRepositoryImpl.addToFollowing(currentUser);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
        _notificationController.createNotification(
          text: '${currentUser.name} followed you!',
          postId: '',
          notificationType: NotificationType.follow,
          uid: user.uid,
        );
      });
    });
  }
}
