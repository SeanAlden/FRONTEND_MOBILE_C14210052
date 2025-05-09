import 'package:flutter/material.dart';
import 'package:ta_c14210052/models/product.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final List<Product> products;

  const CategoryCard({super.key, required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4)
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.medical_services, size: 40, color: Colors.red),
          const SizedBox(height: 5),
          Text(title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
