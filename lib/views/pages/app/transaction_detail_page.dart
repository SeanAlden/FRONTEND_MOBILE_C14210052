// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:ta_c14210052/constant/api_url.dart';
// // import 'package:ta_c14210052/models/transaction.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:intl/intl.dart';
// // import 'package:ta_c14210052/views/pages/app/transaction_status_detail_page.dart';

// // class TransactionDetailPage extends StatefulWidget {
// //   final int transactionId;

// //   const TransactionDetailPage({super.key, required this.transactionId});

// //   @override
// //   State<TransactionDetailPage> createState() => _TransactionDetailPageState();
// // }

// // class _TransactionDetailPageState extends State<TransactionDetailPage> {
// //   late Future<Transaction> transactionFuture;

// //   @override
// //   void initState() {
// //     super.initState();
// //     transactionFuture = fetchTransactionDetail(widget.transactionId);
// //   }

// //   Future<Transaction> fetchTransactionDetail(int id) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString('token');
// //     final response = await http.get(
// //       Uri.parse('$responseUrl/api/transactions/$id'),
// //       headers: {
// //         'Authorization': 'Bearer $token',
// //         'Accept': 'application/json',
// //       },
// //     );

// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       return Transaction.fromJson(data);
// //     } else {
// //       throw Exception('Gagal memuat detail transaksi.');
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       // appBar: AppBar(
// //       //   title: const Text("Detail Transaksi"),
// //       // ),
// //       appBar: AppBar(
// //         title: const Text('Transaction Detail',
// //             style: TextStyle(
// //                 fontSize: 22,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white)),
// //         centerTitle: true,
// //         backgroundColor: Colors.blue,
// //       ),
// //       body: FutureBuilder<Transaction>(
// //         future: transactionFuture,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
// //           } else if (!snapshot.hasData) {
// //             return const Center(child: Text("Data tidak tersedia."));
// //           }

// //           final transaction = snapshot.data!;
// //           final formatCurrency =
// //               NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
// //           final formatDate = DateFormat('dd MMM yyyy, HH:mm');

// //           return SingleChildScrollView(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text("Kode Transaksi: ${transaction.transactionCode ?? '-'}",
// //                     style: const TextStyle(fontSize: 16)),
// //                 Text("Karyawan: ${transaction.userName ?? '-'}",
// //                     style: const TextStyle(fontSize: 16)),
// //                 Text(
// //                     "Time: ${transaction.transactionDate != null ? formatDate.format(transaction.transactionDate) : '-'}"),
// //                 GestureDetector(
// //                   onTap: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (context) => TransactionStatusDetailPage(
// //                           transactionId:
// //                               widget.transactionId, // << ini yang kurang
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                   child:
// //                       Text("Status: ${transaction.status ?? '-'}",
// //                           style: const TextStyle(
// //                               fontSize: 16, fontWeight: FontWeight.bold)),
// //                 ),
// //                 const SizedBox(height: 8),

// //                 const SizedBox(height: 8),

// //                 const SizedBox(height: 8),

// //                 const Divider(height: 32),
// //                 const Text("Daftar Produk",
// //                     style:
// //                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //                 const SizedBox(height: 8),
// //                 ...transaction.details.map((detail) => Card(
// //                       elevation: 2,
// //                       margin: const EdgeInsets.symmetric(vertical: 8),
// //                       child: ListTile(
// //                         leading:
// //                             detail.photo != null && detail.photo!.isNotEmpty
// //                                 ? Image.network(
// //                                     '$responseUrl/storage/${detail.photo}',
// //                                     width: 50,
// //                                     height: 50,
// //                                     fit: BoxFit.cover)
// //                                 :
// //                                 Image.asset('assets/images/product.png',
// //                                     width: 50, height: 50, fit: BoxFit.cover),
// //                         title: Text('${detail.name} (${detail.code})' ?? '-'),
// //                         subtitle: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text("Harga: ${formatCurrency.format(detail.price ?? 0)}"),
// //                             Text("Jumlah: ${detail.quantity ?? 0}"),
// //                             Text(
// //                                 "Total: ${formatCurrency.format((detail.quantity ?? 0) * (detail.price ?? 0))}"),
// //                           ],
// //                         ),
// //                       ),
// //                     )),
// //                 const SizedBox(height: 8),
// //                 const Divider(height: 32),
// //                 const Text("Shipping Method",
// //                     style:
// //                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //                 const SizedBox(height: 8),

