import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:ta_c14210052/models/product.dart';
import 'package:ta_c14210052/views/pages/app/quantity_selector.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isDescriptionExpanded = false;

  int? loggedInUserId;
  Map<DateTime, int> selectedQuantities = {};
  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2);

  int selectedQuantity = 0;
  DateTime? selectedExpDate;

  @override
  void initState() {
    super.initState();
    _initializeQuantities();
    _loadLoggedInUserId();
  }

  Future<void> _loadLoggedInUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUserId = prefs.getInt('user_id');
    });
  }

  void _initializeQuantities() {
    DateTime now = DateTime.now();
    selectedQuantities.clear();

    for (var stock in widget.product.stocks) {
      if (stock.expDate.isAfter(now)) {
        selectedQuantities[stock.expDate] = 0;
      }
    }
  }

  Future<void> addToCart() async {
    if (selectedQuantity < 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Silakan pilih jumlah produk sebelum menambahkan ke keranjang!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('token');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final userId = prefs.getInt('user_id');

    if (!mounted) return; // Tambahkan ini juga
    // if (token == null || token.isEmpty || userId == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Anda belum login atau data user tidak ditemukan!'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    //   return;
    // }

    // Distribusi FIFO berdasarkan expired date
    List<ProductStock> validStocks = widget.product.stocks
        .where(
            (stock) => stock.expDate.isAfter(DateTime.now()) && stock.stock > 0)
        .toList()
      ..sort((a, b) => a.expDate.compareTo(b.expDate));

    int remainingQty = selectedQuantity;
    Map<String, int> cartData = {};

    for (var stock in validStocks) {
      if (remainingQty <= 0) break;

      int qtyToTake = remainingQty <= stock.stock ? remainingQty : stock.stock;
      cartData[DateFormat('yyyy-MM-dd').format(stock.expDate)] = qtyToTake;
      remainingQty -= qtyToTake;
    }

    // Kirim data ke API
    final bodyData = {
      'user_id': userId,
      'product_id': widget.product.id,
      'quantities': cartData,
    };

    final geturl = Uri.parse('$responseUrl/api/cart/add');

    final response = await http.post(
      geturl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(bodyData),
    );

    if (!mounted) return; // Pastikan widget masih aktif sebelum akses context

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil ditambahkan ke keranjang!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Gagal menambahkan ke keranjang, masukkan jumlah kuantitas produk terlebih dahulu!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter stok valid (belum expired & stok > 0)
    List<ProductStock> validStocks = widget.product.stocks
        .where(
            (stock) => stock.expDate.isAfter(DateTime.now()) && stock.stock > 0)
        .toList();

    // Urutkan berdasarkan tanggal expired terdekat
    validStocks.sort((a, b) => a.expDate.compareTo(b.expDate));

    // Hitung total stok
    int totalAvailableStock =
        validStocks.fold(0, (sum, stock) => sum + stock.stock);

    // // Tentukan tanggal expired aktif berdasarkan jumlah yang dipilih
    // int remainingQty = selectedQuantity;

    // // Gunakan variabel dari State
    // this.selectedExpDate = null;
    // for (var stock in validStocks) {
    //   if (remainingQty <= stock.stock) {
    //     this.selectedExpDate = stock.expDate;
    //     break;
    //   } else {
    //     remainingQty -= stock.stock;
    //   }
    // }

    // Ambil tanggal expired terdekat dari stok valid
    this.selectedExpDate =
        validStocks.isNotEmpty ? validStocks.first.expDate : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Produk',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(12),
          //   child: Image(
          //     image: widget.product.imageUrl.isNotEmpty
          //         ? NetworkImage(
          //             "$responseUrl/storage/${widget.product.imageUrl}")
          //         : const AssetImage('assets/images/product.png')
          //             as ImageProvider,
          //     width: 200,
          //     height: 230,
          //     fit: BoxFit.fill,
          //   ),
          // ),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: (widget.product.imageUrl.isNotEmpty)
                ? Image.network(
                    "$responseUrl/public/storage/${widget.product.imageUrl}",
                    width: 200,
                    height: 230,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/product.png',
                        width: 200,
                        height: 230,
                        fit: BoxFit.fill,
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/product.png',
                    width: 200,
                    height: 230,
                    fit: BoxFit.fill,
                  ),
          ),

          const SizedBox(height: 16),
          Text(
            widget.product.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.product.category ?? "No Category",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          // Text(
          //   widget.product.description,
          //   style: const TextStyle(fontSize: 16),
          //   maxLines: 4,
          //   overflow: TextOverflow.ellipsis,
          // ),

          ReadMoreText(
            widget.product.description,
            trimLines: 4,
            colorClickableText: Colors.blue,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Lihat Selengkapnya',
            trimExpandedText: 'Sembunyikan',
            style: const TextStyle(fontSize: 16),
          ),

          // Text(
          //   widget.product.description,
          //   style: const TextStyle(fontSize: 16),
          //   maxLines: isDescriptionExpanded ? null : 4,
          //   overflow: isDescriptionExpanded
          //       ? TextOverflow.visible
          //       : TextOverflow.ellipsis,
          // ),

          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: TextButton(
          //     onPressed: () {
          //       setState(() {
          //         isDescriptionExpanded = !isDescriptionExpanded;
          //       });
          //     },
          //     child: Text(
          //       isDescriptionExpanded ? 'Sembunyikan' : 'Lihat Selengkapnya',
          //       style: const TextStyle(color: Colors.blue),
          //     ),
          //   ),
          // ),

          const Divider(color: Colors.black45),
          if (validStocks.isNotEmpty) ...[
            Text("Stock: $totalAvailableStock",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Tampilkan tanggal expired berdasarkan quantity yang dipilih
            if (selectedExpDate != null)
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 18, color: Colors.blueAccent),
                  const SizedBox(width: 6),
                  Builder(
                    builder: (_) {
                      final formattedDate =
                          DateFormat('yyyy-MM-dd').format(selectedExpDate!);
                      final matchedStock = validStocks.firstWhere(
                          (s) => s.expDate == selectedExpDate,
                          orElse: () => ProductStock(
                              expDate: selectedExpDate!, stock: 0));
                      return Expanded(
                        child: Text(
                          "Expired: $formattedDate (${matchedStock.stock} stok)",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      );
                    },
                  ),
                ],
              ),

            Text("Price  : ${formatCurrency.format(widget.product.price)}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),

            // QuantitySelector(
            //   stock: totalAvailableStock,
            //   onQuantityChanged: (newQty) {
            //     setState(() {
            //       selectedQuantity = newQty;

            //       // Tentukan tanggal expired yang sesuai dengan jumlah
            //       int remainingQty = newQty;
            //       selectedExpDate = null; // Reset dulu
            //       for (var stock in validStocks) {
            //         if (remainingQty <= stock.stock) {
            //           selectedExpDate = stock.expDate;
            //           break;
            //         } else {
            //           remainingQty -= stock.stock;
            //         }
            //       }
            //     });
            //   },
            // ),

            QuantitySelector(
              stock: totalAvailableStock,
              onQuantityChanged: (newQty) {
                setState(() {
                  selectedQuantity = newQty;

                  // Tetapkan tanggal expired terdekat (tidak berubah saat quantity berubah)
                  selectedExpDate =
                      validStocks.isNotEmpty ? validStocks.first.expDate : null;
                });
              },
            ),
          ] else
            const Text(
              "Stok telah habis",
              style: TextStyle(
                  fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: addToCart,
            child: const Text("Add to Cart",
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
