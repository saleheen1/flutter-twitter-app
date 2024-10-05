import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_app/apis/auth_api.dart';
import 'package:flutter_twitter_app/core/routes/app_router.dart';
import 'package:flutter_twitter_app/core/routes/route_names.dart';
import 'package:flutter_twitter_app/core/utils.dart';
import 'package:flutter_twitter_app/models/user_model.dart';
import 'package:go_router/go_router.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
  );
});

class AuthController extends StateNotifier<bool> {
  final AuthApi _authAPI;
  AuthController({
    required AuthApi authAPI,
  })  : _authAPI = authAPI,
        super(false);
  // state = isLoading

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        showSnackBar(context, 'Accounted created! Please login.');
        context.push(RouteNames.login);
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
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