// //                 Text("${transaction.shippingMethod ?? '-'}"),
// //                 const SizedBox(height: 8),
// //                 Text("${transaction.shippingTime ?? '-'}"),

// //                 const SizedBox(height: 8),

// //                 const Divider(height: 32),

// //                 const Text("Rincian Belanja",
// //                     style:
// //                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //                 Text("Metode Pembayaran: ${transaction.paymentMethod ?? '-'}"),
// //                 const SizedBox(height: 16),
// //                 Text(
// //                     "Biaya Pengiriman: ${formatCurrency.format(transaction.shippingCost ?? 0)}"),
// //                 Text(
// //                     "Total Biaya Produk: ${formatCurrency.format(transaction.grossAmount ?? 0)}"),
// //                 Text(
// //                     "Total Pembayaran: ${formatCurrency.format(transaction.totalPayment ?? 0)}"),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_c14210052/constant/api_url.dart';
// import 'package:ta_c14210052/models/transaction.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'package:ta_c14210052/views/pages/app/transaction_status_detail_page.dart';

// class TransactionDetailPage extends StatefulWidget {
//   final int transactionId;

//   const TransactionDetailPage({super.key, required this.transactionId});

//   @override
//   State<TransactionDetailPage> createState() => _TransactionDetailPageState();
// }

// class _TransactionDetailPageState extends State<TransactionDetailPage> {
//   late Future<Transaction> transactionFuture;

//   @override
//   void initState() {
//     super.initState();
//     transactionFuture = fetchTransactionDetail(widget.transactionId);
//   }

//   Future<Transaction> fetchTransactionDetail(int id) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');
//     final response = await http.get(
//       Uri.parse('$responseUrl/api/transactions/$id'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return Transaction.fromJson(data);
//     } else {
//       throw Exception('Gagal memuat detail transaksi.');
//     }
//   }

//   Color getStatusColor(String status) {
//     switch (status) {
//       case 'Pesanan selesai':
//       case 'Pembayaran lunas':
//         return Colors.green;
//       case 'Belum bayar':
//       case 'Dibatalkan':
//       case 'Pembayaran gagal':
//         return Colors.red;
//       case 'Dalam perjalanan':
//       case 'Proses pembatalan':
//       case 'Pengiriman gagal':
//         return Colors.orange;
//       case 'Pesanan sampai':
//       case 'Pesanan selesai dikemas':
//       case 'Dalam pengemasan':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Transaction Detail',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: FutureBuilder<Transaction>(
//         future: transactionFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
//           } else if (!snapshot.hasData) {
//             return const Center(child: Text("Data tidak tersedia."));
//           }

//           final transaction = snapshot.data!;
//           final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
//           final formatDate = DateFormat('dd MMM yyyy, HH:mm');

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Kode Transaksi: ${transaction.transactionCode ?? '-'}", style: const TextStyle(fontSize: 16)),
//                 Text("Karyawan: ${transaction.userName ?? '-'}", style: const TextStyle(fontSize: 16)),
//                 Text("Time: ${transaction.transactionDate != null ? formatDate.format(transaction.transactionDate) : '-'}"),

