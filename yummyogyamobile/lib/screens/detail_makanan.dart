// Halaman Detail ( Nanti diapus ya ganti ke page yang bagusan)
import 'package:flutter/material.dart';
import 'package:yummyogya_mobile/models/makanan_entry.dart';

class DetailPage extends StatelessWidget {
  final Makanan makanan;

  DetailPage({required this.makanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Tambahkan detail lainnya sesuai kebutuhan
          ],
        ),
      ),
    );
  }
}
