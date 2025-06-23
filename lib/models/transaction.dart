// import 'package:ta_c14210052/models/transaction_detail.dart';
// import 'package:ta_c14210052/models/transaction_status_history.dart';

// class Transaction {
//   final int id;
//   final int userId;
//   final String? userName;
//   final String? transactionCode;
//   final String? status;
//   final double? grossAmount;
//   final double? shippingCost;
//   final double totalPayment;
//   final String? shippingMethod;
//   final String? paymentMethod;
//   // final DateTime? shippingTime;
//   final String? shippingTime;
//   final DateTime transactionDate;
//   // final int isFinal;
//   // final bool isFinal;
//   final String? isFinal;
//   final List<TransactionDetail> details;
//   final List<TransactionStatusHistory> statusHistories;

//   Transaction({
//     required this.id,
//     required this.transactionCode,
//     required this.status,
//     required this.userId,
//     required this.userName,
//     required this.grossAmount,
//     required this.shippingCost,
//     required this.totalPayment,
//     required this.shippingMethod,
//     required this.paymentMethod,
//     required this.shippingTime,
//     required this.transactionDate,
//     required this.isFinal,
//     required this.details,
//     required this.statusHistories,
//   });

//   factory Transaction.fromJson(Map<String, dynamic> json) {
//     print("JSON Response: $json"); // Log JSON utama

//     return Transaction(
//       id: json['transaction']['id'] ?? 0, // Mengambil 'id' dari 'transaction'
//       userId: json['transaction']['user_id'] ?? 0,
//       userName: json['transaction']['user_name'] ?? 'Unknown',
//       transactionCode: json['transaction']['transaction_code'] ?? '',
//       status: json['transaction']['status'] ?? '',
//       grossAmount:
//           double.tryParse(json['transaction']['gross_amount'].toString()) ??
//               0.0,
//       shippingCost:
//           double.tryParse(json['transaction']['shipping_cost'].toString()) ??
//               0.0,
//       totalPayment:
//           double.tryParse(json['transaction']['total_payment'].toString()) ??
//               0.0,
//       shippingMethod:
//           json['transaction']['shipping_method'] ?? 'Ambil di tempat',
//       paymentMethod: json['transaction']['payment_method'] ?? 'Cash',
//       // shippingTime: json['transaction']['shipping_time'] != null
//       //     ? DateTime.tryParse(json['transaction']['shipping_time'].toString())
//       //     : null,
//       shippingTime: json['transaction']['shipping_time'],
//       // transactionDate: DateTime.tryParse(
//       //         json['transaction']['transaction_date']?.toString() ?? '') ??
//       //     DateTime(2000, 1, 1),
//       // transactionDate: DateTime.tryParse(
//       //     json['transaction']['transaction_date']?.add(const Duration(hours: 7)).toString() ?? '') ??
//       // DateTime(2000, 1, 1),

//       transactionDate: json['transaction']['transaction_date'] != null
//           ? DateTime.parse(json['transaction']['transaction_date'])
//               .add(const Duration(hours: 7))
//           : DateTime(2000, 1, 1),

//       // details: (json['products'] as List<dynamic>? ?? []).map((product) {
//       //   print("Parsing Product: $product");
//       //   return TransactionDetail.fromJson(product); // Memetakan data produk
//       // }).toList(),
//       // isFinal: json['transaction']['is_final'] ?? 0, // ← ini bagian baru

//       // isFinal: (json['transaction']['is_final'] ?? 0) == 1, // ← ini sudah aman
//       isFinal: json['transaction']['is_final'],
//       details: (json['products'] as List<dynamic>? ?? []).map((product) {
//         print("Parsing Product: $product");
//         return TransactionDetail.fromJson(product); // Memetakan data produk
//       }).toList(),
//       statusHistories:
//           (json['status_histories'] as List<dynamic>? ?? []).map((status) {
//         print("Parsing Status History: $status");
//         return TransactionStatusHistory.fromJson(
//             status); // Memetakan data status history
//       }).toList(),
//     );
//   }
// }

import 'package:ta_c14210052/models/transaction_detail.dart';
import 'package:ta_c14210052/models/transaction_status_history.dart';

class Transaction {
  final int id; // id transaksi
  final int userId; // id dari pengguna karyawan yang melakukan transaksi
  final String? userName; // nama karyawan
  final String? transactionCode; // kode transaksi
  final String? status; // status transaksi
  final double? grossAmount; // total semua harga produk 
  final double? shippingCost; // harga pengiriman
  final double totalPayment; // total pembayaran / biaya transaksi
  final String? shippingMethod; // metode pengiriman 
  final String? paymentMethod; // metode pembayaran
  final String? shippingTime; // estimasi waktu pengiriman
  final DateTime transactionDate; // waktu transaksi terjadi
  final String? isFinal; // mengecek apakah status dari transaksi terkait telah di finalisasi 
  final List<TransactionDetail> details; // mengambil data detail transaksi
  final List<TransactionStatusHistory> statusHistories; // mengambil data riwayat proses status transaksi yang terjadi  

  Transaction({
    required this.id,
    required this.transactionCode,
    required this.status,
    required this.userId,
    required this.userName,
    required this.grossAmount,
    required this.shippingCost,
    required this.totalPayment,
    required this.shippingMethod,
    required this.paymentMethod,
    required this.shippingTime,
    required this.transactionDate,
    required this.isFinal,
    required this.details,
    required this.statusHistories,
  });

  // mengambil data API
  factory Transaction.fromJson(Map<String, dynamic> json) {
    print("JSON Response: $json");

    final trans = json['transaction'] ?? {};

    return Transaction(
      id: _parseInt(trans['id']),
      userId: _parseInt(trans['user_id']),
      userName: trans['user_name'] ?? 'Unknown',
      transactionCode: trans['transaction_code'] ?? '',
      status: trans['status'] ?? '',
      grossAmount: _parseDouble(trans['gross_amount']),
      shippingCost: _parseDouble(trans['shipping_cost']),
      totalPayment: _parseDouble(trans['total_payment']),
      shippingMethod: trans['shipping_method'] ?? 'Ambil di tempat',
      paymentMethod: trans['payment_method'] ?? 'Cash',
      shippingTime: trans['shipping_time'],
      transactionDate: trans['transaction_date'] != null
          ? DateTime.parse(trans['transaction_date'])
              .add(const Duration(hours: 7))
          : DateTime(2000, 1, 1),
      isFinal: trans['is_final'],
      details: (json['products'] as List<dynamic>? ?? []).map((product) {
        print("Parsing Product: $product");
        return TransactionDetail.fromJson(product);
      }).toList(),
      statusHistories:
          (json['status_histories'] as List<dynamic>? ?? []).map((status) {
        print("Parsing Status History: $status");
        return TransactionStatusHistory.fromJson(status);
      }).toList(),
    );
  }

  // untuk parsing ke int
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // untuk parsing ke double
  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
