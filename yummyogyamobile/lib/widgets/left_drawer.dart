import 'package:flutter/material.dart';
import 'package:yummyogya_mobile/dashboard/screens/dashboard_screen.dart';

class LeftDrawer extends StatelessWidget {
  final String username; // Parameter untuk nama pengguna

  const LeftDrawer({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.orange,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // Ganti dengan gambar profil
                ),
                const SizedBox(height: 10),
                Text(
                  'Selamat Datang, $username!', // Menampilkan nama pengguna
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Cari Makanan'),
            onTap: () {
              Navigator.pushNamed(
                  context, '/search'); // Route ke halaman Cari Makanan
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profil'),
            onTap: () {
              Navigator.pushNamed(
                  context, '/editProfile'); // Route ke halaman Edit Profil
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(username: username),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Wishlist'),
            onTap: () {
              Navigator.pushNamed(context,
                  '/wishlist'); // Route ke halaman Wishlist (on progress)
            },
          ),

          // Divider
          const Divider(),

          // Back to Homepage
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Kembali ke Homepage'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/menu', // Route ke homepage (landing page)
                (route) => false, // Menghapus semua rute sebelumnya
              );
            },
          ),

          // Logout Option
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Logika logout
              Navigator.pop(context); // Tutup drawer
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Anda telah logout')),
              );
            },
          ),
        ],
      ),
    );
  }
}
