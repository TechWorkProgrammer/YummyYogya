import 'package:flutter/material.dart';
import 'package:yummyogya_mobile/screens/login.dart';
import 'package:yummyogya_mobile/screens/menu.dart';
import 'package:yummyogya_mobile/screens/search.dart';
import 'package:yummyogya_mobile/utils/auth.dart';

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
            return const MyHomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
      routes: {
        '/menu': (context) => const MyHomePage(),
        '/search': (context) => const SearchPage(
              username: 'User',
            ),
      },
    );
  }
}
