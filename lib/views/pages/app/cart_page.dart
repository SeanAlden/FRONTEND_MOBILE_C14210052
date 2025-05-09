// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_c14210052/constant/api_url.dart';
// import 'package:ta_c14210052/models/cart.dart';
// import 'dart:convert';

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   _CartPageState createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   List<Cart> cartItems = [];
//   // String selectedShipping = "";
//   // String selectedPayment = "";

//   String? selectedShippingMethod;
//   String? selectedPaymentMethod;

//   List<String> shippingOptions = [];
//   List<String> paymentOptions = [];

//   List<String> shippingMethods = ['Reguler', 'Express', 'Ambil di tempat'];
//   List<String> paymentMethods = ['Cash', 'Bank Transfer', 'OVO', 'Dana', 'COD'];

//   final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2);

//   @override
//   void initState() {
//     super.initState();
//     fetchCartItems();
//   }

//   double getShippingCost() {
//     switch (selectedShippingMethod) {
//       case 'Reguler':
//         return 1750.0;
//       case 'Express':
//         return 3500.0;
//       case 'Ambil di tempat':
//       default:
//         return 0.0;
//     }
//   }

//   double getTotalPayment() {
//     return getTotalPrice() + getShippingCost();
//   }

// // Fungsi untuk menampilkan pop-up
//   // void showShippingMethodDialog() {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         title: const Text("Pilih Metode Pengiriman"),
//   //         content: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: shippingMethods.map((method) {
//   //             return RadioListTile<String>(
//   //               title: Text(method),
//   //               value: method,
//   //               groupValue: selectedShippingMethod,
//   //               onChanged: (value) async {
//   //                 Navigator.pop(context);
//   //                 await updateCartField('shipping_method', value);
//   //                 setState(() {
//   //                   selectedShippingMethod = value;
//   //                 });
//   //               },
//   //             );
//   //           }).toList(),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   void showShippingMethodDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Pilih Metode Pengiriman"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: shippingMethods.map((method) {
//               return RadioListTile<String>(
//                 title: Text(method),
//                 value: method,
//                 groupValue: selectedShippingMethod,
//                 onChanged: (value) async {
//                   Navigator.pop(context);
//                   await updateCartField('shipping_method', value);
//                   setState(() {
//                     selectedShippingMethod = value;

//                     // Jika metode pengiriman adalah "Ambil di tempat", kembalikan metode pembayaran ke default
//                     if (selectedShippingMethod == 'Ambil di tempat') {
//                       selectedPaymentMethod = paymentMethods
//                           .firstWhere((method) => method != 'COD');
//                       updateCartField('payment_method', selectedPaymentMethod);
//                     }
//                   });
//                 },
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }

//   // void showPaymentMethodDialog() {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         title: const Text("Pilih Metode Pembayaran"),
//   //         content: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: paymentMethods.map((method) {
//   //             return RadioListTile<String>(
//   //               title: Text(method),
//   //               value: method,
//   //               groupValue: selectedPaymentMethod,
//   //               onChanged: (value) async {
//   //                 Navigator.pop(context);
//   //                 await updateCartField('payment_method', value);
//   //                 setState(() {
//   //                   selectedPaymentMethod = value;
//   //                 });
//   //               },
//   //             );
//   //           }).toList(),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   void showPaymentMethodDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Pilih Metode Pembayaran"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: paymentMethods
//                 .where((method) => !(method == 'COD' &&
//                     selectedShippingMethod == 'Ambil di tempat'))
//                 .map((method) {
//               return RadioListTile<String>(
//                 title: Text(method),
//                 value: method,
//                 groupValue: selectedPaymentMethod,
//                 onChanged: (value) async {
//                   Navigator.pop(context);
//                   await updateCartField('payment_method', value);
//                   setState(() {
//                     selectedPaymentMethod = value;
//                   });
//                 },
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> updateCartField(String field, String? value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Token tidak ditemukan, silakan login ulang")),
//       );
//       return;
//     }

//     final url = Uri.parse('$responseUrl/api/cart/update-field');
//     final response = await http.patch(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token', // Tambahkan token di sini
//       },
//       body: jsonEncode({
//         'field': field,
//         'value': value,
//       }),
//     );

//     if (response.statusCode != 200) {
//       final data = jsonDecode(response.body);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text("Gagal memperbarui cart: ${data['message'] ?? ''}")),
//       );
//     }
//   }

//   // Helper widget to build rows
//   Widget _buildRow(
//       {IconData? icon, required String text, VoidCallback? onPressed}) {
//     return Row(
//       children: [
//         if (icon != null) ...[
//           Icon(icon),
//           const SizedBox(width: 10),
//         ],
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(
//               fontSize: 16,
//               color: Colors.black,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         if (onPressed != null) ...[
//           TextButton(
//             onPressed: onPressed,
//             child: const Text(
//               "Pilih",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.blue,
//               ),
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   Future<void> fetchCartItems() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token'); // ambil token dari login

//     final response = await http.get(
//       Uri.parse('$responseUrl/api/cart/show'),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token', // penting untuk autentikasi user
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['success']) {
//         setState(() {
//           cartItems = (data['cart'] as List)
//               .map((item) => Cart.fromJson(item))
//               .toList();

//           shippingMethods = List<String>.from(data['shipping_methods'] ?? []);
//           paymentMethods = List<String>.from(data['payment_methods'] ?? []);

//           if (cartItems.isNotEmpty) {
//             selectedShippingMethod = cartItems.first.shippingMethod;
//             selectedPaymentMethod = cartItems.first.paymentMethod;
//           } else {
//             selectedShippingMethod =
//                 shippingMethods.isNotEmpty ? shippingMethods[0] : "";
//             selectedPaymentMethod =
//                 paymentMethods.isNotEmpty ? paymentMethods[0] : "";
//           }
//         });
//       }
//     } else {
//       print("Gagal fetch cart: ${response.statusCode} - ${response.body}");
//     }
//   }

//   Future<void> deleteCartItem(int id) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Token tidak ditemukan, silakan login ulang")),
//       );
//       return;
//     }

//     final response = await http.delete(
//       Uri.parse('$responseUrl/api/cart/delete/$id'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         cartItems.removeWhere((item) => item.id == id);
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Item removed from cart")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Gagal menghapus item")),
//       );
//     }
//   }

