import 'package:flutter/material.dart';

class FilterModal extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final double minPrice;
  final double maxPrice;
  final Function(String, double, double) onApply;

  const FilterModal({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.minPrice,
    required this.maxPrice,
    required this.onApply,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late TextEditingController minPriceController;
  late TextEditingController maxPriceController;
  late String category;

  @override
  void initState() {
    super.initState();
    category = widget.selectedCategory;
    minPriceController =
        TextEditingController(text: widget.minPrice.toStringAsFixed(0));
    maxPriceController =
        TextEditingController(text: widget.maxPrice.toStringAsFixed(0));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 28,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: category,
              decoration: InputDecoration(
                labelText: 'Kategori',
                labelStyle: const TextStyle(color: Color(0xFFEA580C)),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFEA580C)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Color(0xFFEA580C)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Color(0xFFEA580C), width: 2),
                ),
              ),
              items: widget.categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  category = newValue!;
                });
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Harga Minimum',
                      labelStyle: const TextStyle(color: Color(0xFFEA580C)),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFEA580C)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Color(0xFFEA580C)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                        BorderSide(color: Color(0xFFEA580C), width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Harga Maksimum',
                      labelStyle: const TextStyle(color: Color(0xFFEA580C)),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFEA580C)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Color(0xFFEA580C)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                        BorderSide(color: Color(0xFFEA580C), width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final double minPriceInput =
                    double.tryParse(minPriceController.text) ??
                        widget.minPrice;
                final double maxPriceInput =
                    double.tryParse(maxPriceController.text) ??
                        widget.maxPrice;
                widget.onApply(category, minPriceInput, maxPriceInput);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFEA580C),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Terapkan Filter'),
            ),
          ],
        ),
      ),
    );
  }
}
