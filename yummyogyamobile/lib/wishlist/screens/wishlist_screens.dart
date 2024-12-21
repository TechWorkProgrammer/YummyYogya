import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yummyogya_mobile/screens/search.dart';
import 'package:yummyogya_mobile/utils/auth.dart';
import 'package:yummyogya_mobile/utils/variable.dart';
import '../models/wishlist_product.dart';
import 'dart:convert';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<WishlistProduct> wishlistItems = [];
  bool isLoading = true;
  String error = '';
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserAndFetchWishlist();
  }

  Future<void> _loadUserAndFetchWishlist() async {
    final user = await Auth.getUser();
    if (user != null) {
      setState(() {
        username = user['username'];
      });
      fetchWishlistItems();
    } else {
      setState(() {
        error = 'User tidak ditemukan. Silakan login kembali.';
        isLoading = false;
      });
    }
  }

  Future<void> fetchWishlistItems() async {
    if (username == null) return;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wishlist/wishlist/get_wishlist/?username=$username'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<WishlistProduct> items =
        wishlistProductFromJson(response.body);
        setState(() {
          wishlistItems = items;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Gagal memuat wishlist.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Kesalahan koneksi: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _addToWishlist(Map<String, dynamic> wishlistData) async {
    final url = Uri.parse('$baseUrl/wishlist/add_wishlist_flutter/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(wishlistData),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Item berhasil ditambahkan ke Wishlist! Total: ${jsonResponse['wishlist_count']}'),
            backgroundColor: Colors.green,
          ),
        );
        fetchWishlistItems();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menambahkan item ke Wishlist'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kesalahan koneksi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> removeFromWishlist(int foodId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/wishlist/remove-from-wishlist/$foodId/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          wishlistItems.removeWhere((item) => item.id == foodId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item berhasil dihapus dari Wishlist')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus item dari Wishlist')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kesalahan koneksi: $e')),
      );
    }
  }

  Future<void> updateNotes(int foodId, String notes) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wishlist/update-notes/$foodId/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'notes': notes}),
      );

      if (response.statusCode == 200) {
        fetchWishlistItems();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catatan berhasil diperbarui')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui catatan')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kesalahan koneksi: $e')),
      );
    }
  }

  void _showNotesDialog(WishlistProduct item) {
    final TextEditingController notesController =
    TextEditingController(text: item.notes);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Perbarui Catatan'),
        content: TextField(
          controller: notesController,
          decoration: const InputDecoration(
            hintText: 'Masukkan catatan Anda di sini',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              updateNotes(item.id, notesController.text);
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Text(error),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist Saya'),
        backgroundColor: const Color(0xFFEA580C),
      ),
      body: wishlistItems.isEmpty
          ? const Center(
        child: Text('Wishlist Anda kosong'),
      )
          : ListView.builder(
        itemCount: wishlistItems.length,
        itemBuilder: (context, index) {
          final item = wishlistItems[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      item.gambar,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.nama,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp ${item.harga}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            Text(item.rating),
                          ],
                        ),
                        if (item.notes.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Catatan: ${item.notes}',
                            style:
                            Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showNotesDialog(item);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          removeFromWishlist(item.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchPage(),
            ),
          );
        },
        label: const Text('Cari Makanan'),
        backgroundColor: const Color(0xFFEA580C),
      ),
    );
  }
}
