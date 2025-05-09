import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'dart:convert';
import 'package:ta_c14210052/models/product.dart';
import 'package:ta_c14210052/views/pages/app/product_detail_screen.dart';
import 'package:intl/intl.dart';

class ProductScreen extends StatefulWidget {
  final int categoryId;
  final List<Product> products;

  const ProductScreen(
      {super.key, required this.categoryId, required this.products});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> products = [];
  List<Product> _filteredProducts = [];
  Map<int, bool> _favoriteStatus = {};
  bool loading = true;
  String categoryName = "Products";
  final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    fetchCategoryName();
    fetchProducts();
    loadAllFavorites(); 
  }

  Future<void> fetchCategoryName() async {
    try {
      final response = await http
          .get(Uri.parse('$responseUrl/api/categories/${widget.categoryId}'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          categoryName = data['name'];
        });
      }
    } catch (e) {
      setState(() {
        categoryName = "Products";
      });
    }
  }

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

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(
          '$responseUrl/api/active/products/category/${widget.categoryId}'));
      // '${responseUrl}/api/categories/${widget.categoryId}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          final List<dynamic> data = responseData['data'];

          if (mounted) {
            setState(() {
              products = data.map((item) => Product.fromJson(item)).toList();
              _filteredProducts = products;
              loading = false;
            });
          }
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // Future<void> fetchProducts() async {
  //   try {
  //     final response = await http.get(Uri.parse(
  //         '${responseUrl}/api/products/category/${widget.categoryId}'));

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = json.decode(response.body);

  //       if (responseData['success'] == true) {
  //         final List<dynamic> data = responseData['data'];

  //         if (mounted) {
  //           setState(() {
  //             products = data.map((item) => Product.fromJson(item)).toList();
  //             filteredProducts = products;
  //             loading = false;
  //           });
  //         }
  //       } else {
  //         throw Exception(responseData['message']);
  //       }
  //     } else {
  //       throw Exception('Failed to load products');
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() {
  //         loading = false;
  //       });
  //     }
  //   }
  // }

  void filterProducts(String query) {
    setState(() {
      _filteredProducts = products.where((product) {
        final nameMatch =
            product.name.toLowerCase().contains(query.toLowerCase());
        final descriptionMatch =
            product.description.toLowerCase().contains(query.toLowerCase());
        final priceMatch = product.price.toString().contains(query);
        return nameMatch || descriptionMatch || priceMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title:
              Text(categoryName, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterProducts,
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          if (_filteredProducts.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "Produk Tidak Ada",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
            )
          else
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.60,
                ),
                itemCount: _filteredProducts.length,
                // itemBuilder: (context, index) {
                //   final product = filteredProducts[index];

                //   return GestureDetector(
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) =>
                //               ProductDetailScreen(product: product),
                //         ),
                //       );
                //     },
                //     child: Card(
                //       elevation: 4,
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10)),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           ClipRRect(
                //             borderRadius:
                //                 BorderRadius.vertical(top: Radius.circular(10)),
                //             child: Image.network(
                //               "${responseUrl}/storage/${product.imageUrl}",
                //               height: 120,
                //               width: double.infinity,
                //               fit: BoxFit.cover,
                //               errorBuilder: (context, error, stackTrace) =>
                //                   Image.asset(
                //                 'assets/images/product.png',
                //                 height: 120,
                //                 width: double.infinity,
                //                 fit: BoxFit.cover,
                //               ),
                //             ),
                //           ),
                //           Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text(
                //                   product.name,
                //                   style: TextStyle(
                //                       fontSize: 16,
                //                       fontWeight: FontWeight.bold),
                //                   overflow: TextOverflow.ellipsis,
                //                 ),
                //                 SizedBox(height: 5),
                //                 Text(
                //                   product.description,
                //                   style: TextStyle(
                //                       fontSize: 12, color: Colors.grey),
                //                   maxLines: 2,
                //                   overflow: TextOverflow.ellipsis,
                //                 ),
                //                 SizedBox(height: 5),
                //                 Text(
                //                   "Total Stock: ${product.totalStock}",
                //                   style: TextStyle(
                //                       fontSize: 14, color: Colors.grey[600]),
                //                 ),
                //                 SizedBox(height: 5),
                //                 Text(
                //                   "Rp ${product.price.toStringAsFixed(2)}",
                //                   style: TextStyle(
                //                       fontSize: 14,
                //                       fontWeight: FontWeight.bold,
                //                       color: Colors.blue),
                //                 ),
                //                 SizedBox(height: 5),
                //                 Text(
                //                   "Nearest Exp: ${product.nearestExpDate}",
                //                   style: TextStyle(
                //                     fontSize: 14,
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.red,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   );
                // },

                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];

                  // Mengonversi nearestExpDate ke DateTime
                  DateTime? expDate;
                  try {
                    expDate = DateFormat("yyyy-MM-dd").parse(product.fifoExp);
                  } catch (e) {
                    expDate = null;
                  }

                  // Hitung selisih hari dari tanggal sekarang
                  bool isExpiringSoon = expDate != null &&
                      expDate.difference(DateTime.now()).inDays <= 90 &&
                      expDate.difference(DateTime.now()).inDays >= 0;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: isExpiringSoon
                          ? Colors.orange[100]
                          : Colors.white, // Ubah warna background
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10)),
                            child: Image.network(
                              "$responseUrl/storage/${product.imageUrl}",
                              height: 110,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/product.png',
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  product.description,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Total Stock: ${product.totalStock}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${formatCurrency.format(product.price)}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                                const SizedBox(height: 5),
                                Row(children: [
                                  Text(
                                    "Exp: ${product.fifoExp}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isExpiringSoon
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
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
                                ])
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
