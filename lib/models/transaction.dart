import 'package:ta_c14210052/models/transaction_detail.dart';
import 'package:ta_c14210052/models/transaction_status_history.dart';

class Transaction {
  final int id;
  final int userId;
  final String? userName;
  final String? transactionCode;
  final String? status;
  final double? grossAmount;
  final double? shippingCost;
  final double totalPayment;
  final String? shippingMethod;
  final String? paymentMethod;
  // final DateTime? shippingTime;
  final String? shippingTime;
  final DateTime transactionDate;
  // final int isFinal;
  // final bool isFinal;
  final String? isFinal;
  final List<TransactionDetail> details;
  final List<TransactionStatusHistory> statusHistories;

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

  factory Transaction.fromJson(Map<String, dynamic> json) {
    print("JSON Response: $json"); // Log JSON utama

    return Transaction(
      id: json['transaction']['id'] ?? 0, // Mengambil 'id' dari 'transaction'
      userId: json['transaction']['user_id'] ?? 0,
      userName: json['transaction']['user_name'] ?? 'Unknown',
      transactionCode: json['transaction']['transaction_code'] ?? '',
      status: json['transaction']['status'] ?? '',
      grossAmount:
          double.tryParse(json['transaction']['gross_amount'].toString()) ??
              0.0,
      shippingCost:
          double.tryParse(json['transaction']['shipping_cost'].toString()) ??
              0.0,
      totalPayment:
          double.tryParse(json['transaction']['total_payment'].toString()) ??
              0.0,
      shippingMethod:
          json['transaction']['shipping_method'] ?? 'Ambil di tempat',
      paymentMethod: json['transaction']['payment_method'] ?? 'Cash',
      // shippingTime: json['transaction']['shipping_time'] != null
      //     ? DateTime.tryParse(json['transaction']['shipping_time'].toString())
      //     : null,
      shippingTime: json['transaction']['shipping_time'],
      // transactionDate: DateTime.tryParse(
      //         json['transaction']['transaction_date']?.toString() ?? '') ??
      //     DateTime(2000, 1, 1),
      // transactionDate: DateTime.tryParse(
      //     json['transaction']['transaction_date']?.add(const Duration(hours: 7)).toString() ?? '') ??
      // DateTime(2000, 1, 1),

      transactionDate: json['transaction']['transaction_date'] != null
          ? DateTime.parse(json['transaction']['transaction_date'])
              .add(const Duration(hours: 7))
          : DateTime(2000, 1, 1),

      // details: (json['products'] as List<dynamic>? ?? []).map((product) {
      //   print("Parsing Product: $product");
      //   return TransactionDetail.fromJson(product); // Memetakan data produk
      // }).toList(),
      // isFinal: json['transaction']['is_final'] ?? 0, // ← ini bagian baru

      // isFinal: (json['transaction']['is_final'] ?? 0) == 1, // ← ini sudah aman
      isFinal: json['transaction']['is_final'],
      details: (json['products'] as List<dynamic>? ?? []).map((product) {
        print("Parsing Product: $product");
        return TransactionDetail.fromJson(product); // Memetakan data produk
      }).toList(),
      statusHistories:
          (json['status_histories'] as List<dynamic>? ?? []).map((status) {
        print("Parsing Status History: $status");
        return TransactionStatusHistory.fromJson(
            status); // Memetakan data status history
      }).toList(),
    );
  }
}
