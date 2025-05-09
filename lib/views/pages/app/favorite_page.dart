// import 'package:flutter/material.dart';

// class FavoritePage extends StatefulWidget {
//   const FavoritePage({super.key});

//   @override
//   State<FavoritePage> createState() => _FavoritePageState();
// }

// class _FavoritePageState extends State<FavoritePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Favorite',
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_c14210052/constant/api_url.dart';

// class FavoritePage extends StatefulWidget {
//   const FavoritePage({Key? key}) : super(key: key);

//   @override
//   State<FavoritePage> createState() => _FavoritePageState();
// }

// class _FavoritePageState extends State<FavoritePage> {
//   List<dynamic> favoriteProducts = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchFavorites();
//   }

//   Future<void> fetchFavorites() async {
//     final token = await getToken(); // Ganti dengan metode ambil token
//     final response = await http.get(
//       Uri.parse('${responseUrl}/api/favorites'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (mounted) {
//         setState(() {
//           favoriteProducts = data['favorites'];
//         });
//       }
//     }
//   }

//   // Future<String?> getToken() async {
//   //   // Ganti ini dengan metode ambil token yang sesuai, contoh dari SharedPreferences
//   //   return 'your_jwt_token';
//   // }

//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token'); // Retrieve token from SharedPreferences
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: const Text('Favorites', style: TextStyle(color: Colors.white)),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: "Search products...",
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.grey.shade200,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: GridView.builder(
//               padding: const EdgeInsets.all(12),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 12,
//                 crossAxisSpacing: 12,
//                 childAspectRatio: 0.7,
//               ),
//               itemCount: favoriteProducts.length,
//               itemBuilder: (context, index) {
//                 final product = favoriteProducts[index];
//                 return Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 8),
//                       const Icon(Icons.image, size: 70, color: Colors.grey),
//                       Padding(
//                         padding: const EdgeInsets.all(8),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(product['name'],
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold)),
//                             Text(
//                               product['description'] ?? '',
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 8),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text('Stock : ${product['stock']}',
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold)),
//                                 Text('Rp ${product['price']}',
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold)),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Spacer(),
//                       const Padding(
//                         padding: EdgeInsets.only(bottom: 8),
//                         child: Icon(Icons.favorite, color: Colors.red),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_c14210052/constant/api_url.dart';
// import 'package:ta_c14210052/models/product.dart';
// // import 'product.dart'; // import model produk

// class FavoritePage extends StatefulWidget {
//   const FavoritePage({Key? key})
//       : super(
//           key: key,
//         );

//   @override
//   State<FavoritePage> createState() => _FavoritePageState();
// }

// class _FavoritePageState extends State<FavoritePage> {
//   List<Product> favoriteProducts = [];
//   final String apiUrl = '${responseUrl}/api/favorites';

//   @override
//   void initState() {
//     super.initState();
//     fetchFavorites();
//   }

//   Future<void> fetchFavorites() async {
//     final token = await getToken(); // ambil token dari shared pref / auth
//     final response = await http.get(
//       Uri.parse(apiUrl),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (mounted) {
//         setState(() {
//           favoriteProducts = (data['favorites'] as List)
//               .map((item) => Product.fromJson(item))
//               .toList();
//         });
//       }
//     }
//   }

//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token'); // Retrieve token from SharedPreferences
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('Favorite Products'),
//       //   leading: IconButton(
//       //     icon: const Icon(Icons.arrow_back),
//       //     onPressed: () => Navigator.pop(context),
//       //   ),
//       // ),

