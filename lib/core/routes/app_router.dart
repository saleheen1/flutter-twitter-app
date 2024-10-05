import 'package:flutter/material.dart';
import 'package:flutter_twitter_app/core/routes/route_names.dart';
import 'package:flutter_twitter_app/features/auth/views/login_view.dart';
import 'package:flutter_twitter_app/features/auth/views/signup_view.dart';
import 'package:flutter_twitter_app/features/home/home_view.dart';
import 'package:flutter_twitter_app/features/home/splash_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter routes = GoRouter(
      errorPageBuilder: (context, state) => _errorPage(state),
      routes: [
        GoRoute(
          path: RouteNames.splash,
          name: RouteNames.splash,
          builder: (context, state) => const SplashView(),
        ),
        GoRoute(
          path: RouteNames.login,
          name: RouteNames.login,
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          path: RouteNames.signUp,
          name: RouteNames.signUp,
          builder: (context, state) => const SignUpView(),
        ),
        GoRoute(
          path: RouteNames.home,
          name: RouteNames.home,
          builder: (context, state) => const HomeView(),
        ),
      ]);
}

MaterialPage<dynamic> _errorPage(GoRouterState state) {
  return MaterialPage(
    key: state.pageKey,
    child: _errorPageContent(state),
  );
}

Scaffold _errorPageContent(GoRouterState state) {
  return Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(child: Text(state.error.toString())),
  );
}
