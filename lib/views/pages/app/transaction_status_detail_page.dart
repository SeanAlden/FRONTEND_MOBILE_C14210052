import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/constant/api_url.dart';
// import 'package:ta_c14210052/models/transaction.dart';
// import 'package:ta_c14210052/models/transaction.dart';
// import 'package:ta_c14210052/models/transaction_response.dart';
// import 'package:ta_c14210052/widgets/dotted_line_painter.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionStatusDetailPage extends StatefulWidget {
  final int transactionId;

  const TransactionStatusDetailPage({super.key, required this.transactionId});

  @override
  State<TransactionStatusDetailPage> createState() =>
      _TransactionStatusDetailPageState();
}

class _TransactionStatusDetailPageState
    extends State<TransactionStatusDetailPage> {
  bool isTransactionFinal = true;

  // List<Transaction> transaction = [];
  // Transaction? transaction;

  List<dynamic> statusHistories = [];
  bool isLoading = true;
  List<String> availableStatuses = [
    'Pesanan selesai',
    'Pembayaran lunas',
    'Belum bayar',
    'Pesanan sampai',
    'Dalam perjalanan',
    'Pesanan selesai dikemas',
    'Dalam pengemasan',
    'Pembayaran gagal',
    'Dibatalkan',
    'Proses pembatalan',
    'Pembatalan berhasil',
    'Pengiriman gagal',
  ];
  String? selectedStatus;
  bool isFinalSaved = false;

  @override
  void initState() {
    super.initState();
    fetchStatusHistory();
    checkTransactionFinalStatus(widget.transactionId);
  }

  Future<void> fetchStatusHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.get(
        Uri.parse(
            '$responseUrl/api/transactions/${widget.transactionId}/status-history'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          statusHistories = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load status history');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkTransactionFinalStatus(int transactionId) async {
    final url =
        Uri.parse('$responseUrl/api/transactions/$transactionId/check-final');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        isTransactionFinal = data['is_final'] ?? false;
      });
    } else {
      // Error handling
      print('Failed to check final status');
    }
  }

  Future<bool> deleteStatus(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.delete(
      Uri.parse('$responseUrl/api/transactions/status-history/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error['error'] ?? 'Gagal menghapus status'),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  Widget _buildTransactionStatus(List<Map<String, dynamic>> statusHistories)
  // Widget _buildTransactionStatus(List<dynamic> statusHistories)
  {
    // Ambil status terakhir
    final String status = statusHistories.isNotEmpty
        ? statusHistories.last['status'] ?? 'No status available'
        : 'No status available';

    // Tentukan warna berdasarkan status
    final Color statusColor = _getStatusColor(status);

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Transaction Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              status,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> formatStatusHistories(
      List<Map<String, dynamic>> statusHistories) {
    for (var item in statusHistories) {
      item['formatted_time'] = formatUtcToWib(item['changed_at']);
    }
    return statusHistories;
  }

  Widget _buildTimelineStatus(List<Map<String, dynamic>> statusHistories) {
    // return Container(
    //   padding: const EdgeInsets.all(16),
    //   margin: const EdgeInsets.symmetric(vertical: 8),
    //   decoration: BoxDecoration(
    //     color: Colors.grey.shade200,
    //     borderRadius: BorderRadius.circular(8),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black12,
    //         blurRadius: 6,
    //         offset: const Offset(0, 3),
    //       ),
    //     ],
    //   ),
    //   child: Expanded(
    //     child: ListView.builder(
    //       reverse: true, // Makes the list start from the latest status
    //       itemCount: statusHistories.length,
    //       itemBuilder: (context, index) {
    //         final item = statusHistories[index];

    //         return TimelineTile(
    //           alignment: TimelineAlign.manual,
    //           lineXY: 0.1,
    //           isFirst: index == statusHistories.length - 1,
    //           isLast: index == 0,
    //           indicatorStyle: const IndicatorStyle(
    //             width: 20,
    //             color: Colors.blueAccent,
    //             padding: EdgeInsets.all(6),
    //           ),
    //           beforeLineStyle: LineStyle(
    //             color: index == statusHistories.length - 1
    //                 ? Colors.transparent
    //                 : Colors.blueAccent, // Tidak ada garis sebelum item pertama
    //             thickness: index == statusHistories.length - 1
    //                 ? 0
    //                 : 3, // Tidak ada garis sebelum item pertama
    //           ),
    //           afterLineStyle: LineStyle(
    //             color: index == 0
    //                 ? Colors.transparent
    //                 : Colors
    //                     .blueAccent, // Tidak ada garis setelah item terakhir
    //             thickness:
    //                 index == 0 ? 0 : 3, // Tidak ada garis setelah item terakhir
    //           ),
    //           endChild: Container(
    //             margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    //             padding: const EdgeInsets.all(16),
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: BorderRadius.circular(12),
    //               boxShadow: [
    //                 BoxShadow(
    //                   color: Colors.black12,
    //                   blurRadius: 6,
    //                   offset: const Offset(0, 3),
    //                 ),
    //               ],
    //             ),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   item['status'] ?? '',
    //                   style: const TextStyle(
    //                     fontSize: 16,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 const SizedBox(height: 6),
    //                 Text(
    //                   'Waktu: ${formatUtcToWib(item['changed_at'])}',
    //                   style: const TextStyle(
    //                     fontSize: 14,
    //                     color: Colors.grey,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );

    // Memformat status histories terlebih dahulu
    // statusHistories = formatStatusHistories(statusHistories);

    return Expanded(
      child: ListView.builder(
        reverse: true, // Urut dari status terbaru
        itemCount: statusHistories.length,
        itemBuilder: (context, index) {
          final item = statusHistories[index];

          return TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isFirst: index == statusHistories.length - 1,
            isLast: index == 0,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Colors.blueAccent,
              padding: EdgeInsets.all(6),
            ),
            beforeLineStyle: LineStyle(
              color: index == statusHistories.length - 1
                  ? Colors.transparent
                  : Colors.blueAccent, 
              thickness: index == statusHistories.length - 1
                  ? 0
                  : 3, 
            ),
            afterLineStyle: LineStyle(
              color: index == 0
                  ? Colors.transparent
                  : Colors.blueAccent, 
              thickness:
                  index == 0 ? 0 : 3, 
            ),
            // endChild: Container(
            //   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(12),
            //     boxShadow: const [
            //       BoxShadow(
            //         color: Colors.black12,
            //         blurRadius: 6,
            //         offset: Offset(0, 3),
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         item['status'] ?? '',
            //         style: const TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       const SizedBox(height: 6),
            //       Text(
            //         'Waktu: ${formatUtcToWib(item['changed_at'])}',
            //         style: const TextStyle(
            //           fontSize: 14,
            //           color: Colors.grey,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // endChild: Container(
            //   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(12),
            //     boxShadow: const [
            //       BoxShadow(
            //         color: Colors.black12,
            //         blurRadius: 6,
            //         offset: Offset(0, 3),
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             item['status'] ?? '',
            //             style: const TextStyle(
            //               fontSize: 16,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           // Tombol hapus hanya untuk item teratas
            //           if (index == statusHistories.length - 1)
            //             IconButton(
            //               icon: const Icon(Icons.delete, color: Colors.red),
            //               onPressed: () => _deleteStatus(context, item['id']),
            //             ),
            //         ],
            //       ),
            //       const SizedBox(height: 6),
            //       Text(
            //         'Waktu: ${formatUtcToWib(item['changed_at'])}',
            //         style: const TextStyle(
            //           fontSize: 14,
            //           color: Colors.grey,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            endChild: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['status'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // if (index == statusHistories.length - 1)
                      //   IconButton(
                      //     icon: const Icon(Icons.delete, color: Colors.red),
                      //     onPressed: () async {
                      //       final confirmed = await showDialog<bool>(
                      //         context: context,
                      //         builder: (context) => AlertDialog(
                      //           title: const Text("Konfirmasi"),
                      //           content: const Text(
                      //               "Yakin ingin menghapus status ini?"),
                      //           actions: [
                      //             TextButton(
                      //               onPressed: () =>
                      //                   Navigator.pop(context, false),
                      //               child: const Text("Batal"),
                      //             ),
                      //             TextButton(
                      //               onPressed: () =>
                      //                   Navigator.pop(context, true),
                      //               child: const Text("Hapus",
                      //                   style: TextStyle(color: Colors.red)),
                      //             ),
                      //           ],
                      //         ),
                      //       );

                      //       if (confirmed == true) {
                      //         await deleteStatus(item['id']);
                      //         // Refresh list setelah delete
                      //       }
                      //     },
                      //   ),

                      if (index == statusHistories.length - 1)
                        isTransactionFinal
                            ? const SizedBox()
                            : IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Konfirmasi"),
                                      content: const Text(
                                          "Yakin ingin menghapus status ini?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text("Batal"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text("Hapus",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmed == true) {
                                    final deleted = await deleteStatus(
                                        item['id'].toString());
                                    if (deleted) {
                                      setState(() {
                                        statusHistories.removeAt(index);
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Status berhasil dihapus.'),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Waktu: ${formatUtcToWib(item['changed_at'])}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    // return Container(
    //   padding: const EdgeInsets.all(16),
    //   margin: const EdgeInsets.all(8),
    //   decoration: BoxDecoration(
    //     color: Colors.grey.shade200,
    //     borderRadius: BorderRadius.circular(12),
    //   ),
    //   child: ListView.builder(
    //     reverse: true, // Makes the list start from the latest status
    //     itemCount: statusHistories.length,
    //     itemBuilder: (context, index) {
    //       final item = statusHistories[index];

    //       return TimelineTile(
    //         alignment: TimelineAlign.manual,
    //         lineXY: 0.1,
    //         isFirst: index == statusHistories.length - 1,
    //         isLast: index == 0,
    //         indicatorStyle: const IndicatorStyle(
    //           width: 20,
    //           color: Colors.blueAccent,
    //           padding: EdgeInsets.all(6),
    //         ),
    //         beforeLineStyle: LineStyle(
    //           color: index == statusHistories.length - 1
    //               ? Colors.transparent
    //               : Colors.blueAccent, // Tidak ada garis sebelum item pertama
    //           thickness: index == statusHistories.length - 1
    //               ? 0
    //               : 3, // Tidak ada garis sebelum item pertama
    //         ),
    //         afterLineStyle: LineStyle(
    //           color: index == 0
    //               ? Colors.transparent
    //               : Colors.blueAccent, // Tidak ada garis setelah item terakhir
    //           thickness:
    //               index == 0 ? 0 : 3, // Tidak ada garis setelah item terakhir
    //         ),
    //         endChild: Container(
    //           margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    //           padding: const EdgeInsets.all(16),
    //           decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.circular(12),
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Colors.black12,
    //                 blurRadius: 6,
    //                 offset: const Offset(0, 3),
    //               ),
    //             ],
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 item['status'] ?? '',
    //                 style: const TextStyle(
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //               const SizedBox(height: 6),
    //               Text(
    //                 'Waktu: ${item['formatted_time']}',
    //                 style: const TextStyle(
    //                   fontSize: 14,
    //                   color: Colors.grey,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }

// untuk menentukan warna berdasarkan status
  Color _getStatusColor(String status) {
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
        return Colors.black87;
    }
  }

  bool get isLastStatusPesananSelesai {
    if (statusHistories.isEmpty) return false;
    final lastStatus = statusHistories.last['status'];
    return lastStatus == 'Pesanan selesai';
  }

  String formatUtcToWib(String utcString) {
    // parsing dari String ke DateTime UTC
    final utcDate = DateTime.parse(utcString).toUtc();

    // tambah 7 jam untuk WIB
    final wibDate = utcDate.add(const Duration(hours: 7));

    // format indonesia
    final formatter = DateFormat('d MMMM y, HH:mm', 'id_ID');

    return formatter.format(wibDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Transaction Status Detail',
      //       style: TextStyle(
      //           fontSize: 22,
      //           fontWeight: FontWeight.bold,
      //           color: Colors.white)),
      //   centerTitle: true,
      //   backgroundColor: Colors.blue,
      // ),

      appBar: AppBar(
        title: const Text(
          'Transaction Status Detail',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white, // Warna ikon back diatur jadi putih
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Visibility(
                      //   visible:
                      //   // transaction
                      //   //     .isFinal, 
                      //   transaction?.isFinal ?? false,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       ElevatedButton.icon(
                      //         onPressed: _showAddStatusDialog,
                      //         icon: const Icon(Icons.add, color: Colors.white),
                      //         label: const Text('Add',
                      //             style: TextStyle(color: Colors.white)),
                      //         style: ElevatedButton.styleFrom(
                      //             backgroundColor: Colors.green),
                      //       ),
                      //       ElevatedButton(
                      //         onPressed: isLastStatusPesananSelesai
                      //             ? _finalSave
                      //             : null,
                      //         style: ElevatedButton.styleFrom(
                      //           backgroundColor: isLastStatusPesananSelesai
                      //               ? Colors.blue
                      //               : Colors.grey[700],
                      //         ),
                      //         child: const Text('Final Save',
                      //             style: TextStyle(color: Colors.white)),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     ElevatedButton.icon(
                      //       onPressed: _showAddStatusDialog,
                      //       icon: const Icon(
                      //         Icons.add,
                      //         color: Colors.white,
                      //       ),
                      //       label: const Text(
                      //         'Add',
                      //         style: TextStyle(color: Colors.white),
                      //       ),
                      //       style: ElevatedButton.styleFrom(
                      //           backgroundColor: Colors.green),
                      //     ),
                      //     ElevatedButton(
                      //       onPressed:
                      //           isLastStatusPesananSelesai ? _finalSave : null,
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: isLastStatusPesananSelesai
                      //             ? Colors.blue
                      //             : Colors.grey[700],
                      //       ),
                      //       child: const Text(
                      //         'Final Save',
                      //         style: TextStyle(color: Colors.white),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      isTransactionFinal
                          ? const SizedBox() // Tombol tidak ditampilkan jika sudah final
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _showAddStatusDialog,
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Tambah Proses',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                ),
                                ElevatedButton(
                                  onPressed: isLastStatusPesananSelesai
                                      ? _finalSave
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isLastStatusPesananSelesai
                                        ? Colors.blue
                                        : Colors.grey[700],
                                  ),
                                  child: const Text(
                                    'Final Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),

                      // transaction?.isFinal != 'Sudah selesai'
                      //     ? Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //         children: [
                      //           ElevatedButton.icon(
                      //             onPressed: _showAddStatusDialog,
                      //             icon: const Icon(
                      //               Icons.add,
                      //               color: Colors.white,
                      //             ),
                      //             label: const Text(
                      //               'Add',
                      //               style: TextStyle(color: Colors.white),
                      //             ),
                      //             style: ElevatedButton.styleFrom(
                      //               backgroundColor: Colors.green,
                      //             ),
                      //           ),
                      //           ElevatedButton(
                      //             onPressed: isLastStatusPesananSelesai
                      //                 ? _finalSave
                      //                 : null,
                      //             style: ElevatedButton.styleFrom(
                      //               backgroundColor: isLastStatusPesananSelesai
                      //                   ? Colors.blue
                      //                   : Colors.grey[700],
                      //             ),
                      //             child: const Text(
                      //               'Final Save',
                      //               style: TextStyle(color: Colors.white),
                      //             ),
                      //           ),
                      //         ],
                      //       )
                      //     : const SizedBox
                      //         .shrink(), // Mengembalikan widget kosong jika sudah final

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     if (transaction?.isFinal != 'Sudah selesai') ...[
                      //       ElevatedButton.icon(
                      //         onPressed: _showAddStatusDialog,
                      //         icon: const Icon(
                      //           Icons.add,
                      //           color: Colors.white,
                      //         ),
                      //         label: const Text(
                      //           'Add',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //         style: ElevatedButton.styleFrom(
                      //             backgroundColor: Colors.green),
                      //       ),
                      //       ElevatedButton(
                      //         onPressed: isLastStatusPesananSelesai
                      //             ? _finalSave
                      //             : null,
                      //         style: ElevatedButton.styleFrom(
                      //           backgroundColor: isLastStatusPesananSelesai
                      //               ? Colors.blue
                      //               : Colors.grey[700],
                      //         ),
                      //         child: const Text(
                      //           'Final Save',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //       ),
                      //     ],
                      //   ],
                      // ),

                      // Row(
                      //   children: [
                      //     if (!isLastStatusPesananSelesai)
                      //       ElevatedButton.icon(
                      //         onPressed: _showAddStatusDialog,
                      //         icon: const Icon(
                      //           Icons.add,
                      //           color: Colors.white,
                      //         ),
                      //         label: const Text(
                      //           'Add',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //         style: ElevatedButton.styleFrom(
                      //           backgroundColor: Colors.green,
                      //         ),
                      //       ),
                      //   ],
                      // ),

                      // const Text('Transaction Status',
                      //     style: TextStyle(
                      //         fontSize: 20, fontWeight: FontWeight.bold)),
                      // Container(
                      //   padding: const EdgeInsets.all(16),
                      //   decoration: BoxDecoration(
                      //     color: Colors.grey[200],
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: Colors.grey),
                      //   ),
                      //   child: Text(
                      //     statusHistories.isNotEmpty
                      //         ? statusHistories.last['status']
                      //         : 'No status available',
                      //     style: const TextStyle(fontSize: 16),
                      //   ),
                      // ),

                      // _buildTransactionStatus(statusHistories)
                      _buildTransactionStatus(
                          statusHistories.cast<Map<String, dynamic>>())
                    ],
                  ),
                ),
                const SizedBox(height: 1),
                const Text(
                  'History',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(
                  height: 30,
                ),
                // Expanded(
                //   child: ListView.builder(
                //     reverse:
                //         true, // Makes the list start from the latest status
                //     itemCount: statusHistories.length,
                //     itemBuilder: (context, index) {
                //       final item = statusHistories[index];
                //       // return TimelineTile(
                //       //   alignment: TimelineAlign.manual,
                //       //   lineXY: 0.1,
                //       //   isFirst: index == 0,
                //       //   isLast: index == statusHistories.length - 1,
                //       //   indicatorStyle: const IndicatorStyle(
                //       //     width: 20,
                //       //     color: Colors.blueAccent,
                //       //     padding: EdgeInsets.all(6),
                //       //   ),
                //       //   beforeLineStyle: const LineStyle(
                //       //     color: Colors.blueAccent,
                //       //     thickness: 3,
                //       //   ),
                //       //   endChild: Container(
                //       //     margin: const EdgeInsets.symmetric(
                //       //         vertical: 8, horizontal: 12),
                //       //     padding: const EdgeInsets.all(16),
                //       //     decoration: BoxDecoration(
                //       //       color: Colors.white,
                //       //       borderRadius: BorderRadius.circular(12),
                //       //       boxShadow: [
                //       //         BoxShadow(
                //       //           color: Colors.black12,
                //       //           blurRadius: 6,
                //       //           offset: const Offset(0, 3),
                //       //         ),
                //       //       ],
                //       //     ),
                //       //     child: Column(
                //       //       crossAxisAlignment: CrossAxisAlignment.start,
                //       //       children: [
                //       //         Text(
                //       //           item['status'] ?? '',
                //       //           style: const TextStyle(
                //       //             fontSize: 16,
                //       //             fontWeight: FontWeight.bold,
                //       //           ),
                //       //         ),
                //       //         const SizedBox(height: 6),
                //       //         Text(
                //       //           'Waktu: ${formatUtcToWib(item['changed_at'])}',
                //       //           style: const TextStyle(
                //       //             fontSize: 14,
                //       //             color: Colors.grey,
                //       //           ),
                //       //         ),
                //       //       ],
                //       //     ),
                //       //   ),
                //       // );

                //       // return TimelineTile(
                //       //   alignment: TimelineAlign.manual,
                //       //   lineXY: 0.1,
                //       //   isFirst: index == 0,
                //       //   isLast: index == statusHistories.length - 1,
                //       //   indicatorStyle: const IndicatorStyle(
                //       //     width: 20,
                //       //     color: Colors.blueAccent,
                //       //     padding: EdgeInsets.all(6),
                //       //   ),
                //       //   beforeLineStyle: LineStyle(
                //       //     color: index == 0
                //       //         ? Colors.transparent
                //       //         : Colors
                //       //             .blueAccent, // Make the first line invisible
                //       //     thickness: 3,
                //       //   ),
                //       //   afterLineStyle: LineStyle(
                //       //     color: index == statusHistories.length - 1
                //       //         ? Colors.transparent
                //       //         : Colors
                //       //             .blueAccent, // Make the last line invisible
                //       //     thickness: 3,
                //       //   ),
                //       //   endChild: Container(
                //       //     margin: const EdgeInsets.symmetric(
                //       //         vertical: 8, horizontal: 12),
                //       //     padding: const EdgeInsets.all(16),
                //       //     decoration: BoxDecoration(
                //       //       color: Colors.white,
                //       //       borderRadius: BorderRadius.circular(12),
                //       //       boxShadow: [
                //       //         BoxShadow(
                //       //           color: Colors.black12,
                //       //           blurRadius: 6,
                //       //           offset: const Offset(0, 3),
                //       //         ),
                //       //       ],
                //       //     ),
                //       //     child: Column(
                //       //       crossAxisAlignment: CrossAxisAlignment.start,
                //       //       children: [
                //       //         Text(
                //       //           item['status'] ?? '',
                //       //           style: const TextStyle(
                //       //             fontSize: 16,
                //       //             fontWeight: FontWeight.bold,
                //       //           ),
                //       //         ),
                //       //         const SizedBox(height: 6),
                //       //         Text(
                //       //           'Waktu: ${formatUtcToWib(item['changed_at'])}',
                //       //           style: const TextStyle(
                //       //             fontSize: 14,
                //       //             color: Colors.grey,
                //       //           ),
                //       //         ),
                //       //       ],
                //       //     ),
                //       //   ),
                //       // );

                //       return TimelineTile(
                //         alignment: TimelineAlign.manual,
                //         lineXY: 0.1,
                //         isFirst: index == statusHistories.length - 1,
                //         isLast: index == 0,
                //         indicatorStyle: const IndicatorStyle(
                //           width: 20,
                //           color: Colors.blueAccent,
                //           padding: EdgeInsets.all(6),
                //         ),
                //         beforeLineStyle: LineStyle(
                //           color: index == statusHistories.length - 1
                //               ? Colors.transparent
                //               : Colors
                //                   .blueAccent, // Tidak ada garis sebelum item pertama
                //           thickness: index == statusHistories.length - 1
                //               ? 0
                //               : 3, // Tidak ada garis sebelum item pertama
                //         ),
                //         afterLineStyle: LineStyle(
                //           color: index == 0
                //               ? Colors.transparent
                //               : Colors
                //                   .blueAccent, // Tidak ada garis setelah item terakhir
                //           thickness: index == 0
                //               ? 0
                //               : 3, // Tidak ada garis setelah item terakhir
                //         ),
                //         endChild: Container(
                //           margin: const EdgeInsets.symmetric(
                //               vertical: 8, horizontal: 12),
                //           padding: const EdgeInsets.all(16),
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(12),
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Colors.black12,
                //                 blurRadius: 6,
                //                 offset: const Offset(0, 3),
                //               ),
                //             ],
                //           ),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 item['status'] ?? '',
                //                 style: const TextStyle(
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //               const SizedBox(height: 6),
                //               Text(
                //                 'Waktu: ${formatUtcToWib(item['changed_at'])}',
                //                 style: const TextStyle(
                //                   fontSize: 14,
                //                   color: Colors.grey,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),

                // Container(
                //   padding: const EdgeInsets.all(16),
                //   margin: const EdgeInsets.all(8),
                //   decoration: BoxDecoration(
                //     color: Colors.grey.shade200,
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Expanded(
                //     child: ListView.builder(
                //       reverse:
                //           true, // Makes the list start from the latest status
                //       itemCount: statusHistories.length,
                //       itemBuilder: (context, index) {
                //         final item = statusHistories[index];

                //         return TimelineTile(
                //           alignment: TimelineAlign.manual,
                //           lineXY: 0.1,
                //           isFirst: index == statusHistories.length - 1,
                //           isLast: index == 0,
                //           indicatorStyle: const IndicatorStyle(
                //             width: 20,
                //             color: Colors.blueAccent,
                //             padding: EdgeInsets.all(6),
                //           ),
                //           beforeLineStyle: LineStyle(
                //             color: index == statusHistories.length - 1
                //                 ? Colors.transparent
                //                 : Colors
                //                     .blueAccent, // Tidak ada garis sebelum item pertama
                //             thickness: index == statusHistories.length - 1
                //                 ? 0
                //                 : 3, // Tidak ada garis sebelum item pertama
                //           ),
                //           afterLineStyle: LineStyle(
                //             color: index == 0
                //                 ? Colors.transparent
                //                 : Colors
                //                     .blueAccent, // Tidak ada garis setelah item terakhir
                //             thickness: index == 0
                //                 ? 0
                //                 : 3, // Tidak ada garis setelah item terakhir
                //           ),
                //           endChild: Container(
                //             margin: const EdgeInsets.symmetric(
                //                 vertical: 8, horizontal: 12),
                //             padding: const EdgeInsets.all(16),
                //             decoration: BoxDecoration(
                //               color: Colors.white,
                //               borderRadius: BorderRadius.circular(12),
                //               boxShadow: [
                //                 BoxShadow(
                //                   color: Colors.black12,
                //                   blurRadius: 6,
                //                   offset: const Offset(0, 3),
                //                 ),
                //               ],
                //             ),
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text(
                //                   item['status'] ?? '',
                //                   style: const TextStyle(
                //                     fontSize: 16,
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //                 const SizedBox(height: 6),
                //                 Text(
                //                   'Waktu: ${formatUtcToWib(item['changed_at'])}',
                //                   style: const TextStyle(
                //                     fontSize: 14,
                //                     color: Colors.grey,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                // ),

                _buildTimelineStatus(
                    statusHistories.cast<Map<String, dynamic>>())
              ],
            ),
    );
  }

  // void _showAddStatusDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Tambah Status Baru'),
  //       content: DropdownButtonFormField<String>(
  //         value: selectedStatus,
  //         items: availableStatuses.map((status) {
  //           return DropdownMenuItem(
  //             value: status,
  //             child: Text(status),
  //           );
  //         }).toList(),
  //         onChanged: (value) {
  //           setState(() {
  //             selectedStatus = value; // Update selectedStatus
  //             print('Selected Status: $selectedStatus'); // Debug log
  //           });
  //         },
  //         decoration: const InputDecoration(
  //           labelText: 'Pilih Status',
  //           border: OutlineInputBorder(),
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Batal'),
  //         ),
  //         ElevatedButton(
  //           onPressed: selectedStatus == null ? null : _addStatus,
  //           child: const Text('Tambah'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showAddStatusDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Tambah Status Baru'),
            content: DropdownButtonFormField<String>(
              value: selectedStatus,
              items: availableStatuses.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value; // Update selectedStatus
                });
              },
              decoration: const InputDecoration(
                labelText: 'Pilih Status',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: selectedStatus == null ? null : _addStatus,
                child: const Text('Tambah'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addStatus() async {
    Navigator.pop(context); 

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$responseUrl/api/transactions/${widget.transactionId}/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': selectedStatus}),
    );

    if (response.statusCode == 200) {
      setState(() {
        selectedStatus = null;
      });
      fetchStatusHistory();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Status ini sudah pernah ditambahkan ke riwayat transaksi.')),
      );
    }
  }

  void _finalSave() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse(
          '$responseUrl/api/transactions/${widget.transactionId}/final-save'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        isFinalSaved = true;
        isTransactionFinal = true; 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Final save berhasil!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal final save')),
      );
    }
  }
}
