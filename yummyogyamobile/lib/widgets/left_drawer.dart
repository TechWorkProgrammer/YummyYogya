import 'package:flutter/material.dart';
import 'package:yummyogya_mobile/components/menu_item.dart';
import 'package:yummyogya_mobile/components/profile_avatar.dart';
import 'package:yummyogya_mobile/dashboard/screens/dashboard_screen.dart';
import 'package:yummyogya_mobile/screens/base.dart';
import 'package:yummyogya_mobile/screens/login.dart';
import 'package:yummyogya_mobile/utils/auth.dart';
import 'package:yummyogya_mobile/utils/variable.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key});

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  String username = 'Pengguna';
  String? profilePhoto;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await Auth.getUser();
    if (userData != null && mounted) {
      setState(() {
        username = userData['username'] ?? 'Pengguna';
        profilePhoto = userData['profile']?['profile_photo'];
      });
    }
  }

  Future<void> _logout() async {
    await Auth.deleteUser();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anda telah logout')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 20.0),
            decoration: const BoxDecoration(
              color: Color(0xFFEA580C),
            ),
            child: Row(
              children: [
                ProfileAvatar(profilePhoto: '$baseUrl/$profilePhoto'),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat Datang, $username!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      const Text(
                        'Jelajahi fitur aplikasi.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                MenuItem(
                  icon: Icons.home,
                  text: 'Kembali ke Homepage',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BasePage(),
                      ),
                    );
                  },
                ),
                MenuItem(
                  icon: Icons.search,
                  text: 'Cari Makanan',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BasePage(initialIndex: 1,),
                      ),
                    );
                  },
                ),
                MenuItem(
                  icon: Icons.dashboard,
                  text: 'Dashboard',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DashboardScreen(username: username),
                      ),
                    );
                  },
                ),
                MenuItem(
                  icon: Icons.favorite,
                  text: 'Wishlist',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BasePage(initialIndex: 2,),
                      ),
                    );
                  },
                ),
                const Divider(),
                MenuItem(
                  icon: Icons.edit,
                  text: 'Edit Profil',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BasePage(initialIndex: 3,),
                      ),
                    );
                  },
                ),
                MenuItem(
                  icon: Icons.logout,
                  text: 'Logout',
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
