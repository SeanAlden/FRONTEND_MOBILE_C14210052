import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/views/pages/app/all_categories_screen.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:ta_c14210052/models/category.dart';
import 'package:ta_c14210052/models/product.dart';
import 'package:ta_c14210052/views/pages/app/cart_page.dart';
import 'package:ta_c14210052/views/pages/app/product_detail_screen.dart';
import 'package:ta_c14210052/views/pages/app/product_screen.dart';
import 'package:ta_c14210052/views/pages/app/product_search_page.dart';
import 'package:ta_c14210052/widgets/category_card.dart';
import 'package:ta_c14210052/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<Product> products = [];
  List<Category> categories = [];
  Product? productexp;
  String _namaUser = 'Guest';
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchCategories();
    loadNamaUser();
    _loadUserData();
  }

  Future<void> loadNamaUser() async {
    final prefs = await SharedPreferences.getInstance();
    final nama = prefs.getString('namaUser') ?? 'Guest';
    if (mounted) {
      setState(() {
        _namaUser = nama;
      });
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaUser = prefs.getString('namaUser') ?? 'Guest';
      _profileImage = prefs.getString('profileImage');
    });
    final token = prefs.getString('token');
    final uri = Uri.parse('$responseUrl/api/auth/user/profile-image');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (!mounted) return;
      setState(() {
        _profileImage = data['profile_image'];
      });

      // await prefs.setString('profileImage', data['profile_image']);
      await prefs.setString('profileImage', data['profile_image'] ?? '');
      await prefs.reload();
    } else {
      if (!mounted) return;
      setState(() {
        _profileImage = null;
      });
    }
  }

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse('$responseUrl/api/products/active'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];
      if (mounted) {
        setState(() {
          products =
              jsonResponse.map((product) => Product.fromJson(product)).toList();
        });
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> fetchCategories() async {
    final response = await http.get(
      Uri.parse('$responseUrl/api/categories'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      if (mounted) {
        setState(() {
          categories = jsonResponse
              .map((category) => Category.fromJson(category))
              .toList();
          isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> _refreshData() async {
    await fetchProducts();
    await fetchCategories();
    await loadNamaUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
        ),
        body: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section: Welcome & Icons
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         // const CircleAvatar(
                      //         //   radius: 25,
                      //         //   backgroundImage:
                      //         //       AssetImage('assets/images/profile.png'),
                      //         // ),

                      //         // CircleAvatar(
                      //         //   radius: 25,
                      //         //   backgroundColor: Colors.grey[300],
                      //         //   backgroundImage: _profileImage != null
                      //         //       ? NetworkImage(
                      //         //           '$responseUrl/storage/profile_images/$_profileImage')
                      //         //       : const AssetImage('assets/images/profile.png')
                      //         //           as ImageProvider,
                      //         // ),

                      //         ClipOval(
                      //           child: (_profileImage != null &&
                      //                   _profileImage!.isNotEmpty)
                      //               ? Image.network(
                      //                   '$responseUrl/public/storage/profile_images/$_profileImage',
                      //                   width: 50,
                      //                   height: 50,
                      //                   fit: BoxFit.cover,
                      //                   errorBuilder: (context, error, stackTrace) {
                      //                     return Image.asset(
                      //                       'assets/images/profile.png',
                      //                       width: 50,
                      //                       height: 50,
                      //                       fit: BoxFit.cover,
                      //                     );
                      //                   },
                      //                 )
                      //               : Image.asset(
                      //                   'assets/images/profile.png',
                      //                   width: 50,
                      //                   height: 50,
                      //                   fit: BoxFit.cover,
                      //                 ),
                      //         ),

                      //         const SizedBox(width: 10),

                      //         Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             const Text("Welcome,",
                      //                 style: TextStyle(
                      //                     fontSize: 14, color: Colors.grey)),
                      //             Text(_namaUser,
                      //                 style: const TextStyle(
                      //                     fontSize: 18, fontWeight: FontWeight.bold)),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //     Row(
                      //       children: [
                      //         IconButton(
                      //           icon: const Icon(Icons.shopping_cart, size: 28),
                      //           onPressed: () {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => const CartPage()),
                      //             );
                      //           },
                      //         ),
                      //         IconButton(
                      //           icon: const Icon(Icons.search, size: 28),
                      //           onPressed: () {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => ProductSearchPage(
                      //                         products: products,
                      //                         // filteredProducts: productexp,
                      //                       )),
                      //             );
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                ClipOval(
                                  child: (_profileImage != null &&
                                          _profileImage!.isNotEmpty)
                                      ? Image.network(
                                          '$responseUrl/public/storage/profile_images/$_profileImage',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/profile.png',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          'assets/images/profile.png',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                const SizedBox(width: 10),
                                // Expanded digunakan untuk memastikan teks tidak overflow
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Welcome,",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        _namaUser,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.shopping_cart, size: 28),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const CartPage()),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.search, size: 28),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductSearchPage(products: products),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(),

                      // Section: Categories
                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       const Text("Product Categories",
                      //           style: TextStyle(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.bold,
                      //             overflow: TextOverflow.ellipsis,
                      //           )),
                      //       ElevatedButton(
                      //         onPressed: () {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     const AllCategoriesScreen()),
                      //           );
                      //         },
                      //         style: ElevatedButton.styleFrom(
                      //           backgroundColor: Colors.blue,
                      //           padding: const EdgeInsets.symmetric(
                      //               horizontal: 12, vertical: 6),
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(16),
                      //           ),
                      //           elevation: 2,
                      //           minimumSize: const Size(80, 32),
                      //         ),
                      //         child: const Text(
                      //           "See All",
                      //           style: TextStyle(
                      //               fontSize: 14,
                      //               fontWeight: FontWeight.w500,
                      //               color: Colors.white),
                      //           overflow: TextOverflow.ellipsis,
                      //           maxLines: 2,
                      //         ),
                      //       ),
                      //     ]),
                      // ]),

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      //   child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "Product Categories",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            const SizedBox(
                                width: 8), // jarak antara teks dan tombol
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AllCategoriesScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                                minimumSize: const Size(80, 32),
                              ),
                              child: const Text(
                                "See All",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      // ),

                      const SizedBox(height: 10),
                      // SizedBox(
                      //   height: 100,
                      //   child
                      SizedBox(
                        height: 120,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductScreen(
                                            categoryId: categories[index].id,
                                            products: products,
                                            // product: productexp,
                                          ),
                                        ),
                                      );
                                    },
                                    child: CategoryCard(
                                      title: categories[index].name,
                                      products: products,
                                    ),
                                  );
                                },
                              ),
                      ),

                      const SizedBox(height: 16),

                      // Section: Products
                      const Text("Products",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),

                      const SizedBox(height: 10),
                      SizedBox(
                        height: 390,
                        child: products.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailScreen(
                                            product: products[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child:
                                        ProductCard(product: products[index]),
                                  );
                                },
                              ),
                      ),

                      const SizedBox(height: 16),

                      // Section: News
                      // const Text("News",
                      //     style: TextStyle(
                      //         fontSize: 18, fontWeight: FontWeight.bold)),
                      // const SizedBox(height: 2),
                      // const NewsWidget(),
                    ]),
              ),
            )));
  }
}