//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => TransactionStatusDetailPage(
//                           transactionId: widget.transactionId,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                     decoration: BoxDecoration(
//                       color: getStatusColor(transaction.status ?? 'Unknown'),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Status: ${transaction.status ?? '-'}",
//                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                         ),
//                         const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Divider(height: 32),
//                 const Text("Daftar Produk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 ...transaction.details.map((detail) => Card(
//                   elevation: 2,
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   child: ListTile(
//                     leading: detail.photo != null && detail.photo!.isNotEmpty
//                         ? Image.network(
//                             '$responseUrl/storage/${detail.photo}',
//                             width: 50,
//                             height: 50,
//                             fit: BoxFit.cover,
//                           )
//                         : Image.asset('assets/images/product.png', width: 50, height: 50, fit: BoxFit.cover),
//                     title: Text('${detail.name} (${detail.code})' ?? '-'),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Harga: ${formatCurrency.format(detail.price ?? 0)}"),
//                         Text("Jumlah: ${detail.quantity ?? 0}"),
//                         Text("Total: ${formatCurrency.format((detail.quantity ?? 0) * (detail.price ?? 0))}"),
//                       ],
//                     ),
//                   ),
//                 )),
//                 const SizedBox(height: 8),
//                 const Divider(height: 32),
//                 const Text("Shipping Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 Text("${transaction.shippingMethod ?? '-'}"),
//                 const SizedBox(height: 8),
//                 Text("${transaction.shippingTime ?? '-'}"),
//                 const SizedBox(height: 16),
//                 const Divider(height: 32),
//                 const Text("Rincian Belanja", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 Text("Metode Pembayaran: ${transaction.paymentMethod ?? '-'}"),
//                 const SizedBox(height: 16),
//                 Text("Biaya Pengiriman: ${formatCurrency.format(transaction.shippingCost ?? 0)}"),
//                 Text("Total Biaya Produk: ${formatCurrency.format(transaction.grossAmount ?? 0)}"),
//                 Text("Total Pembayaran: ${formatCurrency.format(transaction.totalPayment ?? 0)}"),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_c14210052/constant/api_url.dart';
// import 'package:ta_c14210052/models/transaction.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'package:ta_c14210052/views/pages/app/transaction_status_detail_page.dart';
// import 'package:flutter/widgets.dart'; // untuk RouteObserver

// class TransactionDetailPage extends StatefulWidget {
//   final int transactionId;

//   const TransactionDetailPage({super.key, required this.transactionId});

//   @override
//   State<TransactionDetailPage> createState() => _TransactionDetailPageState();
// }

// class _TransactionDetailPageState extends State<TransactionDetailPage>
//     with RouteAware {
//   late Future<Transaction> transactionFuture;
//   final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
//   }

//   @override
//   void dispose() {
//     routeObserver.unsubscribe(this);
//     super.dispose();
//   }

// // Akan dipanggil ketika kembali ke halaman ini
//   @override
//   void didPopNext() {
//     setState(() {
//       super.initState();
//       transactionFuture = fetchTransactionDetail(widget.transactionId);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     transactionFuture = fetchTransactionDetail(widget.transactionId);
//   }

//   Future<Transaction> fetchTransactionDetail(int id) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');
//     final response = await http.get(
//       Uri.parse('$responseUrl/api/transactions/$id'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return Transaction.fromJson(data);
//     } else {
//       throw Exception('Gagal memuat detail transaksi.');
//     }
//   }

//   Color getStatusColor(String status) {
//     switch (status) {
//       // case 'Pesanan selesai':
//       // case 'Pembayaran lunas':
//       //   return Colors.green;
//       // case 'Belum bayar':
//       // case 'Dibatalkan':
//       // case 'Pembayaran gagal':
//       //   return Colors.red;
//       // case 'Dalam perjalanan':
//       // case 'Proses pembatalan':
//       // case 'Pengiriman gagal':
//       //   return Colors.orange;
//       // case 'Pesanan sampai':
//       // case 'Pesanan selesai dikemas':
//       // case 'Dalam pengemasan':
//       //   return Colors.blue;
//       // default:
//       //   return Colors.grey;

//       case 'Pembayaran lunas':
//       case 'Pesanan sampai':
//       case 'Pesanan selesai dikemas':
//         return Colors.blue;
//       case 'Pesanan selesai':
//       case 'Pembatalan berhasil':
//         return Colors.green;
//       case 'Belum bayar':
//       case 'Dalam perjalanan':
//       case 'Dalam pengemasan':
//       case 'Proses pembatalan':
//         return Colors.orange;
//       case 'Pembayaran gagal':
//       case 'Dibatalkan':
//       case 'Pengiriman gagal':
//         return Colors.red;
//       default:
//         return Colors.black87; // Default warna
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Transaction Detail',
//           style: TextStyle(
//               fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: FutureBuilder<Transaction>(
//         future: transactionFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
//           } else if (!snapshot.hasData) {
//             return const Center(child: Text("Data tidak tersedia."));
//           }

//           final transaction = snapshot.data!;
//           final formatCurrency =
//               NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
//           final formatDate = DateFormat('dd MMM yyyy, HH:mm');

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Transaction Info
//                 _buildTransactionInfo(transaction, formatDate),

//                 // Status Block
//                 _buildStatusBlock(transaction),

//                 const Divider(height: 32),

//                 // Product List
//                 _buildProductList(transaction, formatCurrency),

//                 const SizedBox(height: 8),

//                 const Divider(height: 32),

//                 // Shipping Method
//                 _buildShippingMethod(transaction),

//                 const SizedBox(height: 16),

//                 const Divider(height: 32),

//                 // Shopping Summary
//                 _buildShoppingSummary(transaction, formatCurrency),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Widget _buildTransactionInfo(Transaction transaction, DateFormat formatDate) {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       Text("Kode Transaksi: ${transaction.transactionCode ?? '-'}",
//   //           style: const TextStyle(fontSize: 16)),
//   //       Text("Karyawan: ${transaction.userName ?? '-'}",
//   //           style: const TextStyle(fontSize: 16)),
//   //       Text(
//   //           "Time: ${transaction.transactionDate != null ? formatDate.format(transaction.transactionDate) : '-'}"),
//   //     ],
//   //   );
//   // }

//   Widget _buildTransactionInfo(Transaction transaction, DateFormat formatDate) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             children: [
//               Icon(Icons.info_outline, color: Colors.blueAccent),
//               SizedBox(width: 8),
//               Text(
//                 "Informasi Transaksi",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           const Divider(thickness: 1),
//           const SizedBox(height: 8),
//           _buildInfoRow("Kode Transaksi", transaction.transactionCode ?? "-"),
//           const SizedBox(height: 8),
//           _buildInfoRow("Karyawan", transaction.userName ?? "-"),
//           const SizedBox(height: 8),

//           // _buildInfoRow(
//           //   "Waktu",
//           //   transaction.transactionDate != null
//           //       ? formatDate.format(transaction.transactionDate!)
//           //       : "-",
//           // ),

//           // _buildInfoRow(
//           //   "Waktu",
//           //   transaction.transactionDate != null
//           //       ? formatDate.format(transaction.transactionDate.toLocal())
//           //       : "-",
//           // ),

//           _buildInfoRow(
//             "Waktu",
//             DateFormat('dd MMM yyyy, HH:mm')
//                 .format(transaction.transactionDate),
//           ),
//         ],
//       ),
//     );
//   }

// // Widget bantu untuk menyusun label dan nilai sejajar
//   Widget _buildInfoRow(String label, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 14)),
//         Text(value,
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//       ],
//     );
//   }

//   Widget _buildStatusBlock(Transaction transaction) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TransactionStatusDetailPage(
//               transactionId: widget.transactionId,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         decoration: BoxDecoration(
//           color: getStatusColor(transaction.status ?? 'Unknown'),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Status: ${transaction.status ?? '-'}",
//               style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white),
//             ),
//             const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProductList(
//       Transaction transaction, NumberFormat formatCurrency) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("Products",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         ...transaction.details.map((detail) => Card(
//               elevation: 2,
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               color: Colors.grey[200],
//               child: ListTile(
//                 leading: detail.photo != null && detail.photo!.isNotEmpty
//                     ? Image.network(
//                         '$responseUrl/storage/${detail.photo}',
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                       )
//                     : Image.asset('assets/images/product.png',
//                         width: 50, height: 50, fit: BoxFit.cover),
//                 title: Text('${detail.name} (${detail.code})'),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Harga: ${formatCurrency.format(detail.price ?? 0)}"),
//                     Text("Jumlah: ${detail.quantity ?? 0}"),
//                     Text(
//                         "Total: ${formatCurrency.format((detail.quantity ?? 0) * (detail.price ?? 0))}"),
//                   ],
//                 ),
//               ),
//             )),
//       ],
//     );
//   }

