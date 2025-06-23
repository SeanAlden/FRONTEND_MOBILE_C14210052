import 'package:flutter/material.dart';
import 'package:ta_c14210052/models/product.dart';

class CategoryCard extends StatelessWidget {
  final String title; // mengambil nama kategori 
  final List<Product> products; // mengambil data produk dari kategori terkait

  const CategoryCard({super.key, required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    // tampilan card category-nya
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
          // menampilkan nama kategori
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