//       appBar: AppBar(
//         title: const Text(
//           'Favorites',
//           style: TextStyle(
//               fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: favoriteProducts.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : GridView.builder(
//               padding: const EdgeInsets.all(12),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.55,
//                 mainAxisSpacing: 12,
//                 crossAxisSpacing: 12,
//               ),
//               itemCount: favoriteProducts.length,
//               itemBuilder: (context, index) {
//                 final product = favoriteProducts[index];
//                 return Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   child:
//                       // Column(
//                       //   crossAxisAlignment: CrossAxisAlignment.start,
//                       //   children: [
//                       //     const SizedBox(height: 8),
//                       //     product.imageUrl.isNotEmpty
//                       //         ? Image.network(
//                       //             product.imageUrl,
//                       //             height: 80,
//                       //             width: double.infinity,
//                       //             fit: BoxFit.cover,
//                       //           )
//                       //         : const Icon(Icons.image, size: 80),
//                       //     Padding(
//                       //       padding: const EdgeInsets.all(8.0),
//                       //       child: Column(
//                       //         crossAxisAlignment: CrossAxisAlignment.start,
//                       //         children: [
//                       //           Text(product.name,
//                       //               style: const TextStyle(
//                       //                   fontWeight: FontWeight.bold)),
//                       //           const SizedBox(height: 4),
//                       //           Text(
//                       //             product.description,
//                       //             maxLines: 2,
//                       //             overflow: TextOverflow.ellipsis,
//                       //           ),
//                       //           const SizedBox(height: 4),
//                       //           Text('Kategori: ${product.category ?? "-"}'),
//                       //           Text('Exp: ${product.nearestExpDate}'),
//                       //           Text('Stok: ${product.totalStock}'),
//                       //           const SizedBox(height: 4),
//                       //           Text(
//                       //             'Rp ${product.price.toStringAsFixed(0)}',
//                       //             style: const TextStyle(
//                       //                 fontWeight: FontWeight.bold,
//                       //                 color: Colors.green),
//                       //           ),
//                       //         ],
//                       //       ),
//                       //     ),
//                       //   ],
//                       // ),

//                       Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       product.imageUrl.isNotEmpty
//                           ? Container(
//                               height: 100,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: NetworkImage(
//                                       "$responseUrl/storage/${product.imageUrl}"),
//                                   fit: BoxFit.cover,
//                                 ),
//                                 borderRadius: const BorderRadius.only(
//                                   topLeft: Radius.circular(10),
//                                   topRight: Radius.circular(10),
//                                 ),
//                               ),
//                             )
//                           : const Icon(Icons.image, size: 80),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(product.name,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold)),
//                             const SizedBox(height: 4),
//                             Text(product.description,
//                                 maxLines: 2, overflow: TextOverflow.ellipsis),
//                             const SizedBox(height: 4),
//                             Text('Kategori: ${product.category ?? "-"}'),
//                             Text('Exp: ${product.nearestExpDate}'),
//                             Text('Stok: ${product.totalStock}'),
//                             const SizedBox(height: 4),
//                             Text(
//                               'Rp ${product.price.toStringAsFixed(0)}',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.green,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:ta_c14210052/models/product.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

// class _FavoritePageState extends State<FavoritePage> {
//   List<Product> favoriteProducts = [];
//   final String apiUrl = '$responseUrl/api/favorites';

//   @override
//   void initState() {
//     super.initState();
//     fetchFavorites();
//   }

//   Future<void> fetchFavorites() async {
//     final token = await getToken();
//     final response = await http.get(
//       Uri.parse(apiUrl),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (mounted) {
//         setState(() {
//           favoriteProducts = (data['favorites'] as List)
//               .map((item) => Product.fromJson(item))
//               .toList();
//         });
//       }
//     }
//   }