//   // Widget _buildShippingMethod(Transaction transaction) {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       const Text("Shipping Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//   //       const SizedBox(height: 8),
//   //       Text("${transaction.shippingMethod ?? '-'}"),
//   //       const SizedBox(height: 8),
//   //       Text("${transaction.shippingTime ?? '-'}"),
//   //     ],
//   //   );
//   // }

// //   Widget _buildShippingMethod(Transaction transaction) {
// //   return Column(
// //     crossAxisAlignment: CrossAxisAlignment.start,
// //     children: [
// //       const Text(
// //         "Shipping Method",
// //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //       ),
// //       const SizedBox(height: 8),
// //       Padding(
// //         padding: const EdgeInsets.symmetric(vertical: 4.0),
// //         child: Text(
// //           "${transaction.shippingMethod ?? '-'}",
// //           style: const TextStyle(fontWeight: FontWeight.bold),
// //         ),
// //       ),
// //       const SizedBox(height: 8),
// //       Text("${transaction.shippingTime ?? '-'}"),
// //     ],
// //   );
// // }

// //   Widget _buildShippingMethod(Transaction transaction) {
// //   return Container(
// //     padding: const EdgeInsets.all(16),
// //     margin: const EdgeInsets.symmetric(vertical: 8),
// //     decoration: BoxDecoration(
// //       color: Colors.grey.shade200, // background sedikit lebih gelap
// //       borderRadius: BorderRadius.circular(8),
// //       boxShadow: [
// //         BoxShadow(
// //           color: Colors.black12,
// //           blurRadius: 6,
// //           offset: const Offset(0, 3), // sedikit bayangan di bawah
// //         ),
// //       ],
// //     ),
// //     child: Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Text(
// //           "Shipping Method",
// //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //         ),
// //         const SizedBox(height: 8),
// //         Padding(
// //           padding: const EdgeInsets.symmetric(vertical: 4.0),
// //           child: Text(
// //             "${transaction.shippingMethod ?? '-'}",
// //             style: const TextStyle(fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         Text("${transaction.shippingTime ?? '-'}"),
// //       ],
// //     ),
// //   );
// // }

