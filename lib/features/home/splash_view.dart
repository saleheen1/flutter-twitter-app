import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_app/core/common_widgets/error_page.dart';
import 'package:flutter_twitter_app/core/common_widgets/loading_page.dart';
import 'package:flutter_twitter_app/core/routes/route_names.dart';
import 'package:flutter_twitter_app/features/auth/controllers/auth_controller.dart';
import 'package:go_router/go_router.dart';

class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.delayed(Duration.zero, () {
      ref.watch(currentUserAccountProvider).when(
            data: (user) {
              if (user != null) {
                context.pushReplacement(RouteNames.home);
                return;
              }
              context.pushReplacement(RouteNames.signUp);
            },
            error: (error, st) => ErrorPage(
              error: error.toString(),
            ),
            loading: () => const LoadingPage(),
          );
    });

    return const Center(child: CircularProgressIndicator());
  }
}
