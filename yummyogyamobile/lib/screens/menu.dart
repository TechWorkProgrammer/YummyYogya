import 'package:flutter/material.dart';
import 'package:yummyogya_mobile/widgets/left_drawer.dart';
import 'package:yummyogya_mobile/widgets/bottom_nav.dart';
import 'package:yummyogya_mobile/screens/search.dart';

class MyHomePage extends StatefulWidget {
  final String username;

  const MyHomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0; // Indeks tab aktif

  // Fungsi untuk mengatur navigasi saat item ditekan
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0: // Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(username: widget.username),
          ),
        );
        break;
      case 1: // Search
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(username: widget.username),
          ),
        );
        break;
      case 2: // Profile
        // Tambahkan logika navigasi ke ProfilePage
        break;
      case 3: // Article
        // Tambahkan logika navigasi ke ArticlePage
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YummyYogya'),
        backgroundColor: Colors.orange,
      ),
      drawer: LeftDrawer(username: widget.username),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Stack(
              children: [
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          NetworkImage('https://via.placeholder.com/800x400'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: const [
                      Text(
                        'YummyYogya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Hadir membantu wisatawan dan masyarakat lokal menemukan makanan khas Yogyakarta.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Artikel dan Makanan Sections
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
