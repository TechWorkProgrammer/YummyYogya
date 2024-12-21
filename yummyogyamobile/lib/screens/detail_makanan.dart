import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yummyogya_mobile/models/detail_makanan.dart';
import 'package:yummyogya_mobile/utils/variable.dart';

class DetailPage extends StatefulWidget {
  final int foodId;

  const DetailPage({super.key, required this.foodId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<DetailMakanan> foodDetail;

  Future<DetailMakanan> fetchFoodDetail() async {
    final url =
        Uri.parse('$baseUrl/details/details_flutter/?food_id=${widget.foodId}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return DetailMakanan.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Gagal memuat detail makanan');
        }
      } else {
        throw Exception('Kesalahan server: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan koneksi: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    foodDetail = fetchFoodDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Makanan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFEA580C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<DetailMakanan>(
        future: foodDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('Detail makanan tidak tersedia'),
            );
          } else {
            final food = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      food.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 50),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${food.price}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 20),
                        Text(food.rating, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      food.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Restoran: ${food.restaurant}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Ulasan:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (food.reviews.isEmpty)
                      const Text(
                        'Belum ada ulasan.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: food.reviews.length,
                        itemBuilder: (context, index) {
                          final review = food.reviews[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.orange, size: 16),
                                      Text('${review.rating}'),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    review.review,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Dibuat pada: ${review.createdAt}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