//   Future<void> updateQuantity(int id, int newQuantity, int stock) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     if (newQuantity < 1) newQuantity = 1;
//     if (newQuantity > stock) {
//       newQuantity = stock;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Kuantitas melebihi stok!")),
//       );
//     }

//     final response = await http.put(
//       Uri.parse('$responseUrl/api/cart/update/$id'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token'
//       }, // Tambahkan token di sini},
//       body: jsonEncode({'quantity': newQuantity}),
//     );

//     if (response.statusCode == 200) {
//       fetchCartItems();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Gagal memperbarui kuantitas")),
//       );
//     }
//   }

//   void showCheckoutConfirmation(BuildContext context, Function onConfirm) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text("Confirmation"),
//           content: const Text("Are you sure to do this transaction?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext)
//                     .pop(); // Tutup pop-up tanpa melakukan checkout
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.grey, // Warna abu-abu untuk "No"
//               ),
//               child: const Text("No"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop(); // Tutup pop-up
//                 onConfirm(); // Jalankan checkoutCart
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.red, // Warna merah untuk "Yes"
//               ),
//               child: const Text("Yes"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> checkoutCart() async {
//     if (cartItems.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Keranjang kosong, tidak bisa checkout")),
//       );
//       return;
//     }

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Tidak ada token, silakan login ulang")),
//       );
//       return;
//     }

//     final response = await http.post(
//       Uri.parse('$responseUrl/api/cart/checkout'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 201) {
//       setState(() {
//         cartItems.clear();
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Checkout berhasil!")),
//       );
//     } else {
//       final data = jsonDecode(response.body);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(data['message'] ?? "Checkout gagal")),
//       );
//     }
//   }

//   double getTotalPrice() {
//     return cartItems.fold(0, (sum, item) => sum + item.grossAmount);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: const Text("Cart")),
//       appBar: AppBar(
//         title: const Text('Cart',
//             style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: cartItems.isEmpty
//                 ? const Center(child: Text("Cart is empty"))
//                 : ListView.builder(
//                     itemCount: cartItems.length,
//                     itemBuilder: (context, index) {
//                       final item = cartItems[index];
//                       TextEditingController quantityController =
//                           TextEditingController(text: item.quantity.toString());

