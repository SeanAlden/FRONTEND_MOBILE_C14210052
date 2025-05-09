// import 'package:flutter/material.dart';
// import 'package:ta_c14210052/constant/api_url.dart';
// import 'package:ta_c14210052/models/product.dart';
// import 'package:intl/intl.dart';

// class ProductCard extends StatelessWidget {
//   final Product product;

//   const ProductCard({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     DateTime today = DateTime.now();
//     DateTime? nearestExpDate =
//         product.stocks.isNotEmpty ? product.stocks.first.expDate : null;

//     bool isExpiringSoon = nearestExpDate != null &&
//         today.isBefore(nearestExpDate) &&
//         today.add(const Duration(days: 90)).isAfter(nearestExpDate);

//     return Container(
//       width: 200,
//       margin: const EdgeInsets.only(right: 16),
//       decoration: BoxDecoration(
//         color: isExpiringSoon ? Colors.orange[100] : Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6)
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//             child: Image(
//               image: product.imageUrl.isNotEmpty
//                   ? NetworkImage("$responseUrl/storage/${product.imageUrl}")
//                   : const AssetImage('assets/images/product.png')
//                       as ImageProvider,
//               width: 200,
//               height: 120,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Expanded(
//             // Menggunakan Expanded agar tidak overflow
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           product.name,
//                           style: const TextStyle(
//                               fontSize: 14, fontWeight: FontWeight.bold),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const Icon(Icons.favorite_border, color: Colors.red),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     product.description,
//                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   // Text(
//                   //   "Kategori: ${product.category ?? 'Tidak ada'}",
//                   //   style: const TextStyle(fontSize: 12, color: Colors.black54),
//                   // ),
//                   // Text(
//                   //   "Kategori: ${product.category != null ? (product.category!.length > 18 ? '${product.category!.substring(0, 18)}...' : product.category) : 'Tidak ada'}",
//                   //   style: const TextStyle(fontSize: 12, color: Colors.black54),
//                   // ),

//                   Text(
//                     "Kategori: ${product.category ?? 'Tidak ada'}",
//                     style: const TextStyle(fontSize: 12, color: Colors.black54),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                   ),

//                   const SizedBox(height: 4),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Stock: ${product.totalStock}",
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                       Text(
//                         "Rp ${product.price}",
//                         style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "Nearest Exp: ${nearestExpDate != null ? DateFormat('yyyy-MM-dd').format(nearestExpDate) : 'Tidak ada'}",
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: isExpiringSoon ? Colors.red : Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:ta_c14210052/models/product.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  Future<void> checkIfFavorite() async {
    final token = await getToken();
    if (token != null) {
      final response = await http.get(
        Uri.parse('$responseUrl/api/check-favorite/${widget.product.id}'),
        headers: {
          'Authorization': 'Bearer $token', // Pass token here
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            isFavorite = json.decode(response.body)['isFavorite'];
          });
        }
      }
    }
  }

  Future<void> toggleFavorite() async {
    final token = await getToken();
    if (token != null) {
      final response = await http.post(
        Uri.parse('$responseUrl/api/toggle-favorite/${widget.product.id}'),
        headers: {
          'Authorization': 'Bearer $token', // Pass token here
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isFavorite = !isFavorite; // Toggle favorite state
        });
      }
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Retrieve token from SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime? nearestExpDate = widget.product.stocks.isNotEmpty
        ? widget.product.stocks.first.expDate
        : null;

    bool isExpiringSoon = nearestExpDate != null &&
        today.isBefore(nearestExpDate) &&
        today.add(const Duration(days: 90)).isAfter(nearestExpDate);

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      // decoration: BoxDecoration(
      //   color: isExpiringSoon ? Colors.orange[100] : Colors.white,
      //   borderRadius: BorderRadius.circular(12),
      //   boxShadow: [
      //     BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6)
      //   ],
      // ),

      decoration: BoxDecoration(
        color: widget.product.totalStock == 0
            ? Colors.red[100]
            : (isExpiringSoon ? Colors.orange[100] : Colors.white),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image(
              image: widget.product.imageUrl.isNotEmpty
                  ? NetworkImage(
                      "$responseUrl/storage/${widget.product.imageUrl}")
                  : const AssetImage('assets/images/product.png')
                      as ImageProvider,
              width: 200,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: isFavorite
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                                color: Colors.grey,
                              ),
                        onPressed: toggleFavorite,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Kategori: ${widget.product.category ?? 'Tidak ada'}",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Stock: ${widget.product.totalStock}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        "${formatCurrency.format(widget.product.price)}",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Exp: ${nearestExpDate != null ? DateFormat('yyyy-MM-dd').format(nearestExpDate) : 'Tidak ada'}",
                    style: TextStyle(
                      fontSize: 12,
                      color: isExpiringSoon ? Colors.red : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
