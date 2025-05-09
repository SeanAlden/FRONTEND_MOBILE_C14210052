import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:ta_c14210052/models/transaction_response.dart';
import 'package:ta_c14210052/views/pages/app/transaction_detail_page.dart';
import 'package:ta_c14210052/widgets/transaction_item_card.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  List<TransactionResponse> transactionList = [];
  List<TransactionResponse> filteredTransactionList = [];
  bool isLoading = true;
  String searchQuery = '';
  DateTime? selectedDate;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  // Future<void> fetchTransactions() async {
  //   final getUrl = Uri.parse('$responseUrl/api/transactions');
  //   final token = await getToken();

  //   try {
  //     final response = await http.get(
  //       getUrl,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       final List<dynamic> data = jsonResponse['transactions'];

  //       setState(() {
  //         transactionList =
  //             data.map((json) => TransactionResponse.fromJson(json)).toList();
  //         filteredTransactionList = transactionList;
  //         isLoading = false;
  //       });
  //     } else {
  //       print('Gagal load transaksi: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error fetchTransactions: $e');
  //   }
  // }

  Future<void> fetchTransactions() async {
    final getUrl = Uri.parse('$responseUrl/api/transactions');
    final token = await getToken();

    try {
      final response = await http.get(
        getUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['transactions'];

        setState(() {
          transactionList =
              data.map((json) => TransactionResponse.fromJson(json)).toList();

          // Urutkan transaksi dari yang terbaru ke yang terlama
          transactionList.sort((a, b) => b.transaction.transactionDate
              .compareTo(a.transaction.transactionDate));

          filteredTransactionList = transactionList;
          isLoading = false;
        });
      } else {
        print('Gagal load transaksi: ${response.body}');
      }
    } catch (e) {
      print('Error fetchTransactions: $e');
    }
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  // void filterTransactions() {
  //   List<TransactionResponse> tempList = transactionList.where((transaction) {
  //     final transactionCode =
  //         transaction.transaction.transactionCode?.toLowerCase() ?? '';
  //     final transactionStatus =
  //         transaction.transaction.status?.toLowerCase() ?? '';
  //     final transactionProducts = transaction.transaction.details
  //         .map((d) => d.name?.toLowerCase() ?? '')
  //         .join(' ');
  //     final transactionShippingMethod =
  //         transaction.transaction.shippingMethod?.toLowerCase() ?? '';
  //     final transactionPaymentMethod =
  //         transaction.transaction.paymentMethod?.toLowerCase() ?? '';

  //     bool matchesSearch =
  //         transactionCode.contains(searchQuery.toLowerCase()) ||
  //             transactionStatus.contains(searchQuery.toLowerCase()) ||
  //             transactionShippingMethod.contains(searchQuery.toLowerCase()) ||
  //             transactionPaymentMethod.contains(searchQuery.toLowerCase()) ||
  //             transactionProducts.contains(searchQuery.toLowerCase());

  //     bool matchesDate = true;
  //     if (selectedDate != null) {
  //       final transactionDate = transaction.transaction.transactionDate;
  //       matchesDate = transactionDate.year == selectedDate!.year &&
  //           transactionDate.month == selectedDate!.month &&
  //           transactionDate.day == selectedDate!.day;
  //     }

  //     return matchesSearch && matchesDate;
  //   }).toList();

  //   setState(() {
  //     filteredTransactionList = tempList;
  //   });
  // }

  void filterTransactions() {
    List<TransactionResponse> tempList = transactionList.where((transaction) {
      final t = transaction.transaction;
      final transactionCode = t.transactionCode?.toLowerCase() ?? '';
      final transactionStatus = t.status?.toLowerCase() ?? '';
      final transactionProducts =
          t.details.map((d) => d.name?.toLowerCase() ?? '').join(' ');
      final transactionShippingMethod = t.shippingMethod?.toLowerCase() ?? '';
      final transactionPaymentMethod = t.paymentMethod?.toLowerCase() ?? '';
      final transactionDate = t.transactionDate;

      bool matchesSearch =
          transactionCode.contains(searchQuery.toLowerCase()) ||
              transactionStatus.contains(searchQuery.toLowerCase()) ||
              transactionShippingMethod.contains(searchQuery.toLowerCase()) ||
              transactionPaymentMethod.contains(searchQuery.toLowerCase()) ||
              transactionProducts.contains(searchQuery.toLowerCase());

      bool matchesDate = true;
      if (startDate != null && endDate != null) {
        matchesDate = transactionDate
                .isAfter(startDate!.subtract(const Duration(seconds: 1))) &&
            transactionDate.isBefore(endDate!.add(const Duration(days: 1)));
      }

      return matchesSearch && matchesDate;
    }).toList();

    setState(() {
      filteredTransactionList = tempList;
    });
  }

  // Future<void> pickDate() async {
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate ?? DateTime.now().toLocal(),
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime.now().toLocal(),
  //     helpText: 'Select Transaction Date',
  //   );

  //   if (picked != null) {
  //     // Tambahkan 7 jam supaya WIB
  //     picked = picked.add(const Duration(hours: 7));

  //     setState(() {
  //       selectedDate = picked;
  //     });
  //     filterTransactions();
  //   }
  // }

  Future<void> pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Select Transaction Date Range',
    );

    if (picked != null) {
      setState(() {
        // Tambahkan 7 jam agar sesuai WIB jika perlu
        startDate = picked.start.add(const Duration(hours: 7));
        endDate = picked.end.add(const Duration(hours: 7));
      });
      filterTransactions();
    }
  }

  // void clearFilters() {
  //   setState(() {
  //     searchQuery = '';
  //     selectedDate = null;
  //     filteredTransactionList = transactionList;
  //   });
  // }

  void clearFilters() {
    setState(() {
      searchQuery = '';
      startDate = null;
      endDate = null;
      filteredTransactionList = transactionList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transactions',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Search Bar
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                              filterTransactions();
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search...',
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Date Picker Icon
                      // IconButton(
                      //   onPressed: pickDate,
                      //   icon: const Icon(Icons.calendar_today),
                      //   tooltip: selectedDate == null
                      //       ? 'Filter by Date'
                      //       : DateFormat('dd/MM/yyyy').format(selectedDate!),
                      // ),

                      IconButton(
                        onPressed: pickDateRange,
                        icon: const Icon(Icons.calendar_today),
                        tooltip: (startDate == null || endDate == null)
                            ? 'Filter by Date Range'
                            : '${DateFormat('dd/MM/yyyy').format(startDate!)} - ${DateFormat('dd/MM/yyyy').format(endDate!)}',
                      ),

                      // Clear Filters
                      IconButton(
                        onPressed: clearFilters,
                        icon: const Icon(Icons.clear),
                        tooltip: 'Clear Filters',
                      ),
                    ],
                  ),
                ),
                // if (selectedDate != null)
                //   Padding(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                //     child: Row(
                //       children: [
                //         const Icon(Icons.date_range,
                //             size: 20, color: Colors.blue),
                //         const SizedBox(width: 4),
                //         Text(
                //           DateFormat('dd/MM/yyyy').format(selectedDate!),
                //           style:
                //               const TextStyle(fontSize: 14, color: Colors.blue),
                //         ),
                //       ],
                //     ),
                //   ),

                if (startDate != null && endDate != null)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range,
                            size: 20, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          '${DateFormat('dd/MM/yyyy').format(startDate!)} - ${DateFormat('dd/MM/yyyy').format(endDate!)}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),

                Expanded(
                  child: filteredTransactionList.isEmpty
                      ? const Center(child: Text('No transactions found.'))
                      : ListView.builder(
                          itemCount: filteredTransactionList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              // onTap: () {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => TransactionDetailPage(
                              //         transactionId:
                              //             filteredTransactionList[index]
                              //                 .transaction
                              //                 .id,
                              //       ),
                              //     ),
                              //   );
                              // },

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TransactionDetailPage(
                                      transactionId:
                                          filteredTransactionList[index]
                                              .transaction
                                              .id,
                                    ),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    fetchTransactions();
                                  });
                                });
                              },
                              child: TransactionItemCard(
                                  transactionResponse:
                                      filteredTransactionList[index],
                                  onRefresh: fetchTransactions),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
