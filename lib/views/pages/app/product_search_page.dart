// import 'package:flutter/material.dart';
// import 'package:ta_c14210052/constant/api_url.dart';
// import 'package:ta_c14210052/models/product.dart';
// import 'package:ta_c14210052/views/product_detail_screen.dart';

// class ProductSearchPage extends StatefulWidget {
//   final List<Product> products;

//   const ProductSearchPage({Key? key, required this.products}) : super(key: key);

//   @override
//   _ProductSearchPageState createState() => _ProductSearchPageState();
// }

// class _ProductSearchPageState extends State<ProductSearchPage> {
//   TextEditingController _searchController = TextEditingController();
//   List<Product> _filteredProducts = [];

//   @override
//   void initState() {
//     super.initState();
//     _filteredProducts = widget.products;
//     _searchController.addListener(_filterProducts);
//   }

//   void _filterProducts() {
//     String query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredProducts = widget.products.where((product) {
//         return product.name.toLowerCase().contains(query) ||
//             product.stock.toString().contains(query) ||
//             product.price.toString().contains(query) ||
//             product.exp_date.toLowerCase().contains(query);
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         backgroundColor: Colors.blue,
//         title: TextField(
//           controller: _searchController,
//           decoration: InputDecoration(
//             hintText: "Search products...",
//             hintStyle: TextStyle(color: Colors.white70),
//             border: InputBorder.none,
//           ),
//           style: TextStyle(color: Colors.white),
//           cursorColor: Colors.white,
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(8),
//         child: ListView.builder(
//           itemCount: _filteredProducts.length,
//           itemBuilder: (context, index) {
//             final product = _filteredProducts[index];
//             return GestureDetector(
//                 onTap: () {
//                   // Navigasi ke halaman detail produk
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           ProductDetailScreen(product: product),
//                     ),
//                   );
//                 },
//                 child: Card(
//                   margin: EdgeInsets.symmetric(vertical: 8),
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Padding(
//                     padding: EdgeInsets.all(12),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // ClipRRect(
//                         //   borderRadius: BorderRadius.circular(8),
//                         //   child: Image.asset(
//                         //     'assets/images/product.png',
//                         //     width: 80,
//                         //     height: 80,
//                         //     fit: BoxFit.cover,
//                         //   ),
//                         // ),

//                         ClipRRect(
//                             borderRadius:
//                                 BorderRadius.vertical(top: Radius.circular(12)),
//                             child: Image(
//                               image: product.imageUrl.isNotEmpty
//                                   ? NetworkImage(
//                                       "${responseUrl}/storage/${product.imageUrl}")
//                                   : AssetImage('assets/images/product.png')
//                                       as ImageProvider,
//                               width: 80,
//                               height: 80,
//                               fit: BoxFit.cover,
//                             )),
//                         SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 product.name,
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(height: 5),
//                               Text(
//                                 product.description,
//                                 style: TextStyle(
//                                     fontSize: 14, color: Colors.grey[600]),
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 2,
//                               ),
//                               SizedBox(height: 5),
//                               Row(
//                                 children: [
//                                   Text(
//                                     "Stock: ${product.stock}",
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Spacer(),
//                                   Text(
//                                     "Rp ${product.price.toStringAsFixed(0)}",
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.blue),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 5),
//                               Text(
//                                 "Expired Date: ${product.exp_date}",
//                                 style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.red),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:ta_c14210052/constant/api_url.dart';
// import 'package:ta_c14210052/models/product.dart';
// import 'package:ta_c14210052/views/product_detail_screen.dart';

// class ProductSearchPage extends StatefulWidget {
//   final List<Product> products;

//   const ProductSearchPage({Key? key, required this.products}) : super(key: key);

//   @override
//   _ProductSearchPageState createState() => _ProductSearchPageState();
// }

// class _ProductSearchPageState extends State<ProductSearchPage> {
//   TextEditingController _searchController = TextEditingController();
//   List<Product> _filteredProducts = [];

//   @override
//   void initState() {
//     super.initState();
//     _filteredProducts = widget.products;
//     _searchController.addListener(_filterProducts);
//   }

//   void _filterProducts() {
//     String query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredProducts = widget.products.where((product) {
//         return product.name.toLowerCase().contains(query) ||
//             product.stock.toString().contains(query) ||
//             product.price.toString().contains(query) ||
//             product.exp_date.toLowerCase().contains(query);
//       }).toList();
//     });
//   }

//   bool isExpiringSoon(String expDate) {
//     try {
//       DateTime exp = DateFormat("yyyy-MM-dd").parse(expDate);
//       DateTime now = DateTime.now();
//       return exp.isBefore(now.add(Duration(days: 90)));
//     } catch (e) {
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         backgroundColor: Colors.blue,
//         title: TextField(
//           controller: _searchController,
//           decoration: InputDecoration(
//             hintText: "Search products...",
//             hintStyle: TextStyle(color: Colors.white70),
//             border: InputBorder.none,
//           ),
//           style: TextStyle(color: Colors.white),
//           cursorColor: Colors.white,
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(8),
//         child: ListView.builder(
//           itemCount: _filteredProducts.length,
//           itemBuilder: (context, index) {
//             final product = _filteredProducts[index];
//             bool expiringSoon = isExpiringSoon(product.exp_date);

