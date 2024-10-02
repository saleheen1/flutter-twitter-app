import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_app/core/constants/appwrite_constants.dart';
import 'package:flutter_twitter_app/core/routes/app_router.dart';
import 'package:flutter_twitter_app/core/theme/app_theme.dart';
import 'package:flutter_twitter_app/features/auth/views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client()
      .setEndpoint(AppwriteConstants.appwriteUrl)
      .setProject(AppwriteConstants.appwriteProjectId);
  Account account = Account(client);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter twitter app',
      theme: AppTheme.theme,
      routerConfig: AppRouter().routes,
    );
  }
}
