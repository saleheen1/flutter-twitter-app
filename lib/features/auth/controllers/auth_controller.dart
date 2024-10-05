import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_app/repositories/auth_repository.dart';
import 'package:flutter_twitter_app/core/routes/app_router.dart';
import 'package:flutter_twitter_app/core/routes/route_names.dart';
import 'package:flutter_twitter_app/core/utils.dart';
import 'package:flutter_twitter_app/models/user_model.dart';
import 'package:flutter_twitter_app/repositories/user_repository.dart';
import 'package:go_router/go_router.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
      authRepositoryImpl: ref.watch(authRepoProvider),
      userRepositoryImpl: ref.watch(userRepoProvider));
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthRepositoryImpl _authRepositoryImpl;
  final UserRepositoryImpl _userRepositoryImpl;
  AuthController({
    required AuthRepositoryImpl authRepositoryImpl,
    required UserRepositoryImpl userRepositoryImpl,
  })  : _authRepositoryImpl = authRepositoryImpl,
        _userRepositoryImpl = userRepositoryImpl,
        super(false);

  Future<model.User?> currentUser() => _authRepositoryImpl.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authRepositoryImpl.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: const [],
          following: const [],
          profilePic: '',
          bannerPic: '',
          uid: r.$id,
          bio: '',
          isTwitterBlue: false,
        );
        final res2 = await _userRepositoryImpl.saveUserData(userModel);

        res2.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Accounted created! Please login.');
          context.push(RouteNames.login);
        });
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authRepositoryImpl.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        context.pushReplacement(RouteNames.home);
      },
    );
  }
}