//   Widget _buildShippingMethod(Transaction transaction) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             children: [
//               Icon(Icons.local_shipping, color: Colors.blueAccent),
//               SizedBox(width: 8),
//               Text(
//                 "Shipping Method",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           const Divider(thickness: 1),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4.0),
//             child: Text(
//               transaction.shippingMethod ?? '-',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(transaction.shippingTime ?? '-'),
//         ],
//       ),
//     );
//   }

//   // Widget _buildShoppingSummary(
//   //     Transaction transaction, NumberFormat formatCurrency) {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       const Text("Rincian Belanja",
//   //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//   //       Text("Metode Pembayaran: ${transaction.paymentMethod ?? '-'}"),
//   //       const SizedBox(height: 16),
//   //       Text(
//   //           "Biaya Pengiriman: ${formatCurrency.format(transaction.shippingCost ?? 0)}"),
//   //       Text(
//   //           "Total Biaya Produk: ${formatCurrency.format(transaction.grossAmount ?? 0)}"),
//   //       const SizedBox(height: 16),
//   //       Text(
//   //           "Total Pembayaran: ${formatCurrency.format(transaction.totalPayment ?? 0)}"),
//   //     ],
//   //   );
//   // }
//   // Widget _buildShoppingSummary(
//   //     Transaction transaction, NumberFormat formatCurrency) {
//   //   return Container(
//   //     padding: const EdgeInsets.all(16),
//   //     margin: const EdgeInsets.symmetric(vertical: 8),
//   //     decoration: BoxDecoration(
//   //       color: Colors.grey.shade200,
//   //       borderRadius: BorderRadius.circular(8),
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: Colors.black12,
//   //           blurRadius: 6,
//   //           offset: const Offset(0, 3),
//   //         ),
//   //       ],
//   //     ),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         Row(
//   //           children: const [
//   //             Icon(Icons.receipt_long, color: Colors.blueAccent),
//   //             SizedBox(width: 8),
//   //             Text(
//   //               "Rincian Belanja",
//   //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//   //             ),
//   //           ],
//   //         ),
//   //         const SizedBox(height: 8),
//   //         const Divider(thickness: 1),
//   //         const SizedBox(height: 8),
//   //         Text("Metode Pembayaran: ${transaction.paymentMethod ?? '-'}"),
//   //         const SizedBox(height: 12),
//   //         Text(
//   //           "Biaya Pengiriman: ${formatCurrency.format(transaction.shippingCost ?? 0)}",
//   //         ),
//   //         Text(
//   //           "Total Biaya Produk: ${formatCurrency.format(transaction.grossAmount ?? 0)}",
//   //         ),
//   //         const SizedBox(height: 12),
//   //         Text(
//   //           "Total Pembayaran: ${formatCurrency.format(transaction.totalPayment ?? 0)}",
//   //           style: const TextStyle(
//   //             fontWeight: FontWeight.bold,
//   //             color: Colors.green,
//   //             fontSize: 16,
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   Widget _buildShoppingSummary(
//       Transaction transaction, NumberFormat formatCurrency) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             children: [
//               Icon(Icons.receipt_long, color: Colors.blueAccent),
//               SizedBox(width: 8),
//               Text(
//                 "Rincian Belanja",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           const Divider(thickness: 1),
//           const SizedBox(height: 8),
//           _buildSummaryRow(
//               "Metode Pembayaran", transaction.paymentMethod ?? "-"),
//           const SizedBox(height: 12),
//           _buildSummaryRow("Biaya Pengiriman",
//               formatCurrency.format(transaction.shippingCost ?? 0)),
//           _buildSummaryRow("Total Biaya Produk",
//               formatCurrency.format(transaction.grossAmount ?? 0)),
//           const Divider(height: 32, thickness: 1.2),
//           _buildSummaryRow(
//             "Total Pembayaran",
//             formatCurrency.format(transaction.totalPayment),
//             isEmphasized: true,
//           ),
//         ],
//       ),
//     );
//   }

// // Widget bantu agar bisa digunakan ulang
//   Widget _buildSummaryRow(String label, String value,
//       {bool isEmphasized = false}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontWeight: isEmphasized ? FontWeight.bold : FontWeight.normal,
//             fontSize: 14,
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontWeight: isEmphasized ? FontWeight.bold : FontWeight.normal,
//             fontSize: isEmphasized ? 15 : 14,
//             color: isEmphasized ? Colors.green : Colors.black,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:ta_c14210052/models/transaction.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:ta_c14210052/views/pages/app/transaction_status_detail_page.dart';

class TransactionDetailPage extends StatefulWidget {
  final int transactionId;

  const TransactionDetailPage({super.key, required this.transactionId});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  late Future<Transaction> transactionFuture;

  @override
  void initState() {
    super.initState();
    transactionFuture = fetchTransactionDetail(widget.transactionId);
  }

  Future<Transaction> fetchTransactionDetail(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$responseUrl/api/transactions/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Transaction.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail transaksi.');
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Pembayaran lunas':
      case 'Pesanan sampai':
      case 'Pesanan selesai dikemas':
        return Colors.blue;
      case 'Pesanan selesai':
      case 'Pembatalan berhasil':
        return Colors.green;
      case 'Belum bayar':
      case 'Dalam perjalanan':
      case 'Dalam pengemasan':
      case 'Proses pembatalan':
        return Colors.orange;
      case 'Pembayaran gagal':
      case 'Dibatalkan':
      case 'Pengiriman gagal':
        return Colors.red;
      default:
        return Colors.black87; // Default warna
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaction Detail',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<Transaction>(
        future: transactionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak tersedia."));
          }

          final transaction = snapshot.data!;
          final formatCurrency =
              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
          final formatDate = DateFormat('dd MMM yyyy, HH:mm');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction Info
                _buildTransactionInfo(transaction, formatDate),

                // Status Block
                _buildStatusBlock(transaction),

                const Divider(height: 32),

                // Product List
                _buildProductList(transaction, formatCurrency),

                const SizedBox(height: 8),

                const Divider(height: 32),

                // Shipping Method
                _buildShippingMethod(transaction),

                const SizedBox(height: 16),

                const Divider(height: 32),

                // Shopping Summary
                _buildShoppingSummary(transaction, formatCurrency),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionInfo(Transaction transaction, DateFormat formatDate) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text(
                "Informasi Transaksi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 1),
          const SizedBox(height: 8),
          _buildInfoRow("Kode Transaksi", transaction.transactionCode ?? "-"),
          const SizedBox(height: 8),
          _buildInfoRow("Karyawan", transaction.userName ?? "-"),
          const SizedBox(height: 8),
          _buildInfoRow(
            "Waktu",
            DateFormat('dd MMM yyyy, HH:mm')
                .format(transaction.transactionDate),
          ),
        ],
      ),
    );
  }

