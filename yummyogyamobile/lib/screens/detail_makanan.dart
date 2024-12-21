// Halaman Detail ( Nanti diapus ya ganti ke page yang bagusan)
import 'package:flutter/material.dart';
import 'package:yummyogya_mobile/models/makanan_entry.dart';

class DetailPage extends StatelessWidget {
  final Makanan makanan;

  DetailPage({required this.makanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(makanan.fields.nama),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              makanan.fields.gambar.startsWith('http')
                  ? makanan.fields.gambar
                  : 'http://127.0.0.1:8000${makanan.fields.gambar}',
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.fastfood,
                  size: 100,
                  color: Colors.orange,
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              makanan.fields.nama,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Rp ${makanan.fields.harga}'),
            // Tambahkan detail lainnya sesuai kebutuhan
          ],
        ),
      ),
    );
  }
}
