import 'package:flutter/material.dart';
import 'package:yummyogya_mobile/dashboard/screens/dashboard_screen.dart';
import 'package:yummyogya_mobile/screens/article.dart';
import 'package:yummyogya_mobile/screens/base.dart';
import 'package:yummyogya_mobile/screens/login.dart';
import 'package:yummyogya_mobile/screens/menu.dart';
import 'package:yummyogya_mobile/screens/profile.dart';
import 'package:yummyogya_mobile/screens/search.dart';
import 'package:yummyogya_mobile/utils/auth.dart';
import 'package:yummyogya_mobile/wishlist/screens/wishlist_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _isUserLoggedIn() async {
    final user = await Auth.getUser();
    return user != null &&
        user.containsKey('username') &&
        user['username'] != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yummyogya',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ).copyWith(secondary: Colors.deepPurple[400]),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data == true) {
            return const BasePage();
          } else {
            return const LoginPage();
          }
        },
      ),
      routes: {
        '/menu': (context) => const MyHomePage(),
        '/search': (context) => const SearchPage(),
        '/wishlist': (context) => const WishlistScreen(),
        '/article': (context) => const ArticleEntryPage(),
        '/dashboard': (context) => DashboardScreen(username: 'User'),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
