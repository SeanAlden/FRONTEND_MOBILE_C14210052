import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:ta_c14210052/models/product.dart';
import 'package:ta_c14210052/views/pages/app/quantity_selector.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int? loggedInUserId;
  Map<DateTime, int> selectedQuantities = {};
  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2);

  // int selectedQuantity = 0;
  // Tambahan variabel state

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

  // Future<void> addToCart() async {
  //   DateTime now = DateTime.now();
  //   Map<String, int> cartData = {};

  //   selectedQuantities.forEach((expDate, quantity) {
  //     if (quantity > 0) {
  //       cartData[DateFormat('yyyy-MM-dd').format(expDate)] = quantity;
  //     }
  //   });

  //   if (cartData.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Silakan pilih jumlah produk sebelum menambahkan ke keranjang!'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   final geturl = Uri.parse('${responseUrl}/api/cart/add');
  //   final response = await http.post(
  //     geturl,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'product_id': widget.product.id,
  //       'quantities': cartData,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Produk berhasil ditambahkan ke keranjang!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Gagal menambahkan produk ke keranjang!'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  // Future<void> addToCart() async {
  //   // DateTime now = DateTime.now();
  //   Map<String, int> cartData = {};

  //   selectedQuantities.forEach((expDate, quantity) {
  //     if (quantity > 0) {
  //       cartData[DateFormat('yyyy-MM-dd').format(expDate)] =
  //           quantity.toInt(); // Pastikan integer
  //     }
  //   });

  //   if (cartData.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //             'Silakan pilih jumlah produk sebelum menambahkan ke keranjang!'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   final geturl = Uri.parse('$responseUrl/api/cart/add');
  //   print("Request URL: $geturl");
  //   print("Request Body: ${jsonEncode({
  //         'product_id': widget.product.id,
  //         'quantities': cartData,
  //       })}");

  //   final response = await http.post(
  //     geturl,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json'
  //     },
  //     body: jsonEncode({
  //       'product_id': widget.product.id,
  //       'quantities': cartData,
  //       'user_id': loggedInUserId, // <- Tambahkan ini
  //     }),
  //   );

  //   print("Response Code: ${response.statusCode}");
  //   print("Response Body: ${response.body}");

  //   if (response.statusCode == 200) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Produk berhasil ditambahkan ke keranjang!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content:
  //             Text('Gagal menambahkan produk ke keranjang! ${response.body}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  // Future<void> addToCart() async {
  //   Map<String, int> cartData = {};

  //   selectedQuantities.forEach((expDate, quantity) {
  //     if (quantity > 0) {
  //       cartData[DateFormat('yyyy-MM-dd').format(expDate)] = quantity.toInt();
  //     }
  //   });

  //   if (cartData.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //             'Silakan pilih jumlah produk sebelum menambahkan ke keranjang!'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   final userId =
  //       prefs.getInt('user_id'); // Ambil user_id yang disimpan sebelumnya

  //   if (token == null || token.isEmpty || userId == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Anda belum login atau data user tidak ditemukan!'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   final geturl = Uri.parse('$responseUrl/api/cart/add');

  //   final bodyData = {
  //     'user_id': userId,
  //     'product_id': widget.product.id,
  //     'quantities': cartData,
  //   };

  //   print("Request URL: $geturl");
  //   print("Request Body: ${jsonEncode(bodyData)}");

  //   final response = await http.post(
  //     geturl,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode(bodyData),
  //   );

  //   print("Response Code: ${response.statusCode}");
  //   print("Response Body: ${response.body}");

  //   if (response.statusCode == 200) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Produk berhasil ditambahkan ke keranjang!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content:
  //             Text('Gagal menambahkan produk ke keranjang! ${response.body}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  // Future<void> addToCart() async {
  //   Map<String, int> cartData = {};

  //   selectedQuantities.forEach((expDate, quantity) {
  //     if (quantity > 0) {
  //       cartData[DateFormat('yyyy-MM-dd').format(expDate)] = quantity.toInt();
  //     }
  //   });

  //   if (cartData.isEmpty) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //             'Silakan pilih jumlah produk sebelum menambahkan ke keranjang!'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   final userId = prefs.getInt('user_id');

  //   if (token == null || token.isEmpty || userId == null) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Anda belum login atau data user tidak ditemukan!'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   final geturl = Uri.parse('$responseUrl/api/cart/add');

  //   final bodyData = {
  //     'user_id': userId,
  //     'product_id': widget.product.id,
  //     'quantities': cartData,
  //   };

  //   print("Request URL: $geturl");
  //   print("Request Body: ${jsonEncode(bodyData)}");

  //   final response = await http.post(
  //     geturl,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode(bodyData),
  //   );

  //   print("Response Code: ${response.statusCode}");
  //   print("Response Body: ${response.body}");

  //   if (!mounted) return;

  //   if (response.statusCode == 200) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Produk berhasil ditambahkan ke keranjang!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content:
  //             Text('Gagal menambahkan produk ke keranjang! ${response.body}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  // Future<void> addToCart() async {
  //   if (selectedExpDate == null || selectedQuantity <= 0) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //             'Silakan pilih tanggal expired dan jumlah produk sebelum menambahkan ke keranjang!'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   final userId = prefs.getInt('user_id');

  //   if (token == null || token.isEmpty || userId == null) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Anda belum login atau data user tidak ditemukan!'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   final geturl = Uri.parse('$responseUrl/api/cart/add');

  //   final cartData = {
  //     DateFormat('yyyy-MM-dd').format(selectedExpDate!): selectedQuantity,
  //   };

  //   final bodyData = {
  //     'user_id': userId,
  //     'product_id': widget.product.id,
  //     'quantities': cartData,
  //   };

  //   print("Request URL: $geturl");
  //   print("Request Body: ${jsonEncode(bodyData)}");

  //   final response = await http.post(
  //     geturl,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode(bodyData),
  //   );

  //   print("Response Code: ${response.statusCode}");
  //   print("Response Body: ${response.body}");

  //   if (!mounted) return;

  //   if (response.statusCode == 200) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Produk berhasil ditambahkan ke keranjang!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content:
  //             Text('Gagal menambahkan produk ke keranjang! ${response.body}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  Future<void> addToCart() async {
    if (selectedQuantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Silakan pilih jumlah produk sebelum menambahkan ke keranjang!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('user_id');

    if (token == null || token.isEmpty || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda belum login atau data user tidak ditemukan!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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

    print("Request Body: ${jsonEncode(bodyData)}");

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
          content: Text('Gagal menambahkan ke keranjang! ${response.body}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Future<void> addToCart() async {
  //   if (selectedQuantity <= 0) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //             'Silakan pilih jumlah produk sebelum menambahkan ke keranjang!'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   final userId = prefs.getInt('user_id');

  //   if (token == null || token.isEmpty || userId == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Anda belum login atau data user tidak ditemukan!'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   // Distribusi FIFO berdasarkan expired date
  //   List<ProductStock> validStocks = widget.product.stocks
  //       .where(
  //           (stock) => stock.expDate.isAfter(DateTime.now()) && stock.stock > 0)
  //       .toList()
  //     ..sort((a, b) => a.expDate.compareTo(b.expDate));

  //   int remainingQty = selectedQuantity;
  //   Map<String, int> cartData = {};

  //   for (var stock in validStocks) {
  //     if (remainingQty <= 0) break;

  //     int qtyToTake = remainingQty <= stock.stock ? remainingQty : stock.stock;
  //     cartData[DateFormat('yyyy-MM-dd').format(stock.expDate)] = qtyToTake;
  //     remainingQty -= qtyToTake;
  //   }

  //   final bodyData = {
  //     'user_id': userId,
  //     'product_id': widget.product.id,
  //     'shipping_method': 'Ambil di tempat', // default
  //     'payment_method': 'Cash', // default
  //     'quantities': cartData,
  //   };

  //   final geturl = Uri.parse('$responseUrl/api/cart/add');

  //   final response = await http.post(
  //     geturl,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode(bodyData),
  //   );

  //   print("Request Body: ${jsonEncode(bodyData)}");

  //   if (response.statusCode == 200) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Produk berhasil ditambahkan ke keranjang!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Gagal menambahkan ke keranjang! ${response.body}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  // Future<void> addToCart() async {
  //   List<Map<String, dynamic>> cartItems = [];

  //   for (var stock in widget.product.stocks) {
  //     final selectedQty = selectedQuantities[stock.expDate] ?? 0;

  //     if (selectedQty > 0) {
  //       if (selectedQty > stock.stock) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(
  //                 'Jumlah melebihi stok tersedia untuk tanggal ${DateFormat('yyyy-MM-dd').format(stock.expDate)}!'),
  //             backgroundColor: Colors.red,
  //           ),
  //         );
  //         return;
  //       }

  //       cartItems.add({
  //         'exp_date': DateFormat('yyyy-MM-dd').format(stock.expDate),
  //         'quantity': selectedQty,
  //       });
  //     }
  //   }

  //   if (cartItems.isEmpty) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //             'Silakan pilih jumlah produk sebelum menambahkan ke keranjang!'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   final userId = prefs.getInt('user_id');

  //   if (token == null || token.isEmpty || userId == null) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Anda belum login atau data user tidak ditemukan!'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   final geturl = Uri.parse('$responseUrl/api/cart/add');

  //   final bodyData = {
  //     'user_id': userId,
  //     'product_id': widget.product.id,
  //     'quantities': cartItems,
  //   };

  //   print("Request URL: $geturl");
  //   print("Request Body: ${jsonEncode(bodyData)}");

  //   final response = await http.post(
  //     geturl,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode(bodyData),
  //   );

  //   print("Response Code: ${response.statusCode}");
  //   print("Response Body: ${response.body}");

  //   if (!mounted) return;

  //   if (response.statusCode == 200) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Produk berhasil ditambahkan ke keranjang!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content:
  //             Text('Gagal menambahkan produk ke keranjang! ${response.body}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   DateTime now = DateTime.now();
  //   List<ProductStock> validStocks = widget.product.stocks
  //       .where((stock) => stock.expDate.isAfter(now))
  //       .toList();

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Detail Produk',
  //           style: TextStyle(
  //               fontSize: 22,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white)),
  //       centerTitle: true,
  //       backgroundColor: Colors.blue,
  //     ),
  //     body: ListView(
  //       padding: const EdgeInsets.all(16),
  //       children: [
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(12),
  //           child: Image(
  //             image: widget.product.imageUrl.isNotEmpty
  //                 ? NetworkImage(
  //                     "$responseUrl/storage/${widget.product.imageUrl}")
  //                 : const AssetImage('assets/images/product.png')
  //                     as ImageProvider,
  //             width: 200,
  //             height: 230,
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         Text(
  //           widget.product.name,
  //           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //         ),
  //         Text(
  //           widget.product.category ?? "No Category",
  //           style: const TextStyle(fontSize: 16, color: Colors.grey),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           widget.product.description,
  //           style: const TextStyle(fontSize: 16),
  //           maxLines: 4,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //         const SizedBox(height: 16),
  //         const Divider(color: Colors.black45),
  //         Text("Total Stock : ${widget.product.totalStock}",
  //             style: const TextStyle(fontSize: 16)),
  //         Text("Price  : Rp ${widget.product.price}",
  //             style:
  //                 const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //         const SizedBox(height: 16),

  //         // Menampilkan setiap tanggal expired dan quantity selector
  //         if (validStocks.isNotEmpty) ...[
  //           const Text(
  //             "Pilih Jumlah per Tanggal Expired:",
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 8),
  //           Column(
  //             children: validStocks.map((stock) {
  //               DateTime expDate = stock.expDate;
  //               int maxStock = stock.stock;

  //               return Card(
  //                 elevation: 3,
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(10)),
  //                 margin: const EdgeInsets.symmetric(vertical: 6),
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(12),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       // Expired Date
  //                       Row(
  //                         children: [
  //                           const Icon(Icons.calendar_today,
  //                               size: 18, color: Colors.blueAccent),
  //                           const SizedBox(width: 6),
  //                           Text(
  //                             "Expired: ${DateFormat('yyyy-MM-dd').format(expDate)}",
  //                             style: const TextStyle(
  //                               fontSize: 16,
  //                               color: Colors.black87,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(height: 6),

  //                       // Stok Tersedia
  //                       Text(
  //                         "Stock: $maxStock",
  //                         style:
  //                             TextStyle(fontSize: 14, color: Colors.grey[700]),
  //                       ),
  //                       const SizedBox(height: 8),

  //                       // Quantity Selector
  //                       QuantitySelector(
  //                         stock: maxStock,
  //                         onQuantityChanged: (newQuantity) {
  //                           setState(() {
  //                             selectedQuantities[expDate] = newQuantity;
  //                           });
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             }).toList(),
  //           ),
  //         ] else
  //           const Text(
  //             "Semua stok telah kedaluwarsa",
  //             style: TextStyle(
  //                 fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
  //           ),

  //         const SizedBox(height: 16),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.blue,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8)),
  //             padding: const EdgeInsets.symmetric(vertical: 12),
  //           ),
  //           onPressed: addToCart,
  //           child: const Text("Add to Cart",
  //               style: TextStyle(fontSize: 18, color: Colors.white)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   ProductStock? availableStock = widget.product.nearestExpDate;

  //   return Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Detail Produk',
  //             style: TextStyle(
  //                 fontSize: 22,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white)),
  //         centerTitle: true,
  //         backgroundColor: Colors.blue,
  //       ),
  //       body: ListView(
  //         padding: const EdgeInsets.all(16),
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(12),
  //             child: Image(
  //               image: widget.product.imageUrl.isNotEmpty
  //                   ? NetworkImage(
  //                       "$responseUrl/storage/${widget.product.imageUrl}")
  //                   : const AssetImage('assets/images/product.png')
  //                       as ImageProvider,
  //               width: 200,
  //               height: 230,
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //           const SizedBox(height: 16),
  //           Text(
  //             widget.product.name,
  //             style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //           ),
  //           Text(
  //             widget.product.category ?? "No Category",
  //             style: const TextStyle(fontSize: 16, color: Colors.grey),
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             widget.product.description,
  //             style: const TextStyle(fontSize: 16),
  //             maxLines: 4,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //           // const SizedBox(height: 16),
  //           const Divider(color: Colors.black45),
  //           // Text("Total Stock : ${widget.product.totalStock}",
  //           //     style: const TextStyle(fontSize: 16)),
  //           // Text("Price  : Rp ${widget.product.price}",
  //           //     style:
  //           //         const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //           // const SizedBox(height: 16),

  //           if (availableStock != null) ...[
  //             // const Text(
  //             //   "Pilih Jumlah:",
  //             //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //             // ),
  //             const SizedBox(height: 8),
  //             Card(
  //               elevation: 3,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10)),
  //               margin: const EdgeInsets.symmetric(vertical: 6),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(12),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     // Expired Date
  //                     Row(
  //                       children: [
  //                         const Icon(Icons.calendar_today,
  //                             size: 18, color: Colors.blueAccent),
  //                         const SizedBox(width: 6),
  //                         Text(
  //                           "Expired: ${DateFormat('yyyy-MM-dd').format(availableStock.expDate)}",
  //                           style: const TextStyle(
  //                             fontSize: 16,
  //                             color: Colors.black87,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     Text("Price  : ${formatCurrency.format(widget.product.price)}",
  //                         style: const TextStyle(
  //                             fontSize: 16, fontWeight: FontWeight.bold)),
  //                     const SizedBox(height: 6),

  //                     // Stok Tersedia
  //                     Text(
  //                       "Stock: ${availableStock.stock}",
  //                       style: TextStyle(fontSize: 14, color: Colors.black),
  //                     ),
  //                     const SizedBox(height: 8),

  //                     // Quantity Selector
  //                     QuantitySelector(
  //                       stock: availableStock.stock,
  //                       onQuantityChanged: (newQuantity) {
  //                         setState(() {
  //                           selectedQuantities[availableStock.expDate] =
  //                               newQuantity;
  //                         });
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ] else
  //             const Text(
  //               "Stok telah habis",
  //               style: TextStyle(
  //                   fontSize: 16,
  //                   color: Colors.red,
  //                   fontWeight: FontWeight.bold),
  //             ),

  //           const SizedBox(height: 16),
  //           ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.blue,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(8)),
  //               padding: const EdgeInsets.symmetric(vertical: 12),
  //             ),
  //             onPressed: addToCart,
  //             child: const Text("Add to Cart",
  //                 style: TextStyle(fontSize: 18, color: Colors.white)),
  //           ),
  //         ],
  //       ));
  // }

  // @override
  // Widget build(BuildContext context) {
  //   // Ambil semua stok yang belum expired dan stoknya > 0
  //   List<ProductStock> validStocks = widget.product.stocks
  //       .where(
  //           (stock) => stock.expDate.isAfter(DateTime.now()) && stock.stock > 0)
  //       .toList();

  //   // Hitung total stok dari semua tanggal
  //   int totalAvailableStock =
  //       validStocks.fold(0, (sum, stock) => sum + stock.stock);

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Detail Produk',
  //           style: TextStyle(
  //               fontSize: 22,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white)),
  //       centerTitle: true,
  //       backgroundColor: Colors.blue,
  //     ),
  //     body: ListView(
  //       padding: const EdgeInsets.all(16),
  //       children: [
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(12),
  //           child: Image(
  //             image: widget.product.imageUrl.isNotEmpty
  //                 ? NetworkImage(
  //                     "$responseUrl/storage/${widget.product.imageUrl}")
  //                 : const AssetImage('assets/images/product.png')
  //                     as ImageProvider,
  //             width: 200,
  //             height: 230,
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         Text(
  //           widget.product.name,
  //           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //         ),
  //         Text(
  //           widget.product.category ?? "No Category",
  //           style: const TextStyle(fontSize: 16, color: Colors.grey),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           widget.product.description,
  //           style: const TextStyle(fontSize: 16),
  //           maxLines: 4,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //         const Divider(color: Colors.black45),
  //         if (validStocks.isNotEmpty) ...[
  //           Text("Stock: $totalAvailableStock",
  //               style:
  //                   const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //           const SizedBox(height: 8),
  //           // Loop per tanggal expired
  //           for (var stock in validStocks) ...[
  //             Card(
  //               elevation: 3,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10)),
  //               margin: const EdgeInsets.symmetric(vertical: 6),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(12),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         const Icon(Icons.calendar_today,
  //                             size: 18, color: Colors.blueAccent),
  //                         const SizedBox(width: 6),
  //                         Text(
  //                           "Expired: ${DateFormat('yyyy-MM-dd').format(stock.expDate)} (${stock.stock})",
  //                           style: const TextStyle(
  //                             fontSize: 16,
  //                             color: Colors.black87,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     Text(
  //                         "Price  : ${formatCurrency.format(widget.product.price)}",
  //                         style: const TextStyle(
  //                             fontSize: 16, fontWeight: FontWeight.bold)),
  //                     const SizedBox(height: 6),
  //                     QuantitySelector(
  //                       stock: stock.stock,
  //                       onQuantityChanged: (newQuantity) {
  //                         setState(() {
  //                           selectedQuantities[stock.expDate] = newQuantity;
  //                         });
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ] else
  //           const Text(
  //             "Stok telah habis",
  //             style: TextStyle(
  //                 fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
  //           ),
  //         const SizedBox(height: 16),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.blue,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8)),
  //             padding: const EdgeInsets.symmetric(vertical: 12),
  //           ),
  //           onPressed: addToCart,
  //           child: const Text("Add to Cart",
  //               style: TextStyle(fontSize: 18, color: Colors.white)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   // Ambil semua stok valid (belum expired dan jumlahnya > 0)
  //   List<ProductStock> validStocks = widget.product.stocks
  //       .where(
  //           (stock) => stock.expDate.isAfter(DateTime.now()) && stock.stock > 0)
  //       .toList()
  //     ..sort((a, b) =>
  //         a.expDate.compareTo(b.expDate)); // sort dari exp paling dekat

  //   int totalAvailableStock =
  //       validStocks.fold(0, (sum, stock) => sum + stock.stock);

  //   // Track expired stock usage saat quantity bertambah
  //   String getCurrentExpDateBasedOnQuantity(int quantity) {
  //     int remaining = quantity;
  //     for (var stock in validStocks) {
  //       if (remaining <= stock.stock) {
  //         return DateFormat('yyyy-MM-dd').format(stock.expDate);
  //       } else {
  //         remaining -= stock.stock;
  //       }
  //     }
  //     return "-";
  //   }

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Detail Produk',
  //           style: TextStyle(
  //               fontSize: 22,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white)),
  //       centerTitle: true,
  //       backgroundColor: Colors.blue,
  //     ),
  //     body: ListView(
  //       padding: const EdgeInsets.all(16),
  //       children: [
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(12),
  //           child: Image(
  //             image: widget.product.imageUrl.isNotEmpty
  //                 ? NetworkImage(
  //                     "$responseUrl/storage/${widget.product.imageUrl}")
  //                 : const AssetImage('assets/images/product.png')
  //                     as ImageProvider,
  //             width: 200,
  //             height: 230,
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         Text(
  //           widget.product.name,
  //           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //         ),
  //         Text(
  //           widget.product.category ?? "No Category",
  //           style: const TextStyle(fontSize: 16, color: Colors.grey),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           widget.product.description,
  //           style: const TextStyle(fontSize: 16),
  //           maxLines: 4,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //         const Divider(color: Colors.black45),
  //         if (validStocks.isNotEmpty) ...[
  //           Text("Total Stok: $totalAvailableStock",
  //               style:
  //                   const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //           const SizedBox(height: 12),
  //           const Text("Gunakan stok berdasarkan tanggal expired terdekat:",
  //               style: TextStyle(fontSize: 14)),
  //           const SizedBox(height: 4),
  //           Text(
  //             "Tanggal expired aktif: ${getCurrentExpDateBasedOnQuantity(selectedQuantity)}",
  //             style: const TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w500,
  //                 color: Colors.blue),
  //           ),
  //           const SizedBox(height: 6),
  //           QuantitySelector(
  //             stock: totalAvailableStock,
  //             onQuantityChanged: (newQuantity) {
  //               setState(() {
  //                 selectedQuantity = newQuantity;
  //               });
  //             },
  //           ),
  //         ] else
  //           const Text(
  //             "Stok telah habis",
  //             style: TextStyle(
  //                 fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
  //           ),
  //         const SizedBox(height: 16),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.blue,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8)),
  //             padding: const EdgeInsets.symmetric(vertical: 12),
  //           ),
  //           onPressed: addToCart,
  //           child: const Text("Add to Cart",
  //               style: TextStyle(fontSize: 18, color: Colors.white)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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

    // Tentukan tanggal expired aktif berdasarkan jumlah yang dipilih
    int remainingQty = selectedQuantity;
    // DateTime? selectedExpDate;
    // for (var stock in validStocks) {
    //   if (remainingQty <= stock.stock) {
    //     selectedExpDate = stock.expDate;
    //     break;
    //   } else {
    //     remainingQty -= stock.stock;
    //   }
    // }

    // Gunakan variabel dari State
    this.selectedExpDate = null;
    for (var stock in validStocks) {
      if (remainingQty <= stock.stock) {
        this.selectedExpDate = stock.expDate;
        break;
      } else {
        remainingQty -= stock.stock;
      }
    }

    return Scaffold(
      appBar: AppBar(
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(
              image: widget.product.imageUrl.isNotEmpty
                  ? NetworkImage(
                      "$responseUrl/storage/${widget.product.imageUrl}")
                  : const AssetImage('assets/images/product.png')
                      as ImageProvider,
              width: 200,
              height: 230,
              fit: BoxFit.cover,
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
          Text(
            widget.product.description,
            style: const TextStyle(fontSize: 16),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(color: Colors.black45),
          if (validStocks.isNotEmpty) ...[
            Text("Stock: $totalAvailableStock",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Tampilkan tanggal expired berdasarkan quantity yang dipilih
            // if (selectedExpDate != null)
            //   Row(
            //     children: [
            //       const Icon(Icons.calendar_today,
            //           size: 18, color: Colors.blueAccent),
            //       const SizedBox(width: 6),
            //       // Text(
            //       //   "Expired: ${DateFormat('yyyy-MM-dd').format(selectedExpDate)}",
            //       //   style: const TextStyle(
            //       //       fontSize: 16,
            //       //       color: Colors.black87,
            //       //       fontWeight: FontWeight.bold),
            //       // ),

            //       Text(
            //         "Expired: ${DateFormat('yyyy-MM-dd').format(selectedExpDate)}"
            //         " (${validStocks.firstWhere((s) => s.expDate == selectedExpDate).stock} stok)",
            //         style: const TextStyle(
            //           fontSize: 16,
            //           color: Colors.black87,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ],
            //   ),

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
                      return Text(
                        "Expired: $formattedDate (${matchedStock.stock} stok)",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
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

            // 1 quantity selector total
            // QuantitySelector(
            //   stock: totalAvailableStock,
            //   onQuantityChanged: (newQty) {
            //     setState(() {
            //       selectedQuantity = newQty;
            //     });
            //   },
            // ),

            QuantitySelector(
              stock: totalAvailableStock,
              onQuantityChanged: (newQty) {
                setState(() {
                  selectedQuantity = newQty;

                  // Tentukan tanggal expired yang sesuai dengan jumlah
                  int remainingQty = newQty;
                  selectedExpDate = null; // Reset dulu
                  for (var stock in validStocks) {
                    if (remainingQty <= stock.stock) {
                      selectedExpDate = stock.expDate;
                      break;
                    } else {
                      remainingQty -= stock.stock;
                    }
                  }
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
