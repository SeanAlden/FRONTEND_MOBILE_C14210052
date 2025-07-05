import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:ta_c14210052/models/product.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductCard extends StatefulWidget {
  final Product product; // mengambil data produk dari model produk

  const ProductCard({super.key, required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false; // variabel untuk menyimpan data produk yang dipilih menjadi produk favorit atau bukan 
  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2);

  // memanggil fungsi pengecekan favorit saat init state
  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  // fungsi untuk mengecek status favorit pada tiap produk, apakah dipilih menjadi produk favorit atau tidak    
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

  // fungsi untuk memilih / membatalkan produk dari status produk favorit 
  Future<void> toggleFavorite() async {
    final token = await getToken();
    if (token != null) {
      final response = await http.post(
        Uri.parse('$responseUrl/api/toggle-favorite/${widget.product.id}'),
        headers: {
          'Authorization': 'Bearer $token', // Pass token here
        },
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        setState(() {
          isFavorite = !isFavorite; // Toggle favorite state
        });
      }
    }
  }

  // fungsi untuk mendapatkan data token dari user
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Retrieve token from SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    // mengambil data tanggal hari ini (current time)
    DateTime today = DateTime.now();

    // mengambil data tanggal kadaluarsa terdekat tiap produk
    DateTime? nearestExpDate = widget.product.stocks.isNotEmpty
        ? widget.product.stocks.first.expDate
        : null;

    // mencari dat tanggal kadaluarsa yang durasinya 90 hari lagi
    bool isExpiringSoon = nearestExpDate != null &&
        today.isBefore(nearestExpDate) &&
        today.add(const Duration(days: 90)).isAfter(nearestExpDate);

    // container untuk widget card 
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      // decoration: BoxDecoration(
      //   color: isExpiringSoon ? Colors.orange[100] : Colors.white,
      //   borderRadius: BorderRadius.circular(12),
      //   boxShadow: [
      //     BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6)
      //   ],
      // ),

      // pengaturan warna pada box berdasarkan kondisi produk 
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
            // child: Image(
            //   image: widget.product.imageUrl.isNotEmpty
            //       ? NetworkImage(
            //           "$responseUrl/storage/${widget.product.imageUrl}")
            //       : const AssetImage('assets/images/product.png')
            //           as ImageProvider,
            //   width: 200,
            //   height: 120,
            //   fit: BoxFit.fill,
            // ),

            // mengatur gambar yang ditampilkan pada aplikasi
            child: widget.product.imageUrl.isNotEmpty
                // menampilkan gambar dari storage pada backend dengan api call
                ? Image.network(
                    "$responseUrl/public/storage/${widget.product.imageUrl}",
                    width: 250,
                    height: 140,
                    fit: BoxFit.fill,
                    // jika gagal di load, akan memunculkan gambar default
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/product.png',
                        width: 250,
                        height: 140,
                        fit: BoxFit.fill,
                      );
                    },
                  )
                  // jika tidak ada gambar (kosong), akan memunculkan gambar default
                : Image.asset(
                    'assets/images/product.png',
                    width: 250,
                    height: 140,
                    fit: BoxFit.fill,
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
                        // nama produk
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // ikon favorit untuk memilih / membatalkan status favorit produk terkait
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
                  // deskripsi produk
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // kategori produk terkait
                  Text(
                    "Kategori: ${widget.product.category ?? 'Tidak ada'}",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "Stock: ${widget.product.totalStock}",
                  //       style: const TextStyle(fontSize: 12),
                  //     ),
                  //     Text(
                  //       "${formatCurrency.format(widget.product.price)}",
                  //       style: const TextStyle(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.blue),
                  //     ),
                  //   ],
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                  // total stok dari produk terkait
                        child: Text(
                          "Stock: ${widget.product.totalStock}",
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8), 
                      // harga produk
                      Text(
                        "${formatCurrency.format(widget.product.price)}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  // tanggal kadaluarsa terdekat dari produk terkait
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
