import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yummyogya_mobile/components/filter_modal.dart';
import 'package:yummyogya_mobile/components/food_card.dart';
import 'package:yummyogya_mobile/models/makanan_entry.dart';
import 'package:yummyogya_mobile/utils/variable.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String errorMessage = '';
  late Future<List<Makanan>> makananFuture;
  List<String> categories = [];
  String selectedCategory = 'All';
  String searchQuery = '';
  double minPrice = 0;
  double maxPrice = 100000;

  Future<List<Makanan>> fetchMakanan() async {
    const String url = '$baseUrl/dashboard/api/dashboard_data/';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          List<Makanan> makanan = makananFromJson(jsonEncode(data['data']));
          setState(() {
            categories = [
              'All',
              ...{for (var item in makanan) item.category}
            ];
          });
          return makanan;
        } else {
          _showSnackBar(data['message'] ?? 'Gagal memuat data makanan.');
          return [];
        }
      } else {
        _showSnackBar('Kesalahan server. Status kode: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _showSnackBar('Kesalahan koneksi: $e');
      return [];
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    makananFuture = fetchMakanan();
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FilterModal(
          categories: categories,
          selectedCategory: selectedCategory,
          minPrice: minPrice,
          maxPrice: maxPrice,
          onApply: (category, minPrice, maxPrice) {
            setState(() {
              selectedCategory = category;
              this.minPrice = minPrice;
              this.maxPrice = maxPrice;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari makanan...',
                      prefixIcon:
                      const Icon(Icons.search, color: Color(0xFFEA580C)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFEA580C)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFEA580C)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(0xFFEA580C), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase().trim();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    border:
                    Border.all(color: const Color(0xFFEA580C), width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon:
                    const Icon(Icons.filter_list, color: Color(0xFFEA580C)),
                    onPressed: _openFilterModal,
                    splashRadius: 28,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Makanan>>(
              future: makananFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada data makanan.'));
                }
                final List<Makanan> filteredMakanan = snapshot.data!
                    .where((makanan) =>
                makanan.name.toLowerCase().contains(searchQuery) &&
                    (selectedCategory == 'All' ||
                        makanan.category == selectedCategory) &&
                    makanan.price >= minPrice &&
                    makanan.price <= maxPrice)
                    .toList();
                if (filteredMakanan.isEmpty) {
                  return const Center(
                      child: Text('Tidak ada hasil yang sesuai.'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: filteredMakanan.length,
                  itemBuilder: (context, index) {
                    return FoodCard(food: filteredMakanan[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