//                       return Container(
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               width: 80,
//                               height: 80,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[400],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Image.network(
//                                 "$responseUrl/storage/${item.productImage}",
//                                 width: 50,
//                                 height: 50,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.productName,
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                       "Price  : Rp ${item.productPrice.toStringAsFixed(3)}"),
//                                   Text(
//                                       "Total  : Rp ${item.grossAmount.toStringAsFixed(3)}"),
//                                   Text(
//                                       "Expired : ${item.expiredDate != null ? DateFormat('yyyy-MM-dd').format(item.expiredDate!) : 'N/A'}"),
//                                   Text("Stock  : ${item.stock}",
//                                       style: const TextStyle(
//                                           color: Colors.green,
//                                           fontWeight: FontWeight.bold)),
//                                 ],
//                               ),
//                             ),
//                             Column(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       // cartItems.removeAt(index);
//                                       deleteCartItem(item.id);
//                                     });
//                                   },
//                                   child: Container(
//                                     padding: const EdgeInsets.all(4),
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                     child: const Icon(Icons.delete,
//                                         color: Colors.white, size: 18),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Row(
//                                   children: [
//                                     GestureDetector(
//                                       onTap: () => updateQuantity(item.id,
//                                           item.quantity - 1, item.stock),
//                                       child: Container(
//                                         padding: const EdgeInsets.all(6),
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey[600],
//                                           borderRadius:
//                                               BorderRadius.circular(4),
//                                         ),
//                                         child: const Icon(Icons.remove,
//                                             color: Colors.white, size: 18),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     SizedBox(
//                                       width: 40,
//                                       height: 30,
//                                       child: TextField(
//                                         controller: quantityController,
//                                         textAlign: TextAlign.center,
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (value) {
//                                           int newQuantity =
//                                               int.tryParse(value) ?? 1;
//                                           if (newQuantity < 1) {
//                                             newQuantity = 1;
//                                           } else if (newQuantity > item.stock) {
//                                             newQuantity = item.stock;
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(
//                                               const SnackBar(
//                                                   content: Text(
//                                                       "Kuantitas melebihi stok!")),
//                                             );
//                                           }

//                                           // Update quantity setelah pengguna berhenti mengetik selama 500ms
//                                           Future.delayed(
//                                               const Duration(milliseconds: 500),
//                                               () {
//                                             updateQuantity(item.id, newQuantity,
//                                                 item.stock);
//                                           });
//                                         },
//                                         decoration: const InputDecoration(
//                                           border: OutlineInputBorder(),
//                                           contentPadding: EdgeInsets.zero,
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     GestureDetector(
//                                       onTap: () => updateQuantity(item.id,
//                                           item.quantity + 1, item.stock),
//                                       child: Container(
//                                         padding: const EdgeInsets.all(6),
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey[600],
//                                           borderRadius:
//                                               BorderRadius.circular(4),
//                                         ),
//                                         child: const Icon(Icons.add,
//                                             color: Colors.white, size: 18),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//           ),
//           if (cartItems.isNotEmpty) ...[
//             // Container(
//             //   padding: const EdgeInsets.all(10),
//             //   child: Column(
//             //     crossAxisAlignment: CrossAxisAlignment.start,
//             //     children: [
//             //       Row(
//             //         children: [
//             //           const Icon(Icons.local_shipping),
//             //           const SizedBox(width: 10),
//             //           Expanded(
//             //             child: Text(
//             //                 "Shipping Method: ${selectedShippingMethod ?? 'Belum dipilih'}"),
//             //           ),
//             //           TextButton(
//             //             onPressed: showShippingMethodDialog,
//             //             child: const Text("Pilih"),
//             //           ),
//             //         ],
//             //       ),
//             //       const SizedBox(height: 8),
//             //       Row(
//             //         children: [
//             //           const Icon(Icons.payment),
//             //           const SizedBox(width: 10),
//             //           Expanded(
//             //             child: Text(
//             //                 "Payment Method: ${selectedPaymentMethod ?? 'Belum dipilih'}"),
//             //           ),
//             //           TextButton(
//             //             onPressed: showPaymentMethodDialog,
//             //             child: const Text("Pilih"),
//             //           ),
//             //         ],
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             // Container(
//             //   padding: const EdgeInsets.all(10),
//             //   child: Column(
//             //     crossAxisAlignment: CrossAxisAlignment.start,
//             //     children: [
//             //       Row(
//             //         children: [
//             //           const Icon(Icons.local_shipping),
//             //           const SizedBox(width: 10),
//             //           Expanded(
//             //             child: Text(
//             //                 "Shipping Method: ${selectedShippingMethod ?? 'Belum dipilih'}"),
//             //           ),
//             //           TextButton(
//             //             onPressed: showShippingMethodDialog,
//             //             child: const Text("Pilih"),
//             //           ),
//             //         ],
//             //       ),
//             //       const SizedBox(height: 8),
//             //       Row(
//             //         children: [
//             //           const Icon(Icons.payment),
//             //           const SizedBox(width: 10),
//             //           Expanded(
//             //             child: Text(
//             //                 "Payment Method: ${selectedPaymentMethod ?? 'Belum dipilih'}"),
//             //           ),
//             //           TextButton(
//             //             onPressed: showPaymentMethodDialog,
//             //             child: const Text("Pilih"),
//             //           ),
//             //         ],
//             //       ),
//             //       const SizedBox(height: 8),
//             //       Row(
//             //         children: [
//             //           const Text("Subtotal: "),
//             //           Text("Rp ${getTotalPrice().toStringAsFixed(3)}"),
//             //         ],
//             //       ),
//             //       const SizedBox(height: 8),
//             //       Row(
//             //         children: [
//             //           const Text("Biaya Kirim: "),
//             //           Text("Rp ${getShippingCost().toStringAsFixed(3)}"),
//             //         ],
//             //       ),
//             //     ],
//             //   ),
//             // ),

//             // Container(
//             //   padding: const EdgeInsets.all(16),
//             //   color: Colors.grey[600],
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       Row(
//             //         children: [
//             //           const Icon(Icons.account_balance_wallet,
//             //               color: Colors.white),
//             //           const SizedBox(width: 8),
//             //           Text(
//             //             "Total Biaya - Rp${getTotalPayment().toStringAsFixed(3)}",
//             //             style: const TextStyle(
//             //                 fontSize: 18,
//             //                 color: Colors.white,
//             //                 fontWeight: FontWeight.bold),
//             //           ),
//             //         ],
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             // Container(
//             //   width: double.infinity,
//             //   padding: const EdgeInsets.all(10),
//             //   child: ElevatedButton(
//             //     onPressed: () {
//             //       showCheckoutConfirmation(context, checkoutCart);
//             //     },
//             //     style: ElevatedButton.styleFrom(
//             //       backgroundColor: Colors.black,
//             //       padding: const EdgeInsets.symmetric(vertical: 15),
//             //       shape: RoundedRectangleBorder(
//             //         borderRadius: BorderRadius.circular(8),
//             //       ),
//             //     ),
//             //     child: const Text(
//             //       "Checkout",
//             //       style: TextStyle(fontSize: 18, color: Colors.white),
//             //     ),
//             //   ),
//             // )
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 6,
//                     offset: const Offset(0, 2), // Shadow position
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildRow(
//                     icon: Icons.local_shipping,
//                     text:
//                         "Shipping Method: ${selectedShippingMethod ?? 'Belum dipilih'}",
//                     onPressed: showShippingMethodDialog,
//                   ),
//                   const SizedBox(height: 10),
//                   _buildRow(
//                     icon: Icons.payment,
//                     text:
//                         "Payment Method: ${selectedPaymentMethod ?? 'Belum dipilih'}",
//                     onPressed: showPaymentMethodDialog,
//                   ),
//                   const SizedBox(height: 10),
//                   _buildRow(
//                     icon: null,
//                     text: "Subtotal: ${formatCurrency.format(getTotalPrice())}",
//                   ),
//                   const SizedBox(height: 10),
//                   _buildRow(
//                     icon: null,
//                     text:
//                         "Biaya Kirim: ${formatCurrency.format(getShippingCost())}",
//                   ),
//                 ],
//               ),
//             ),

//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[800],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(Icons.account_balance_wallet,
//                           color: Colors.white),
//                       const SizedBox(width: 10),
//                       Text(
//                         "Total Biaya - ${formatCurrency.format(getTotalPayment())}",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//               child: ElevatedButton(
//                 onPressed: () {
//                   showCheckoutConfirmation(context, checkoutCart);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   elevation: 4,
//                 ),
//                 child: const Text(
//                   "Checkout",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

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

  // String selectedShipping = "";
  // String selectedPayment = "";

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

// Fungsi untuk menampilkan pop-up
  // void showShippingMethodDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("Pilih Metode Pengiriman"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: shippingMethods.map((method) {
  //             return RadioListTile<String>(
  //               title: Text(method),
  //               value: method,
  //               groupValue: selectedShippingMethod,
  //               onChanged: (value) async {
  //                 Navigator.pop(context);
  //                 await updateCartField('shipping_method', value);
  //                 setState(() {
  //                   selectedShippingMethod = value;
  //                 });
  //               },
  //             );
  //           }).toList(),
  //         ),
  //       );
  //     },
  //   );
  // }

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
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // void showPaymentMethodDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("Pilih Metode Pembayaran"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: paymentMethods.map((method) {
  //             return RadioListTile<String>(
  //               title: Text(method),
  //               value: method,
  //               groupValue: selectedPaymentMethod,
  //               onChanged: (value) async {
  //                 Navigator.pop(context);
  //                 await updateCartField('payment_method', value);
  //                 setState(() {
  //                   selectedPaymentMethod = value;
  //                 });
  //               },
  //             );
  //           }).toList(),
  //         ),
  //       );
  //     },
  //   );
  // }

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

        // final rawItems =
        //     (data['cart'] as List).map((item) => Cart.fromJson(item)).toList();

        // // Gabungkan item berdasarkan ID produk
        // final Map<int, Cart> groupedItems = {};

        // for (var item in rawItems) {
        //   if (groupedItems.containsKey(item.id)) {
        //     groupedItems[item.id]!.stockByDates.addAll(item.stockByDates);
        //     groupedItems[item.id]!.quantity += item.quantity;
        //   } else {
        //     groupedItems[item.id] = item;
        //   }
        // }

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

  // Future<void> fetchCartItems() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token'); // ambil token dari login

  //   final response = await http.get(
  //     Uri.parse('$responseUrl/api/cart/show'),
  //     headers: {
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token', // penting untuk autentikasi user
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     if (data['success']) {
  //       if (!mounted) return;

  //       final fetchedCartItems =
  //           (data['cart'] as List).map((item) => Cart.fromJson(item)).toList();

  //       setState(() {
  //         cartItems = fetchedCartItems;
  //         mergedCartItems = getMergedCartItems(cartItems); // <= Tambahkan ini!

  //         shippingMethods = List<String>.from(data['shipping_methods'] ?? []);
  //         paymentMethods = List<String>.from(data['payment_methods'] ?? []);

  //         if (cartItems.isNotEmpty) {
  //           selectedShippingMethod = cartItems.first.shippingMethod;
  //           selectedPaymentMethod = cartItems.first.paymentMethod;
  //         } else {
  //           selectedShippingMethod =
  //               shippingMethods.isNotEmpty ? shippingMethods[0] : "";
  //           selectedPaymentMethod =
  //               paymentMethods.isNotEmpty ? paymentMethods[0] : "";
  //         }
  //       });
  //     }
  //   } else {
  //     print("Gagal fetch cart: ${response.statusCode} - ${response.body}");
  //   }
  // }

  // int calculateTotalStock(List<StockByDate> stocks) {
  //   return stocks.fold(0, (sum, s) => sum + s.stock);
  // }

  Future<void> deleteCartItem(int id) async {
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
      Uri.parse('$responseUrl/api/cart/delete/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        cartItems.removeWhere((item) => item.id == id);
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

  Future<void> updateQuantityFIFO(
      List<Cart> originalItems, int newQuantity, int totalStock) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (newQuantity < 1) newQuantity = 1;
    if (newQuantity > totalStock) {
      newQuantity = totalStock;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kuantitas melebihi stok!")),
      );
    }

    int remainingQuantity = newQuantity;

    for (var item in originalItems) {
      int quantityForThisItem =
          remainingQuantity > item.stock ? item.stock : remainingQuantity;
      remainingQuantity -= quantityForThisItem;

      await http.put(
        Uri.parse('$responseUrl/api/cart/update/${item.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'quantity': quantityForThisItem}),
      );

      if (remainingQuantity <= 0) break;
    }

    await fetchCartItems();
  }

  // Future<void> updateQuantityFIFO(
  //     List<Cart> originalItems, int newQuantity, int totalStock) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');

  //   if (newQuantity < 1) newQuantity = 1;
  //   if (newQuantity > totalStock) {
  //     newQuantity = totalStock;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Kuantitas melebihi stok!")),
  //     );
  //   }

  //   int remainingQuantity = newQuantity;

  //   for (var item in originalItems) {
  //     // Urutkan stockDetails berdasarkan expired date (FIFO)
  //     item.stockDetails.sort((a, b) => a.expiredDate.compareTo(b.expiredDate));

  //     for (var detail in item.stockDetails) {
  //       if (remainingQuantity <= 0) break;

  //       int availableStock = detail.stock;
  //       int quantityForThisDetail = remainingQuantity > availableStock
  //           ? availableStock
  //           : remainingQuantity;
  //       remainingQuantity -= quantityForThisDetail;

  //       await http.put(
  //         Uri.parse('$responseUrl/api/cart/update/${item.id}'),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer $token'
  //         },
  //         body: jsonEncode({
  //           'quantity': quantityForThisDetail,
  //           // Jika diperlukan, kirim juga expired_date atau stock_detail_id
  //         }),
  //       );
  //     }

  //     if (remainingQuantity <= 0) break;
  //   }

  //   await fetchCartItems();
  // }

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
        const SnackBar(content: Text("Checkout berhasil!")),
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

  // List<MergedCartItem> getMergedCartItems(List<Cart> items) {
  //   final Map<int, List<Cart>> grouped = {};

  //   for (var item in items) {
  //     grouped.putIfAbsent(item.productId, () => []).add(item);
  //   }

  //   return grouped.entries.map((entry) {
  //     final productItems = entry.value;

  //     // Gabungkan semua stockDetails dari semua Cart
  //     final allStockDetails =
  //         productItems.expand((cart) => cart.stockDetails).toList();

  //     // Sort berdasarkan expiredDate (FIFO)
  //     allStockDetails.sort((a, b) => a.expiredDate.compareTo(b.expiredDate));

  //     return MergedCartItem(
  //       productId: productItems.first.productId,
  //       productName: productItems.first.productName,
  //       productImage: productItems.first.productImage,
  //       productPrice: productItems.first.productPrice,
  //       originalItems: productItems,
  //       totalStock:
  //           allStockDetails.fold(0, (sum, detail) => sum + detail.stock),
  //       quantity:
  //           allStockDetails.fold(0, (sum, detail) => sum + detail.quantity),
  //     );
  //   }).toList();
  // }

  // List<MergedCartItem> getMergedCartItems(List<Cart> items) {
  //   final Map<int, List<Cart>> grouped = {};

  //   for (var item in items) {
  //     grouped.putIfAbsent(item.productId, () => []).add(item);
  //   }

  //   return grouped.entries.map((entry) {
  //     final productItems = entry.value;
  //     productItems.sort(
  //       (a, b) => a.expiredDate!.compareTo(b.expiredDate!)); // FIFO sort

  //     return MergedCartItem(
  //       productId: productItems.first.productId,
  //       productName: productItems.first.productName,
  //       productImage: productItems.first.productImage,
  //       productPrice: productItems.first.productPrice,
  //       originalItems: productItems,
  //       totalStock: productItems.fold(0, (sum, item) => sum + item.stock),
  //       quantity: productItems.fold(0, (sum, item) => sum + item.quantity),
  //     );
  //   }).toList();
  // }

  // Future<void> updateMergedQuantity(
  //     MergedCartItem item, int newQuantity) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');

  //   int remaining = newQuantity;
  //   final items = item.originalItems;

  //   for (var cart in items) {
  //     int qtyToSet = 0;
  //     if (remaining >= cart.stock) {
  //       qtyToSet = cart.stock;
  //     } else {
  //       qtyToSet = remaining;
  //     }

  //     remaining -= qtyToSet;

  //     final response = await http.put(
  //       Uri.parse('$responseUrl/api/cart/update/${cart.id}'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({'quantity': qtyToSet}),
  //     );

  //     if (response.statusCode != 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text("Gagal memperbarui salah satu kuantitas")),
  //       );
  //     }

  //     if (remaining <= 0) break;
  //   }

  //   fetchCartItems(); // refresh total data
  // }

  // Future<void> updateMergedQuantity(MergedCartItem item, int newQuantity) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');

  //   int remaining = newQuantity;
  //   final items = item.originalItems;

  //   for (var cart in items) {
  //     if (remaining <= 0) break;

  //     int qtyToSet = 0;
  //     if (remaining >= cart.stock) {
  //       qtyToSet = cart.stock;
  //     } else {
  //       qtyToSet = remaining;
  //     }

  //     remaining -= qtyToSet;

  //     final response = await http.put(
  //       Uri.parse('$responseUrl/api/cart/update/${cart.id}'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({'quantity': qtyToSet}),
  //     );

  //     if (response.statusCode != 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Gagal memperbarui salah satu kuantitas")),
  //       );
  //     }
  //   }

  //   fetchCartItems(); // refresh total data
  // }

  double getTotalPrice() {
    return cartItems.fold(0, (sum, item) => sum + item.grossAmount);
  }

  @override
  Widget build(BuildContext context) {
    final mergedCartItems = getMergedCartItems(cartItems);
    return Scaffold(
      // appBar: AppBar(title: const Text("Cart")),
      appBar: AppBar(
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
                              child: Image.network(
                                "$responseUrl/storage/${item.productImage}",
                                width: 50,
                                height: 50,
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
                                      deleteCartItem(item.id);
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
                                      // onTap: () => updateQuantity(item.id,
                                      //     item.quantity - 1, item.stock),

                                      // onTap: () => updateQuantity(
                                      //     item.originalItems.first.id,
                                      //     item.originalItems.first.quantity - 1,
                                      //     item.originalItems.first.stock),

                                      onTap: () => updateQuantityFIFO(
                                        item.originalItems,
                                        item.quantity - 1,
                                        item.totalStock,
                                      ),
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
                                        // onChanged: (value) {
                                        //   int newQuantity =
                                        //       int.tryParse(value) ?? 1;
                                        //   if (newQuantity < 1) {
                                        //     newQuantity = 1;
                                        //   } else if (newQuantity >
                                        //       item.totalStock) {
                                        //     newQuantity = item.totalStock;
                                        //     ScaffoldMessenger.of(context)
                                        //         .showSnackBar(
                                        //       const SnackBar(
                                        //           content: Text(
                                        //               "Kuantitas melebihi stok!")),
                                        //     );
                                        //   }

                                        //   // Update quantity setelah pengguna berhenti mengetik selama 500ms
                                        //   Future.delayed(
                                        //       const Duration(milliseconds: 500),
                                        //       () {
                                        //     updateQuantity(item.id, newQuantity,
                                        //         item.totalStock);
                                        //   });
                                        // },

                                        onChanged: (value) {
                                          int newQuantity =
                                              int.tryParse(value) ?? 1;
                                          if (newQuantity < 1) newQuantity = 1;
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

                                      onTap: () => updateQuantityFIFO(
                                        item.originalItems,
                                        item.quantity + 1,
                                        item.totalStock,
                                      ),
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

          // Expanded(
          //   child: mergedCartItems.isEmpty
          //       ? const Center(child: Text("Cart is empty"))
          //       : ListView.builder(
          //           itemCount: mergedCartItems.length,
          //           itemBuilder: (context, index) {
          //             final item = mergedCartItems[index];
          //             TextEditingController quantityController =
          //                 TextEditingController(text: item.quantity.toString());

          //             return Container(
          //               margin: const EdgeInsets.symmetric(
          //                   horizontal: 12, vertical: 6),
          //               padding: const EdgeInsets.all(10),
          //               decoration: BoxDecoration(
          //                 color: Colors.grey[300],
          //                 borderRadius: BorderRadius.circular(8),
          //               ),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   Container(
          //                     width: 80,
          //                     height: 80,
          //                     decoration: BoxDecoration(
          //                       color: Colors.grey[400],
          //                       borderRadius: BorderRadius.circular(8),
          //                     ),
          //                     child: Image.network(
          //                       "$responseUrl/storage/${item.productImage}",
          //                       fit: BoxFit.cover,
          //                     ),
          //                   ),
          //                   const SizedBox(width: 12),
          //                   Expanded(
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text(item.productName,
          //                             style: const TextStyle(
          //                                 fontSize: 16,
          //                                 fontWeight: FontWeight.bold)),
          //                         Text(
          //                             "Price  : ${formatCurrency.format(item.productPrice)}"),
          //                         Text(
          //                             "Total  : ${formatCurrency.format(item.productPrice * item.quantity)}"),
          //                         Text("Total Stock : ${item.totalStock}",
          //                             style: const TextStyle(
          //                                 color: Colors.green,
          //                                 fontWeight: FontWeight.bold)),
          //                       ],
          //                     ),
          //                   ),
          //                   Column(
          //                     children: [
          //                       GestureDetector(
          //                         onTap: () {
          //                           for (var original in item.originalItems) {
          //                             deleteCartItem(original.id);
          //                           }
          //                         },
          //                         child: Container(
          //                           padding: const EdgeInsets.all(4),
          //                           decoration: BoxDecoration(
          //                             color: Colors.red,
          //                             borderRadius: BorderRadius.circular(4),
          //                           ),
          //                           child: const Icon(Icons.delete,
          //                               color: Colors.white, size: 18),
          //                         ),
          //                       ),
          //                       const SizedBox(height: 8),
          //                       Row(
          //                         children: [
          //                           GestureDetector(
          //                             onTap: () {
          //                               int newQty = item.quantity - 1;
          //                               if (newQty < 1) newQty = 1;
          //                               updateMergedQuantity(item, newQty);
          //                             },
          //                             child: Container(
          //                               padding: const EdgeInsets.all(6),
          //                               decoration: BoxDecoration(
          //                                 color: Colors.grey[600],
          //                                 borderRadius:
          //                                     BorderRadius.circular(4),
          //                               ),
          //                               child: const Icon(Icons.remove,
          //                                   color: Colors.white, size: 18),
          //                             ),
          //                           ),
          //                           const SizedBox(width: 8),
          //                           SizedBox(
          //                             width: 40,
          //                             height: 30,
          //                             child: TextField(
          //                               controller: quantityController,
          //                               textAlign: TextAlign.center,
          //                               keyboardType: TextInputType.number,
          //                               onChanged: (value) {
          //                                 int newQty = int.tryParse(value) ?? 1;
          //                                 if (newQty > item.totalStock) {
          //                                   newQty = item.totalStock;
          //                                   ScaffoldMessenger.of(context)
          //                                       .showSnackBar(
          //                                     const SnackBar(
          //                                         content: Text(
          //                                             "Kuantitas melebihi stok")),
          //                                   );
          //                                 }
          //                                 Future.delayed(
          //                                     const Duration(milliseconds: 500),
          //                                     () => updateMergedQuantity(
          //                                         item, newQty));
          //                               },
          //                               decoration: const InputDecoration(
          //                                 border: OutlineInputBorder(),
          //                                 contentPadding: EdgeInsets.zero,
          //                               ),
          //                             ),
          //                           ),
          //                           const SizedBox(width: 8),
          //                           GestureDetector(
          //                             onTap: () {
          //                               int newQty = item.quantity + 1;
          //                               if (newQty > item.totalStock) {
          //                                 newQty = item.totalStock;
          //                                 ScaffoldMessenger.of(context)
          //                                     .showSnackBar(
          //                                   const SnackBar(
          //                                       content: Text(
          //                                           "Kuantitas melebihi stok")),
          //                                 );
          //                               } else {
          //                                 updateMergedQuantity(item, newQty);
          //                               }
          //                             },
          //                             child: Container(
          //                               padding: const EdgeInsets.all(6),
          //                               decoration: BoxDecoration(
          //                                 color: Colors.grey[600],
          //                                 borderRadius:
          //                                     BorderRadius.circular(4),
          //                               ),
          //                               child: const Icon(Icons.add,
          //                                   color: Colors.white, size: 18),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             );
          //           },
          //         ),
          // ),

          if (cartItems.isNotEmpty) ...[
            // Container(
            //   padding: const EdgeInsets.all(10),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         children: [
            //           const Icon(Icons.local_shipping),
            //           const SizedBox(width: 10),
            //           Expanded(
            //             child: Text(
            //                 "Shipping Method: ${selectedShippingMethod ?? 'Belum dipilih'}"),
            //           ),
            //           TextButton(
            //             onPressed: showShippingMethodDialog,
            //             child: const Text("Pilih"),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 8),
            //       Row(
            //         children: [
            //           const Icon(Icons.payment),
            //           const SizedBox(width: 10),
            //           Expanded(
            //             child: Text(
            //                 "Payment Method: ${selectedPaymentMethod ?? 'Belum dipilih'}"),
            //           ),
            //           TextButton(
            //             onPressed: showPaymentMethodDialog,
            //             child: const Text("Pilih"),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   padding: const EdgeInsets.all(10),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         children: [
            //           const Icon(Icons.local_shipping),
            //           const SizedBox(width: 10),
            //           Expanded(
            //             child: Text(
            //                 "Shipping Method: ${selectedShippingMethod ?? 'Belum dipilih'}"),
            //           ),
            //           TextButton(
            //             onPressed: showShippingMethodDialog,
            //             child: const Text("Pilih"),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 8),
            //       Row(
            //         children: [
            //           const Icon(Icons.payment),
            //           const SizedBox(width: 10),
            //           Expanded(
            //             child: Text(
            //                 "Payment Method: ${selectedPaymentMethod ?? 'Belum dipilih'}"),
            //           ),
            //           TextButton(
            //             onPressed: showPaymentMethodDialog,
            //             child: const Text("Pilih"),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 8),
            //       Row(
            //         children: [
            //           const Text("Subtotal: "),
            //           Text("Rp ${getTotalPrice().toStringAsFixed(3)}"),
            //         ],
            //       ),
            //       const SizedBox(height: 8),
            //       Row(
            //         children: [
            //           const Text("Biaya Kirim: "),
            //           Text("Rp ${getShippingCost().toStringAsFixed(3)}"),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            // Container(
            //   padding: const EdgeInsets.all(16),
            //   color: Colors.grey[600],
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         children: [
            //           const Icon(Icons.account_balance_wallet,
            //               color: Colors.white),
            //           const SizedBox(width: 8),
            //           Text(
            //             "Total Biaya - Rp${getTotalPayment().toStringAsFixed(3)}",
            //             style: const TextStyle(
            //                 fontSize: 18,
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(10),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       showCheckoutConfirmation(context, checkoutCart);
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.black,
            //       padding: const EdgeInsets.symmetric(vertical: 15),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //     child: const Text(
            //       "Checkout",
            //       style: TextStyle(fontSize: 18, color: Colors.white),
            //     ),
            //   ),
            // )
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
                  Row(
                    children: [
                      const Icon(Icons.account_balance_wallet,
                          color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        "Total Biaya - ${formatCurrency.format(getTotalPayment())}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_c14210052/constant/api_url.dart';
// import 'package:ta_c14210052/models/cart.dart';
// import 'dart:convert';

// import 'package:ta_c14210052/models/merged_cart_item.dart';

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   _CartPageState createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   List<Cart> cartItems =
//       []; // String selectedShipping = ""; // String selectedPayment = "";

//   String? selectedShippingMethod;
//   String? selectedPaymentMethod;

//   List<String> shippingOptions = [];
//   List<String> paymentOptions = [];

//   List<String> shippingMethods = ['Reguler', 'Express', 'Ambil di tempat'];
//   List<String> paymentMethods = ['Cash', 'Bank Transfer', 'OVO', 'Dana', 'COD'];

//   final formatCurrency =
//       NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2);

//   @override
//   void initState() {
//     super.initState();
//     fetchCartItems();
//   }

//   double getShippingCost() {
//     switch (selectedShippingMethod) {
//       case 'Reguler':
//         return 1750.0;
//       case 'Express':
//         return 3500.0;
//       case 'Ambil di tempat':
//       default:
//         return 0.0;
//     }
//   }

//   double getTotalPayment() {
//     return getTotalPrice() + getShippingCost();
//   }

// // Fungsi untuk menampilkan pop-up

//   void showShippingMethodDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Pilih Metode Pengiriman"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: shippingMethods.map((method) {
//               return RadioListTile<String>(
//                 title: Text(method),
//                 value: method,
//                 groupValue: selectedShippingMethod,
//                 onChanged: (value) async {
//                   Navigator.pop(context);
//                   await updateCartField('shipping_method', value);
//                   setState(() {
//                     selectedShippingMethod = value;

// // Jika metode pengiriman adalah "Ambil di tempat", kembalikan metode pembayaran ke default
//                     if (selectedShippingMethod == 'Ambil di tempat') {
//                       selectedPaymentMethod = paymentMethods
//                           .firstWhere((method) => method != 'COD');
//                       updateCartField('payment_method', selectedPaymentMethod);
//                     }
//                   });
//                 },
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }

//   void showPaymentMethodDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Pilih Metode Pembayaran"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: paymentMethods
//                 .where((method) => !(method == 'COD' &&
//                     selectedShippingMethod == 'Ambil di tempat'))
//                 .map((method) {
//               return RadioListTile<String>(
//                 title: Text(method),
//                 value: method,
//                 groupValue: selectedPaymentMethod,
//                 onChanged: (value) async {
//                   Navigator.pop(context);
//                   await updateCartField('payment_method', value);
//                   setState(() {
//                     selectedPaymentMethod = value;
//                   });
//                 },
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> updateCartField(String field, String? value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Token tidak ditemukan, silakan login ulang")),
//       );
//       return;
//     }

//     final url = Uri.parse('$responseUrl/api/cart/update-field');
//     final response = await http.patch(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token', // Tambahkan token di sini
//       },
//       body: jsonEncode({
//         'field': field,
//         'value': value,
//       }),
//     );

//     if (response.statusCode != 200) {
//       final data = jsonDecode(response.body);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text("Gagal memperbarui cart: ${data['message'] ?? ''}")),
//       );
//     }
//   }

// // Helper widget to build rows
//   Widget _buildRow(
//       {IconData? icon, required String text, VoidCallback? onPressed}) {
//     return Row(
//       children: [
//         if (icon != null) ...[
//           Icon(icon),
//           const SizedBox(width: 10),
//         ],
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(
//               fontSize: 16,
//               color: Colors.black,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         if (onPressed != null) ...[
//           TextButton(
//             onPressed: onPressed,
//             child: const Text(
//               "Pilih",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.blue,
//               ),
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   Future<void> fetchCartItems() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token'); // ambil token dari login

//     final response = await http.get(
//       Uri.parse('$responseUrl/api/cart/show'),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token', // penting untuk autentikasi user
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['success']) {
//         if (!mounted) return;

//         // final rawItems =
//         //     (data['cart'] as List).map((item) => Cart.fromJson(item)).toList();

//         // // Gabungkan item berdasarkan ID produk
//         // final Map<int, Cart> groupedItems = {};

//         // for (var item in rawItems) {
//         //   if (groupedItems.containsKey(item.id)) {
//         //     groupedItems[item.id]!.stockByDates.addAll(item.stockByDates);
//         //     groupedItems[item.id]!.quantity += item.quantity;
//         //   } else {
//         //     groupedItems[item.id] = item;
//         //   }
//         // }

//         setState(() {
//           cartItems = (data['cart'] as List)
//               .map((item) => Cart.fromJson(item))
//               .toList();

//           // cartItems = groupedItems.values.toList();

//           shippingMethods = List<String>.from(data['shipping_methods'] ?? []);
//           paymentMethods = List<String>.from(data['payment_methods'] ?? []);

//           if (cartItems.isNotEmpty) {
//             selectedShippingMethod = cartItems.first.shippingMethod;
//             selectedPaymentMethod = cartItems.first.paymentMethod;
//           } else {
//             selectedShippingMethod =
//                 shippingMethods.isNotEmpty ? shippingMethods[0] : "";
//             selectedPaymentMethod =
//                 paymentMethods.isNotEmpty ? paymentMethods[0] : "";
//           }
//         });
//       }
//     } else {
//       print("Gagal fetch cart: ${response.statusCode} - ${response.body}");
//     }
//   }

// // int calculateTotalStock(List<StockByDate> stocks) { // return stocks.fold(0, (sum, s) => sum + s.stock); // }

//   Future<void> deleteCartItem(int id) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Token tidak ditemukan, silakan login ulang")),
//       );
//       return;
//     }

//     final response = await http.delete(
//       Uri.parse('$responseUrl/api/cart/delete/$id'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         cartItems.removeWhere((item) => item.id == id);
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Item removed from cart")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Gagal menghapus item")),
//       );
//     }
//   }

  // Future<void> updateQuantity(int id, int newQuantity, int stock) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');

  //   if (newQuantity < 1) newQuantity = 1;
  //   if (newQuantity > stock) {
  //     newQuantity = stock;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Kuantitas melebihi stok!")),
  //     );
  //   }

  //   final response = await http.put(
  //     Uri.parse('$responseUrl/api/cart/update/$id'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token'
  //     }, // Tambahkan token di sini},
  //     body: jsonEncode({'quantity': newQuantity}),
  //   );

  //   if (response.statusCode == 200) {
  //     fetchCartItems();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Gagal memperbarui kuantitas")),
  //     );
  //   }
  // }

//   void showCheckoutConfirmation(BuildContext context, Function onConfirm) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text("Confirmation"),
//           content: const Text("Are you sure to do this transaction?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext)
//                     .pop(); // Tutup pop-up tanpa melakukan checkout
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.grey, // Warna abu-abu untuk "No"
//               ),
//               child: const Text("No"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
// // Tutup pop-up
//                 onConfirm(); // Jalankan checkoutCart
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.red, // Warna merah untuk "Yes"
//               ),
//               child: const Text("Yes"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> checkoutCart() async {
//     if (cartItems.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Keranjang kosong, tidak bisa checkout")),
//       );
//       return;
//     }

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Tidak ada token, silakan login ulang")),
//       );
//       return;
//     }

//     final response = await http.post(
//       Uri.parse('$responseUrl/api/cart/checkout'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 201) {
//       setState(() {
//         cartItems.clear();
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Checkout berhasil!")),
//       );
//     } else {
//       final data = jsonDecode(response.body);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(data['message'] ?? "Checkout gagal")),
//       );
//     }
//   }

//   List<MergedCartItem> getMergedCartItems(List<Cart> items) {
//     final Map<int, List<Cart>> grouped = {};

//     for (var item in items) {
//       grouped.putIfAbsent(item.productId, () => []).add(item);
//     }

//     return grouped.entries.map((entry) {
//       final productItems = entry.value;
//       productItems.sort(
//           (a, b) => a.expiredDate!.compareTo(b.expiredDate!)); // FIFO sort

//       return MergedCartItem(
//         productId: productItems.first.productId,
//         productName: productItems.first.productName,
//         productImage: productItems.first.productImage,
//         productPrice: productItems.first.productPrice,
//         originalItems: productItems,
//         totalStock: productItems.fold(0, (sum, item) => sum + item.stock),
//         quantity: productItems.fold(0, (sum, item) => sum + item.quantity),
//       );
//     }).toList();
//   }

//   Future<void> updateMergedQuantity(
//       MergedCartItem item, int newQuantity) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     int remaining = newQuantity;
//     final items = item.originalItems;

//     for (var cart in items) {
//       int qtyToSet = 0;
//       if (remaining >= cart.stock) {
//         qtyToSet = cart.stock;
//       } else {
//         qtyToSet = remaining;
//       }

//       remaining -= qtyToSet;

//       final response = await http.put(
//         Uri.parse('$responseUrl/api/cart/update/${cart.id}'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({'quantity': qtyToSet}),
//       );

//       if (response.statusCode != 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text("Gagal memperbarui salah satu kuantitas")),
//         );
//       }

//       if (remaining <= 0) break;
//     }

//     fetchCartItems(); // refresh total data
//   }

//   double getTotalPrice() {
//     return cartItems.fold(0, (sum, item) => sum + item.grossAmount);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mergedCartItems = getMergedCartItems(cartItems);
//     return Scaffold(
//       // appBar: AppBar(title: const Text("Cart")),
//       appBar: AppBar(
//         title: const Text('Cart',
//             style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: mergedCartItems.isEmpty
//                 ? const Center(child: Text("Cart is empty"))
//                 : ListView.builder(
//                     itemCount: cartItems.length,
//                     itemBuilder: (context, index) {
//                       final item = cartItems[index];
//                       TextEditingController quantityController =
//                           TextEditingController(text: item.quantity.toString());

//                       return Container(
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               width: 80,
//                               height: 80,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[400],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Image.network(
//                                 "$responseUrl/storage/${item.productImage}",
//                                 width: 50,
//                                 height: 50,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.productName,
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                       "Price  : ${formatCurrency.format(item.productPrice)}"),
//                                   Text(
//                                       "Total  : ${formatCurrency.format(item.grossAmount)}"),
//                                   Text(
//                                       "Expired : ${item.expiredDate != null ? DateFormat('yyyy-MM-dd').format(item.expiredDate!) : 'N/A'}"),
//                                   Text("Stock  : ${item.stock}",
//                                       style: const TextStyle(
//                                           color: Colors.green,
//                                           fontWeight: FontWeight.bold)),
//                                 ],
//                               ),
//                             ),
//                             Column(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       // cartItems.removeAt(index);
//                                       deleteCartItem(item.id);
//                                     });
//                                   },
//                                   child: Container(
//                                     padding: const EdgeInsets.all(4),
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                     child: const Icon(Icons.delete,
//                                         color: Colors.white, size: 18),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Row(
//                                   children: [
//                                     GestureDetector(
//                                       onTap: () => updateQuantity(item.id,
//                                           item.quantity - 1, item.stock),
//                                       child: Container(
//                                         padding: const EdgeInsets.all(6),
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey[600],
//                                           borderRadius:
//                                               BorderRadius.circular(4),
//                                         ),
//                                         child: const Icon(Icons.remove,
//                                             color: Colors.white, size: 18),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     SizedBox(
//                                       width: 40,
//                                       height: 30,
//                                       child: TextField(
//                                         controller: quantityController,
//                                         textAlign: TextAlign.center,
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (value) {
//                                           int newQuantity =
//                                               int.tryParse(value) ?? 1;
//                                           if (newQuantity < 1) {
//                                             newQuantity = 1;
//                                           } else if (newQuantity > item.stock) {
//                                             newQuantity = item.stock;
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(
//                                               const SnackBar(
//                                                   content: Text(
//                                                       "Kuantitas melebihi stok!")),
//                                             );
//                                           }

//                                           // Update quantity setelah pengguna berhenti mengetik selama 500ms
//                                           Future.delayed(
//                                               const Duration(milliseconds: 500),
//                                               () {
//                                             updateQuantity(item.id, newQuantity,
//                                                 item.stock);
//                                           });
//                                         },
//                                         decoration: const InputDecoration(
//                                           border: OutlineInputBorder(),
//                                           contentPadding: EdgeInsets.zero,
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     GestureDetector(
//                                       onTap: () => updateQuantity(item.id,
//                                           item.quantity + 1, item.stock),
//                                       child: Container(
//                                         padding: const EdgeInsets.all(6),
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey[600],
//                                           borderRadius:
//                                               BorderRadius.circular(4),
//                                         ),
//                                         child: const Icon(Icons.add,
//                                             color: Colors.white, size: 18),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//           ),
//           if (cartItems.isNotEmpty) ...[
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 6,
//                     offset: const Offset(0, 2), // Shadow position
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildRow(
//                     icon: Icons.local_shipping,
//                     text:
//                         "Shipping Method: ${selectedShippingMethod ?? 'Belum dipilih'}",
//                     onPressed: showShippingMethodDialog,
//                   ),
//                   const SizedBox(height: 10),
//                   _buildRow(
//                     icon: Icons.payment,
//                     text:
//                         "Payment Method: ${selectedPaymentMethod ?? 'Belum dipilih'}",
//                     onPressed: showPaymentMethodDialog,
//                   ),
//                   const SizedBox(height: 10),
//                   _buildRow(
//                     icon: null,
//                     text: "Subtotal: ${formatCurrency.format(getTotalPrice())}",
//                   ),
//                   const SizedBox(height: 10),
//                   _buildRow(
//                     icon: null,
//                     text:
//                         "Biaya Kirim: ${formatCurrency.format(getShippingCost())}",
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[800],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(Icons.account_balance_wallet,
//                           color: Colors.white),
//                       const SizedBox(width: 10),
//                       Text(
//                         "Total Biaya - ${formatCurrency.format(getTotalPayment())}",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//               child: ElevatedButton(
//                 onPressed: () {
//                   showCheckoutConfirmation(context, checkoutCart);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   elevation: 4,
//                 ),
//                 child: const Text(
//                   "Checkout",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
