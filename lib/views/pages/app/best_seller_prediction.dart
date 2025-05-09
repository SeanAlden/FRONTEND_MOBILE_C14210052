// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:ta_c14210052/constant/api_url.dart';

// class BestSellerPrediction extends StatefulWidget {
//   @override
//   _BestSellerPredictionState createState() => _BestSellerPredictionState();
// }

// class _BestSellerPredictionState extends State<BestSellerPrediction> {
//   List<dynamic> products = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchBestSellers();
//   }

//   Future<void> fetchBestSellers() async {
//     final url = Uri.parse("${responseUrl}/api/analysis/results");

//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           products = data['products'].entries.map((entry) {
//             return {
//               'id': entry.key,
//               'name': entry.value['name'],
//               'code': entry.value['code'],
//               'price': entry.value['price'],
//               'photo': entry.value['photo'],
//               'condition': entry.value['condition'],
//               'accuracy': data['accuracy'][entry.key] ?? 0.0,
//             };
//           }).toList();
//           isLoading = false;
//         });
//       } else {
//         throw Exception("Failed to load predictions");
//       }
//     } catch (e) {
//       print("Error: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text("Best Seller Prediction"),
//       //   backgroundColor: Colors.deepPurple,
//       // ),
//       appBar: AppBar(
//           title: Text('Best Seller Prediction',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
//           centerTitle: true,
//           backgroundColor: Colors.blue,
//         ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : products.isEmpty
//               ? Center(child: Text("Tidak ada data prediksi"))
//               : ListView.builder(
//                   padding: EdgeInsets.all(10),
//                   itemCount: products.length,
//                   itemBuilder: (context, index) {
//                     final product = products[index];
//                     return Card(
//                       elevation: 4,
//                       margin: EdgeInsets.symmetric(vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ListTile(
//                         contentPadding: EdgeInsets.all(10),
//                         leading: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(
//                             "${responseUrl}/storage/${product['photo']}" ?? "assets/images/product.png",
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         title: Text(
//                           product['name'],
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Kode: ${product['code']}"),
//                             Text("Harga: Rp${product['price']}"),
//                             Text(
//                               "Kondisi: ${product['condition']}",
//                               style: TextStyle(
//                                 color: product['condition'] == "active"
//                                     ? Colors.green
//                                     : Colors.red,
//                               ),
//                             ),
//                             Text(
//                               "Akurasi: ${product['accuracy']}%",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.blue),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:ta_c14210052/constant/api_url.dart';

// class BestSellerPrediction extends StatefulWidget {
//   @override
//   _BestSellerPredictionState createState() => _BestSellerPredictionState();
// }

// class _BestSellerPredictionState extends State<BestSellerPrediction> {
//   List<dynamic> products = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchBestSellers();
//   }

//   Future<void> fetchBestSellers() async {
//     final url = Uri.parse("${responseUrl}/api/analysis/results");

//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           products = data['products'].entries.map((entry) {
//             return {
//               'id': entry.key,
//               'name': entry.value['name'],
//               'code': entry.value['code'],
//               'price': entry.value['price'],
//               'photo': entry.value['photo'],
//               'condition': entry.value['condition'],
//               'accuracy': data['accuracy'][entry.key] ?? 0.0,
//             };
//           }).toList();
//           isLoading = false;
//         });
//       } else {
//         throw Exception("Failed to load predictions");
//       }
//     } catch (e) {
//       print("Error: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Best Seller Prediction',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : products.isEmpty
//               ? Center(child: Text("Tidak ada data prediksi"))
//               : ListView.builder(
//                   padding: EdgeInsets.all(10),
//                   itemCount: products.length,
//                   itemBuilder: (context, index) {
//                     final product = products[index];
//                     return Card(
//                       elevation: 5,
//                       margin: EdgeInsets.symmetric(vertical: 10),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: Image.network(
//                                 "${responseUrl}/storage/${product['photo']}" ?? "assets/images/product.png",
//                                 width: 100,
//                                 height: 100,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     product['name'],
//                                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                                   ),
//                                   SizedBox(height: 5),
//                                   Text("Kode: ${product['code']}", style: TextStyle(color: Colors.grey[700])),
//                                   Text("Harga: Rp${product['price']}", style: TextStyle(color: Colors.grey[700])),
//                                   Text(
//                                     "Kondisi: ${product['condition']}",
//                                     style: TextStyle(
//                                       color: product['condition'] == "active" ? Colors.green : Colors.red,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     "Akurasi: ${product['accuracy']}%",
//                                     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ta_c14210052/constant/api_url.dart';

class BestSellerPrediction extends StatefulWidget {
  const BestSellerPrediction({super.key});

  @override
  _BestSellerPredictionState createState() => _BestSellerPredictionState();
}

class _BestSellerPredictionState extends State<BestSellerPrediction> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBestSellers();
  }

  Future<void> fetchBestSellers() async {
    final url = Uri.parse("$responseUrl/api/analysis/results");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          products = data['products'].entries.map((entry) {
            return {
              'id': entry.key,
              'name': entry.value['name'],
              'code': entry.value['code'],
              'price': entry.value['price'],
              'photo': entry.value['photo'],
              'condition': entry.value['condition'],
              'accuracy': data['accuracy'][entry.key] ?? 0.0,
            };
          }).toList();

          // Pengurutan secara descending 
          products.sort((a, b) =>
              (b['accuracy'].toDouble()).compareTo(a['accuracy'].toDouble()));

          isLoading = false;
        });
      } else {
        throw Exception("Failed to load predictions");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Color getAccuracyBackgroundColor(double accuracy) {
    if (accuracy >= 75) {
      return Colors.blue.shade100;
    } else if (accuracy >= 50) {
      return Colors.yellow.shade100;
    } else if (accuracy >= 25) {
      return Colors.orange.shade100;
    } else {
      return Colors.red.shade100;
    }
  }

  Color getAccuracyTextColor(double accuracy) {
    if (accuracy >= 75) {
      return Colors.blue.shade700;
    } else if (accuracy >= 50) {
      return Colors.yellow.shade800;
    } else if (accuracy >= 25) {
      return Colors.orange.shade800;
    } else {
      return Colors.red.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Best Seller Prediction',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(child: Text("Tidak ada data prediksi"))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ClipRRect(
                            //   borderRadius: BorderRadius.circular(12),
                            //   child: Image.network(
                            //     "$responseUrl/storage/${product['photo']}",
                            //     width: 100,
                            //     height: 100,
                            //     fit: BoxFit.cover,
                            //   ),
                            // ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: (product['photo'] != null &&
                                      product['photo'].toString().isNotEmpty)
                                  ? Image.network(
                                      "$responseUrl/storage/${product['photo']}",
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/product.png',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      'assets/images/product.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 5),
                                  Text("Kode: ${product['code']}",
                                      style:
                                          TextStyle(color: Colors.grey[700])),
                                  Text("Harga: Rp${product['price']}",
                                      style:
                                          TextStyle(color: Colors.grey[700])),
                                  Text(
                                    "Kondisi: ${product['condition']}",
                                    style: TextStyle(
                                      color: product['condition'] == "active"
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Text(
                                  //   "Akurasi: ${product['accuracy']}%",
                                  //   style: const TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //       color: Colors.blue),
                                  // ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: getAccuracyBackgroundColor(
                                          product['accuracy'].toDouble()),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "Akurasi: ${product['accuracy']}%",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: getAccuracyTextColor(
                                            product['accuracy'].toDouble()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
