import 'package:flutter/material.dart';
import 'package:flutter_twitter_app/core/routes/route_names.dart';
import 'package:flutter_twitter_app/features/auth/views/login_view.dart';
import 'package:flutter_twitter_app/features/auth/views/signup_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  GoRouter routes = GoRouter(
      errorPageBuilder: (context, state) => _errorPage(state),
      routes: [
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
