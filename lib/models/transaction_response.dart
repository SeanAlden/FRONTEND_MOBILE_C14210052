import 'package:ta_c14210052/models/transaction.dart';
import 'package:ta_c14210052/models/transaction_detail.dart';
import 'package:ta_c14210052/models/transaction_status_history.dart';

class TransactionResponse {
  final Transaction transaction;

  TransactionResponse({required this.transaction});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    final details = json['details'] as List<dynamic>? ?? [];
    final statusHistories = json['status_histories'] as List<dynamic>? ?? [];

    return TransactionResponse(
      transaction: Transaction(
        id: json['id'] ?? 0,
        userId: json['user_id'] ?? 0,
        userName: json['user_name'] ?? 'Unknown',
        transactionCode: json['transaction_code'] ?? '',
        status: json['status'] ?? '',
        grossAmount: double.tryParse(json['gross_amount'].toString()) ?? 0.0,
        shippingCost: double.tryParse(json['shipping_cost'].toString()) ?? 0.0,
        totalPayment: double.tryParse(json['total_payment'].toString()) ?? 0.0,
        shippingMethod: json['shipping_method'] ?? 'Ambil di tempat',
        paymentMethod: json['payment_method'] ?? 'Cash',
        // shippingTime: json['shipping_time'] != null
        //     ? DateTime.tryParse(json['shipping_time'].toString())
        //     : null,
        shippingTime: json['shipping_time']?.toString(),
        // transactionDate:
        //     DateTime.tryParse(json['transaction_date']?.toString() ?? '') ??
        //         DateTime(2000, 1, 1),

        // transactionDate:
        //     DateTime.tryParse(json['transaction_date']?.add(const Duration(hours: 7)).toString() ?? '') ??
        //         DateTime(2000, 1, 1),
        transactionDate: json['transaction_date'] != null
            ? DateTime.parse(json['transaction_date']).add(const Duration(hours: 7))
            : DateTime(2000, 1, 1),
        // details: details.map((e) => TransactionDetail.fromJson(e)).toList(),
        // isFinal: json['is_final'] ?? 0, // ← ini bagian baru

        // isFinal: (json['transaction']['is_final'] ?? 0) == 1, // ← ini sudah aman
        isFinal: json['is_final'] ?? '',
        details: details.map((e) => TransactionDetail.fromJson(e)).toList(),
        statusHistories: statusHistories
            .map((e) => TransactionStatusHistory.fromJson(e))
            .toList(),
      ),
    );
  }
}
