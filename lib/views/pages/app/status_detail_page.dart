// import 'package:flutter/material.dart';
// import 'package:ta_c14210052/models/transaction_status_history.dart';
// import 'package:intl/intl.dart';

// class StatusDetailPage extends StatelessWidget {
//   final TransactionStatusHistory status;

//   const StatusDetailPage({super.key, required this.status});

//   String formatDate(DateTime? date) {
//     if (date == null) return '-';
//     return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(date);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Detail Status")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
//             Text(status.status),
//             const SizedBox(height: 16),
//             const Text("Waktu Perubahan", style: TextStyle(fontWeight: FontWeight.bold)),
//             Text(formatDate(status.changedAt)),
//             const SizedBox(height: 16),
//             const Text("Created At", style: TextStyle(fontWeight: FontWeight.bold)),
//             Text(formatDate(status.createdAt)),
//             const SizedBox(height: 16),
//             const Text("Updated At", style: TextStyle(fontWeight: FontWeight.bold)),
//             Text(formatDate(status.updatedAt)),
//           ],
//         ),
//       ),
//     );
//   }
// }