//             return GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProductDetailScreen(product: product),
//                   ),
//                 );
//               },
//               child: Card(
//                 margin: EdgeInsets.symmetric(vertical: 8),
//                 elevation: 3,
//                 color: expiringSoon ? Colors.orange[100] : Colors.white, // Warna warning
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Padding(
//                   padding: EdgeInsets.all(12),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ClipRRect(
//                           borderRadius:
//                               BorderRadius.vertical(top: Radius.circular(12)),
//                           child: Image(
//                             image: product.imageUrl.isNotEmpty
//                                 ? NetworkImage(
//                                     "${responseUrl}/storage/${product.imageUrl}")
//                                 : AssetImage('assets/images/product.png')
//                                     as ImageProvider,
//                             width: 80,
//                             height: 80,
//                             fit: BoxFit.cover,
//                           )),
//                       SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               product.name,
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               product.description,
//                               style: TextStyle(
//                                   fontSize: 14, color: Colors.grey[600]),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                             SizedBox(height: 5),
//                             Row(
//                               children: [
//                                 Text(
//                                   "Stock: ${product.stock}",
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 Spacer(),
//                                 Text(
//                                   "Rp ${product.price.toStringAsFixed(0)}",
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.blue),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               "Expired Date: ${product.exp_date}",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: expiringSoon ? Colors.red : Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:ta_c14210052/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:ta_c14210052/views/pages/app/product_detail_screen.dart';

class ProductSearchPage extends StatefulWidget {
  final List<Product> products;
  // final Product products;
  // final Product? filteredProducts;

  const ProductSearchPage({super.key, required this.products});

  @override
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  bool isFavorite = false;
  Map<int, bool> _favoriteStatus = {};
  final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.products;
    _searchController.addListener(_filterProducts);
    loadAllFavorites(); 

    // for (var product in widget.products) {
    //   // checkIfFavorite(product.id); // Cek favorite satu-satu
    //   checkIfFavorite(); // Cek favorite satu-satu
    // }
  }

  // Future<void> checkIfFavorite() async {
  //   final token = await getToken();
  //   if (token == null) return;

  //   for (var product in widget.products) {
  //     try {
  //       final response = await http.get(
  //         Uri.parse('$responseUrl/api/check-favorite/${product.id}'),
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           'Accept': 'application/json',
  //         },
  //       );

  //       if (response.statusCode == 200) {
  //         final data = json.decode(response.body);
  //         setState(() {
  //           _favoriteStatus[product.id] = data['isFavorite'];
  //         });
  //       } else {
  //         // Handle error
  //       }
  //     } catch (e) {
  //       // Handle network error
  //     }
  //   }
  // }

  Future<void> toggleFavorite(int productId) async {
    final token = await getToken();
    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse('$responseUrl/api/toggle-favorite/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _favoriteStatus[productId] = !(_favoriteStatus[productId] ?? false);
        });
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle network error
    }
  }

  Future<void> loadAllFavorites() async {
    final token = await getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('$responseUrl/api/user-favorites'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> favoriteIds = data['favoriteProductIds'];

        setState(() {
          _favoriteStatus = {
            for (var id in favoriteIds) id: true,
          };
        });
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle network error
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Retrieve token from SharedPreferences
  }

  void _filterProducts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = widget.products.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.totalStock.toString().contains(query) ||
            product.price.toString().contains(query) ||
            product.fifoExp.toLowerCase().contains(query);
      }).toList();
    });
  }

  bool isExpiringSoon(String expDate) {
    try {
      DateTime exp = DateFormat("yyyy-MM-dd").parse(expDate);
      DateTime now = DateTime.now();
      return exp.isBefore(now.add(
          const Duration(days: 90))); 
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue,
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search products...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            final product = _filteredProducts[index];
            bool expiringSoon = isExpiringSoon(product.fifoExp);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                color: expiringSoon
                    ? Colors.orange[100]
                    : Colors.white, // Warna warning jika expiring soon
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: Image(
                          image: product.imageUrl.isNotEmpty
                              ? NetworkImage(
                                  "$responseUrl/storage/${product.imageUrl}")
                              : const AssetImage('assets/images/product.png')
                                  as ImageProvider,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product.description,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  "Total Stock: ${product.totalStock}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(
                                  "${formatCurrency.format(product.price)}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  "Exp Date: ${product.fifoExp}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: expiringSoon
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                                const Spacer(),
                                // IconButton(
                                //   icon: isFavorite
                                //       ? const Icon(
                                //           Icons.favorite,
                                //           color: Colors.red,
                                //         )
                                //       : const Icon(
                                //           Icons.favorite_border,
                                //           color: Colors.grey,
                                //         ),
                                //   onPressed: toggleFavorite,
                                // ),

                                // IconButton(
                                //   icon: favorites[product.id] == true
                                //       ? const Icon(Icons.favorite,
                                //           color: Colors.red)
                                //       : const Icon(Icons.favorite_border,
                                //           color: Colors.grey),
                                //   onPressed: () {
                                //     toggleFavorite(product.id);
                                //   },
                                // ),

                                IconButton(
                                  icon: (_favoriteStatus[product.id] ?? false)
                                      ? const Icon(Icons.favorite,
                                          color: Colors.red)
                                      : const Icon(Icons.favorite_border,
                                          color: Colors.grey),
                                  onPressed: () {
                                    toggleFavorite(product.id);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
