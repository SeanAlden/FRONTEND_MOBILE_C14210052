import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:ta_c14210052/models/cart.dart';
import 'dart:convert';

import 'package:ta_c14210052/models/merged_cart_item.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> cartItems = [];
  List<MergedCartItem> mergedCartItems = [];

  String? selectedShippingMethod;
  String? selectedPaymentMethod;

  List<String> shippingOptions = [];
  List<String> paymentOptions = [];

  List<String> shippingMethods = ['Reguler', 'Express', 'Ambil di tempat'];
  List<String> paymentMethods = ['Cash', 'Bank Transfer', 'OVO', 'Dana', 'COD'];

  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  double getShippingCost() {
    switch (selectedShippingMethod) {
      case 'Reguler':
        return 1750.0;
      case 'Express':
        return 3500.0;
      case 'Ambil di tempat':
      default:
        return 0.0;
    }
  }

  double getTotalPayment() {
    return getTotalPrice() + getShippingCost();
  }

  void showShippingMethodDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pilih Metode Pengiriman"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: shippingMethods.map((method) {
              return RadioListTile<String>(
                title: Text(method),
                value: method,
                groupValue: selectedShippingMethod,
                onChanged: (value) async {
                  Navigator.pop(context);
                  await updateCartField('shipping_method', value);
                  setState(() {
                    selectedShippingMethod = value;

                    // Jika metode pengiriman adalah "Ambil di tempat", kembalikan metode pembayaran ke default
                    if (selectedShippingMethod == 'Ambil di tempat') {
                      selectedPaymentMethod = paymentMethods
                          .firstWhere((method) => method != 'COD');
                      updateCartField('payment_method', selectedPaymentMethod);
                    }
                    if (selectedShippingMethod == 'Reguler' ||
                        selectedShippingMethod == 'Express') {
                      selectedPaymentMethod = paymentMethods
                          .firstWhere((method) => method != 'Cash');
                      updateCartField('payment_method', selectedPaymentMethod);
                    }
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void showPaymentMethodDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pilih Metode Pembayaran"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: paymentMethods
                .where((method) => !(method == 'COD' &&
                    selectedShippingMethod == 'Ambil di tempat'))
                .where((method) =>
                    !(method == 'Cash' && selectedShippingMethod == 'Reguler'))
                .where((method) =>
                    !(method == 'Cash' && selectedShippingMethod == 'Express'))
                .map((method) {
              return RadioListTile<String>(
                title: Text(method),
                value: method,
                groupValue: selectedPaymentMethod,
                onChanged: (value) async {
                  Navigator.pop(context);
                  await updateCartField('payment_method', value);
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> updateCartField(String field, String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Token tidak ditemukan, silakan login ulang")),
      );
      return;
    }

    final url = Uri.parse('$responseUrl/api/cart/update-field');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Tambahkan token di sini
      },
      body: jsonEncode({
        'field': field,
        'value': value,
      }),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Gagal memperbarui cart: ${data['message'] ?? ''}")),
      );
    }
  }

  // Helper widget to build rows
  Widget _buildRow(
      {IconData? icon, required String text, VoidCallback? onPressed}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (onPressed != null) ...[
          TextButton(
            onPressed: onPressed,
            child: const Text(
              "Pilih",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> fetchCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // ambil token dari login

    final response = await http.get(
      Uri.parse('$responseUrl/api/cart/show'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // penting untuk autentikasi user
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        if (!mounted) return;

        setState(() {
          cartItems = (data['cart'] as List)
              .map((item) => Cart.fromJson(item))
              .toList();

          // cartItems = groupedItems.values.toList();

          shippingMethods = List<String>.from(data['shipping_methods'] ?? []);
          paymentMethods = List<String>.from(data['payment_methods'] ?? []);

          if (cartItems.isNotEmpty) {
            selectedShippingMethod = cartItems.first.shippingMethod;
            selectedPaymentMethod = cartItems.first.paymentMethod;
          } else {
            selectedShippingMethod =
                shippingMethods.isNotEmpty ? shippingMethods[0] : "";
            selectedPaymentMethod =
                paymentMethods.isNotEmpty ? paymentMethods[0] : "";
          }
        });
      }
    } else {
      print("Gagal fetch cart: ${response.statusCode} - ${response.body}");
    }
  }

  Future<void> deleteCartItem(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Token tidak ditemukan, silakan login ulang")),
      );
      return;
    }

    final response = await http.delete(
      Uri.parse('$responseUrl/api/cart/delete/product/$productId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        cartItems.removeWhere((item) => item.productId == productId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item removed from cart")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menghapus item")),
      );
    }
  }

  Future<void> updateQuantity(int id, int newQuantity, int stock) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (newQuantity < 1) newQuantity = 1;
    if (newQuantity > stock) {
      newQuantity = stock;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kuantitas melebihi stok!")),
      );
    }

    final response = await http.put(
      Uri.parse('$responseUrl/api/cart/update/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      }, // Tambahkan token di sini},
      body: jsonEncode({'quantity': newQuantity}),
    );

    if (response.statusCode == 200) {
      fetchCartItems();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memperbarui kuantitas")),
      );
    }
  }

  // Future<void> updateQuantityFIFO(
  //     List<Cart> originalItems, int newQuantity, int totalStock) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');

  //   // Allow newQuantity to be 0
  //   if (newQuantity < 0) newQuantity = 0;
  //   if (newQuantity > totalStock) {
  //     newQuantity = totalStock;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Kuantitas melebihi stok!")),
  //     );
  //   }

  //   int remainingQuantity = newQuantity;

  //   for (var item in originalItems) {
  //     int quantityForThisItem =
  //         remainingQuantity > item.stock ? item.stock : remainingQuantity;
  //     remainingQuantity -= quantityForThisItem;

  //     await http.put(
  //       Uri.parse('$responseUrl/api/cart/update/${item.id}'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token'
  //       },
  //       body: jsonEncode({'quantity': quantityForThisItem}),
  //     );

  //     if (remainingQuantity <= 0) break;
  //   }

  //   await fetchCartItems();
  // }

  // Future<void> updateQuantityFIFO(
  //     List<Cart> originalItems, int newQuantity, int totalStock) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');

  //   // Allow newQuantity to be 0
  //   if (newQuantity < 0) newQuantity = 0;
  //   if (newQuantity > totalStock) {
  //     newQuantity = totalStock;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Kuantitas melebihi stok!")),
  //     );
  //   }

  //   int remainingQuantity = newQuantity;

  //   for (var item in originalItems) {
  //     int quantityForThisItem =
  //         remainingQuantity > item.stock ? item.stock : remainingQuantity;
  //     remainingQuantity -= quantityForThisItem;

  //     await http.put(
  //       Uri.parse('$responseUrl/api/cart/update/${item.id}'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token'
  //       },
  //       body: jsonEncode({'quantity': quantityForThisItem}),
  //     );

  //     if (remainingQuantity <= 0) break;
  //   }

  //   // If there are remaining quantities to be decremented, check for previous expiration
  //   if (remainingQuantity < 1) {
  //     for (var item in originalItems) {
  //       if (item.quantity > 0) {
  //         // Decrement the quantity of the current item
  //         await updateQuantity(
  //             item.id, item.quantity + remainingQuantity, item.stock);
  //         break; // Exit after decrementing the first available item
  //       }
  //     }
  //   }

  //   await fetchCartItems();
  // }

  // Future<void> updateQuantityFIFO(
  //     List<Cart> originalItems, int newQuantity, int totalStock) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');

  //   // Validasi kuantitas baru
  //   if (newQuantity < 0) newQuantity = 0;
  //   if (newQuantity > totalStock) {
  //     newQuantity = totalStock;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Kuantitas melebihi stok!")),
  //     );
  //   }

  //   int remainingQuantity = newQuantity;

  //   for (var item in originalItems) {
  //     int assignQuantity =
  //         remainingQuantity >= item.stock ? item.stock : remainingQuantity;

  //     remainingQuantity -= assignQuantity;

  //     await http.put(
  //       Uri.parse('$responseUrl/api/cart/update/${item.id}'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token'
  //       },
  //       body: jsonEncode({'quantity': assignQuantity}),
  //     );
  //   }

  //   await fetchCartItems();
  // }

  Future<void> updateQuantityFIFO(
      List<Cart> originalItems, int newQuantity, int totalStock) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Validasi kuantitas baru
    if (newQuantity < 0) newQuantity = 0;
    if (newQuantity > totalStock) {
      newQuantity = totalStock;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kuantitas melebihi stok!")),
      );
    }

    int remainingQuantity = newQuantity;

    for (var item in originalItems) {
      int assignQuantity =
          remainingQuantity >= item.stock ? item.stock : remainingQuantity;

      remainingQuantity -= assignQuantity;

      // Log untuk debugging
      print('Updating item ${item.id} with quantity $assignQuantity');

      final response = await http.put(
        Uri.parse('$responseUrl/api/cart/update/${item.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'quantity': assignQuantity}),
      );

      // Log response status
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    await fetchCartItems();
  }

  void showCheckoutConfirmation(BuildContext context, Function onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure to do this transaction?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(); // Tutup pop-up tanpa melakukan checkout
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey, // Warna abu-abu untuk "No"
              ),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup pop-up
                onConfirm(); // Jalankan checkoutCart
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red, // Warna merah untuk "Yes"
              ),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> checkoutCart() async {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Keranjang kosong, tidak bisa checkout")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada token, silakan login ulang")),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('$responseUrl/api/cart/checkout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      setState(() {
        cartItems.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Checkout berhasil!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? "Checkout gagal")),
      );
    }
  }

  List<MergedCartItem> getMergedCartItems(List<Cart> items) {
    final Map<int, List<Cart>> grouped = {};

    for (var item in items) {
      grouped.putIfAbsent(item.productId, () => []).add(item);
    }

    return grouped.entries.map((entry) {
      final productItems = entry.value;
      productItems.sort(
          (a, b) => a.expiredDate!.compareTo(b.expiredDate!)); // FIFO sort

      // productItems.sort((a, b) {
      //   final aDate = a.expiredDate;
      //   final bDate = b.expiredDate;

      //   if (aDate == null && bDate == null) return 0;
      //   if (aDate == null) return 1; // let nulls be later
      //   if (bDate == null) return -1;
      //   return aDate.compareTo(bDate);
      // });

      return MergedCartItem(
        productId: productItems.first.productId,
        productName: productItems.first.productName,
        productImage: productItems.first.productImage,
        productPrice: productItems.first.productPrice,
        originalItems: productItems,
        totalStock: productItems.fold(0, (sum, item) => sum + item.stock),
        quantity: productItems.fold(0, (sum, item) => sum + item.quantity),
      );
    }).toList();
  }

  double getTotalPrice() {
    return cartItems.fold(0, (sum, item) => sum + item.grossAmount);
  }

  @override
  Widget build(BuildContext context) {
    final mergedCartItems = getMergedCartItems(cartItems);
    return Scaffold(
      // appBar: AppBar(title: const Text("Cart")),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Cart',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            // child: cartItems.isEmpty
            child: mergedCartItems.isEmpty
                ? const Center(child: Text("Cart is empty"))
                : ListView.builder(
                    itemCount: mergedCartItems.length,
                    itemBuilder: (context, index) {
                      final item = mergedCartItems[index];
                      TextEditingController quantityController =
                          TextEditingController(text: item.quantity.toString());

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:
                                  // Image.network(
                                  //   "$responseUrl/storage/${item.productImage}",
                                  //   width: 50,
                                  //   height: 50,
                                  //   fit: BoxFit.cover,
                                  // ),

                                  //     Image(
                                  //   // borderRadius: BorderRadius.circular(8),
                                  //   image: item.productImage.isNotEmpty
                                  //       ? NetworkImage(
                                  //           "$responseUrl/storage/${item.productImage}")
                                  //       : const AssetImage(
                                  //               'assets/images/product.png')
                                  //           as ImageProvider,
                                  //   width: 60,
                                  //   height: 60,
                                  //   fit: BoxFit.cover,
                                  // ),

                                  item.productImage.isNotEmpty
                                      ? Image.network(
                                          "$responseUrl/public/storage/${item.productImage}",
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/product.png',
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          'assets/images/product.png',
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                      "Price  : ${formatCurrency.format(item.productPrice)}"),
                                  Text(
                                      "Total  : ${formatCurrency.format(item.grossAmount)}"),
                                  Text(
                                      "Expired : ${item.expiredDate != null ? DateFormat('yyyy-MM-dd').format(item.expiredDate!) : 'N/A'}"),
                                  Text("Stock  : ${item.totalStock}",
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // cartItems.removeAt(index);
                                      // deleteCartItem(item.id);
                                      deleteCartItem(item.productId);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white, size: 18),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    GestureDetector(
                                      // onTap: () => updateQuantityFIFO(
                                      //   item.originalItems,
                                      //   item.quantity - 1,
                                      //   item.totalStock,
                                      // ),
                                      onTap: () {
                                        setState(() {
                                          if (item.quantity > 0) {
                                            item.quantity--;
                                            quantityController.text =
                                                item.quantity.toString();
                                            updateQuantityFIFO(
                                                item.originalItems,
                                                item.quantity,
                                                item.totalStock);
                                          }
                                        });
                                      },

                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[600],
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Icon(Icons.remove,
                                            color: Colors.white, size: 18),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 40,
                                      height: 30,
                                      child: TextField(
                                        controller: quantityController,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          int newQuantity =
                                              int.tryParse(value) ??
                                                  0; // Allow 0 as a valid input
                                          if (newQuantity < 0)
                                            newQuantity =
                                                0; // Ensure it doesn't go below 0
                                          if (newQuantity > item.totalStock) {
                                            newQuantity = item.totalStock;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      "Kuantitas melebihi stok!")),
                                            );
                                          }

                                          Future.delayed(
                                              const Duration(milliseconds: 500),
                                              () {
                                            updateQuantityFIFO(
                                                item.originalItems,
                                                newQuantity,
                                                item.totalStock);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      // onTap: () => updateQuantity(item.id,
                                      //     item.quantity + 1, item.totalStock),

                                      // onTap: () => updateQuantity(
                                      //     item.originalItems.first.id,
                                      //     item.originalItems.first.quantity + 1,
                                      //     item.originalItems.first.stock),

                                      // onTap: () => updateQuantityFIFO(
                                      //   item.originalItems,
                                      //   item.quantity + 1,
                                      //   item.totalStock,
                                      // ),

                                      onTap: () {
                                        setState(() {
                                          if (item.quantity < item.totalStock) {
                                            item.quantity++;
                                            quantityController.text =
                                                item.quantity.toString();
                                            updateQuantityFIFO(
                                                item.originalItems,
                                                item.quantity,
                                                item.totalStock);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      "Kuantitas melebihi stok!")),
                                            );
                                          }
                                        });
                                      },

                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[600],
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Icon(Icons.add,
                                            color: Colors.white, size: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (cartItems.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2), // Shadow position
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow(
                    icon: Icons.local_shipping,
                    text:
                        "Shipping Method: ${selectedShippingMethod ?? 'Belum dipilih'}",
                    onPressed: showShippingMethodDialog,
                  ),
                  const SizedBox(height: 10),
                  _buildRow(
                    icon: Icons.payment,
                    text:
                        "Payment Method: ${selectedPaymentMethod ?? 'Belum dipilih'}",
                    onPressed: showPaymentMethodDialog,
                  ),
                  const SizedBox(height: 10),
                  _buildRow(
                    icon: null,
                    text: "Subtotal: ${formatCurrency.format(getTotalPrice())}",
                  ),
                  const SizedBox(height: 10),
                  _buildRow(
                    icon: null,
                    text:
                        "Biaya Kirim: ${formatCurrency.format(getShippingCost())}",
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet,
                            color: Colors.white),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Total Biaya - ${formatCurrency.format(getTotalPayment())}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: ElevatedButton(
                onPressed: () {
                  showCheckoutConfirmation(context, checkoutCart);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Checkout",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