// Widget bantu untuk menyusun label dan nilai sejajar
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatusBlock(Transaction transaction) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => TransactionStatusDetailPage(
      //         transactionId: widget.transactionId,
      //       ),
      //     ),
      //   );
      // },

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionStatusDetailPage(
              transactionId: widget.transactionId,
            ),
          ),
        ).then((_) {
          setState(() {
            transactionFuture = fetchTransactionDetail(widget.transactionId);
          });
        });
      },

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: getStatusColor(transaction.status ?? 'Unknown'),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Status: ${transaction.status ?? '-'}",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(
      Transaction transaction, NumberFormat formatCurrency) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Products",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...transaction.details.map((detail) => Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey[200],
              child: ListTile(
                leading: detail.photo != null && detail.photo!.isNotEmpty
                    ? Image.network(
                        '$responseUrl/storage/${detail.photo}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Image.asset('assets/images/product.png',
                        width: 50, height: 50, fit: BoxFit.cover),
                title: Text('${detail.name} (${detail.code})'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Harga: ${formatCurrency.format(detail.price ?? 0)}"),
                    Text("Jumlah: ${detail.quantity ?? 0}"),
                    Text(
                        "Total: ${formatCurrency.format((detail.quantity ?? 0) * (detail.price ?? 0))}"),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildShippingMethod(Transaction transaction) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_shipping, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text(
                "Shipping Method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 1),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              transaction.shippingMethod ?? '-',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Text(transaction.shippingTime ?? '-'),
        ],
      ),
    );
  }

  Widget _buildShoppingSummary(
      Transaction transaction, NumberFormat formatCurrency) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text(
                "Rincian Belanja",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 1),
          const SizedBox(height: 8),
          _buildSummaryRow(
              "Metode Pembayaran", transaction.paymentMethod ?? "-"),
          const SizedBox(height: 12),
          _buildSummaryRow("Biaya Pengiriman",
              formatCurrency.format(transaction.shippingCost ?? 0)),
          _buildSummaryRow("Total Biaya Produk",
              formatCurrency.format(transaction.grossAmount ?? 0)),
          const Divider(height: 32, thickness: 1.2),
          _buildSummaryRow(
            "Total Pembayaran",
            formatCurrency.format(transaction.totalPayment),
            isEmphasized: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isEmphasized = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isEmphasized ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isEmphasized ? FontWeight.bold : FontWeight.normal,
            fontSize: isEmphasized ? 15 : 14,
            color: isEmphasized ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}
