// class TransactionStatusHistory {
//   final int id;
//   final int transactionId;
//   final String status;
//   final DateTime changedAt;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   TransactionStatusHistory({
//     required this.id,
//     required this.transactionId,
//     required this.status,
//     required this.changedAt,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory TransactionStatusHistory.fromJson(Map<String, dynamic> json) {
//     return TransactionStatusHistory(
//       id: json['id'] ?? 0,
//       transactionId: json['transaction_id'] ?? 0,
//       status: json['status'] ?? '',
//       changedAt: DateTime.tryParse(json['changed_at'].toString()) ??
//           DateTime(2000, 1, 1),
//       createdAt: json['created_at'] != null
//           ? DateTime.tryParse(json['created_at'].toString())
//           : null,
//       updatedAt: json['updated_at'] != null
//           ? DateTime.tryParse(json['updated_at'].toString())
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'transaction_id': transactionId,
//       'status': status,
//       'changed_at': changedAt.toIso8601String(),
//       'created_at': createdAt?.toIso8601String(),
//       'updated_at': updatedAt?.toIso8601String(),
//     };
//   }
// }

class TransactionStatusHistory {
  final int id; // id riwayat status transaksi
  final int transactionId; // id transaksi
  final String status; // isi riwayat status transaksi
  final DateTime changedAt; // waktu status baru ditambahkan pada riwayat
  // final DateTime? createdAt;
  // final DateTime? updatedAt;

  TransactionStatusHistory({
    required this.id,
    required this.transactionId,
    required this.status,
    required this.changedAt,
    // this.createdAt,
    // this.updatedAt,
  });

  // pemanggilan respon API
  factory TransactionStatusHistory.fromJson(Map<String, dynamic> json) {
    return TransactionStatusHistory(
      id: _parseInt(json['id']),
      transactionId: _parseInt(json['transaction_id']),
      status: json['status'] ?? '',
      changedAt: DateTime.tryParse(json['changed_at'].toString()) ??
          DateTime(2000, 1, 1),
      // createdAt: json['created_at'] != null
      //     ? DateTime.tryParse(json['created_at'].toString())
      //     : null,
      // updatedAt: json['updated_at'] != null
      //     ? DateTime.tryParse(json['updated_at'].toString())
      //     : null,
    );
  }

  // parsing data ke int
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'transaction_id': transactionId,
  //     'status': status,
  //     'changed_at': changedAt.toIso8601String(),
  //     // 'created_at': createdAt?.toIso8601String(),
  //     // 'updated_at': updatedAt?.toIso8601String(),
  //   };
  // }
}