class _FavoritePageState extends State<FavoritePage> {
  List<Product> favoriteProducts = [];
  final String apiUrl = '$responseUrl/api/favorites';
  bool isLoading = true; // <-- ini ditambahkan

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (mounted) {
        setState(() {
          favoriteProducts = (data['favorites'] as List)
              .map((item) => Product.fromJson(item))
              .toList();
          isLoading = false; // <-- loading selesai
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false; // <-- bahkan jika gagal, matikan loading
        });
      }
    }
  }

  Future<void> toggleFavorite(int productId) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$responseUrl/api/toggle-favorite/$productId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        favoriteProducts.removeWhere((product) => product.id == productId);
      });

      // Tampilkan SnackBar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil dihapus dari favorit'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // Tampilkan SnackBar error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengubah status favorit'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Favorites',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        // body: favoriteProducts.isEmpty
        //     ? const Center(
        //         child: Text("Anda tidak memiliki produk favorit"),
        //       )

        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : favoriteProducts.isEmpty
                ? const Center(
                    child: Text("Anda tidak memiliki produk favorit"),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.70,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: favoriteProducts.length,
                    itemBuilder: (context, index) {
                      final product = favoriteProducts[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            product.imageUrl.isNotEmpty
                                ? Container(
                                    height: 100,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "$responseUrl/storage/${product.imageUrl}"),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                  )
                                : const Placeholder(fallbackHeight: 100),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Row untuk nama dan icon hati
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      // IconButton(
                                      //   icon: const Icon(Icons.favorite,
                                      //       color: Colors.red),
                                      //   onPressed: () {
                                      //     // Handle favorite action
                                      //   },
                                      //   padding: EdgeInsets.zero,
                                      //   constraints: const BoxConstraints(),
                                      // ),

                                      IconButton(
                                        icon: const Icon(Icons.favorite,
                                            color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Hapus dari Favorit?'),
                                              content: const Text(
                                                  'Apakah kamu yakin ingin menghapus produk ini dari daftar favorit?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    toggleFavorite(product.id);
                                                  },
                                                  child:
                                                      const Text('Ya, Hapus'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  const SizedBox(height: 4),
                                  // Row untuk stok dan harga
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Stock: ${product.totalStock}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Rp ${product.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )

        // GridView.builder(
        //     padding: const EdgeInsets.all(12),
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 2,
        //       childAspectRatio: 0.6,
        //       mainAxisSpacing: 12,
        //       crossAxisSpacing: 12,
        //     ),
        //     itemCount: favoriteProducts.length,
        //     itemBuilder: (context, index) {
        //       final product = favoriteProducts[index];
        //       return Card(
        //         elevation: 3,
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(10)),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             product.imageUrl.isNotEmpty
        //                 ? Container(
        //                     height: 100,
        //                     width: double.infinity,
        //                     decoration: BoxDecoration(
        //                       image: DecorationImage(
        //                         image: NetworkImage(
        //                             "$responseUrl/storage/${product.imageUrl}"),
        //                         fit: BoxFit.cover,
        //                       ),
        //                       borderRadius: const BorderRadius.only(
        //                         topLeft: Radius.circular(10),
        //                         topRight: Radius.circular(10),
        //                       ),
        //                     ),
        //                   )
        //                 : const Placeholder(fallbackHeight: 100),
        //             Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text(
        //                     product.name,
        //                     style: const TextStyle(
        //                         fontWeight: FontWeight.bold,
        //                         fontSize: 16),
        //                   ),
        //                   const SizedBox(height: 4),
        //                   Text(
        //                     product.description,
        //                     maxLines: 2,
        //                     overflow: TextOverflow.ellipsis,
        //                     style: TextStyle(color: Colors.grey[700]),
        //                   ),
        //                   const SizedBox(height: 4),
        //                   Text(
        //                     'Stock: ${product.totalStock}',
        //                     style: const TextStyle(
        //                         fontWeight: FontWeight.bold),
        //                   ),
        //                   const SizedBox(height: 4),
        //                   Text(
        //                     'Rp ${product.price.toStringAsFixed(0)}',
        //                     style: const TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                       color: Colors.green,
        //                     ),
        //                   ),
        //                   const SizedBox(height: 4),
        //                 ],
        //               ),
        //             ),
        //             Align(
        //               alignment: Alignment.bottomRight,
        //               child: IconButton(
        //                 icon: const Icon(Icons.favorite, color: Colors.red),
        //                 onPressed: () {
        //                   // Handle favorite action
        //                 },
        //               ),
        //             ),
        //           ],
        //         ),
        //       );
        //     },
        //   ),
        );
  }
}
