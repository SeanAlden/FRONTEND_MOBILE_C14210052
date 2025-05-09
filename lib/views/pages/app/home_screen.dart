// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:ta_c14210052/all_categories_screen.dart';
// import 'package:ta_c14210052/category.dart';
// import 'package:ta_c14210052/category_card.dart';
// import 'package:ta_c14210052/product_card.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List products = [];
//   List<Category> categories = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//     fetchCategories();
//   }

//   Future<void> fetchProducts() async {
//     final response = await http.get(
//         Uri.parse('https://2381-139-195-159-95.ngrok-free.app/api/products'));

//     if (response.statusCode == 200) {
//       setState(() {
//         products = json.decode(response.body)['data'];
//       });
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }

//   Future<void> fetchCategories() async {
//     final response = await http.get(
//         Uri.parse('https://2381-139-195-159-95.ngrok-free.app/api/categories'));

//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       setState(() {
//         categories = jsonResponse
//             .map((category) => Category.fromJson(category))
//             .toList();
//       });
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home',
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Welcome & Search
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 25,
//                         backgroundImage:
//                             AssetImage('assets/images/profile.png'),
//                       ),
//                       SizedBox(width: 10),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Welcome,",
//                               style:
//                                   TextStyle(fontSize: 14, color: Colors.grey)),
//                           Text("User1",
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Icon(Icons.search, size: 28),
//                 ],
//               ),

//               SizedBox(height: 16),
//               Divider(),

//               // Product Categories
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Product Categories",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   // Text(
//                   //   "See All",
//                   //   style: TextStyle(fontSize: 14, color: Colors.blue),
//                   // ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => AllCategoriesScreen()),
//                       );
//                     },
//                     child: Text("See All"),
//                   ),
//                 ],
//               ),

//               SizedBox(height: 10),
//               Container(
//                 height: 100,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: categories.length,
//                   itemBuilder: (context, index) {
//                     return CategoryCard(title: categories[index].name);
//                   },
//                 ),
//               ),

//               SizedBox(height: 16),

//               // Products
//               Text(
//                 "Products",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),

//               SizedBox(height: 10),
//               Container(
//                 height: 220,
//                 child: products.isEmpty
//                     ? Center(child: CircularProgressIndicator())
//                     : ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: products.length,
//                         itemBuilder: (context, index) {
//                           final product = products[index];
//                           return ProductCard(product: product);
//                         },
//                       ),
//               ),

//               SizedBox(height: 16),

//               // News Section Placeholder
//               Text(
//                 "News",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),

//               Container(
//                 height: 100,
//                 color: Colors.grey[300],
//                 margin: EdgeInsets.only(top: 10),
//                 alignment: Alignment.center,
//                 child: Text("News Content Here"),
//               ),
//             ],
//           ),
//         ),
//       ),

//       // Bottom Navigation Bar
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: ""),
//           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:ta_c14210052/pages/all_categories_screen.dart';
// import 'package:ta_c14210052/constant/api_url.dart';
// import 'package:ta_c14210052/models/category.dart';
// import 'package:ta_c14210052/pages/product_screen.dart';
// import 'package:ta_c14210052/widgets/category_card.dart';
// import 'package:ta_c14210052/widgets/product_card.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List products = [];
//   List<Category> categories = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//     fetchCategories();
//   }

//   Future<void> fetchProducts() async {
//     final response = await http.get(Uri.parse('${url}/api/products'));

//     if (response.statusCode == 200) {
//       setState(() {
//         products = json.decode(response.body)['data'];
//       });
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }

//   Future<void> fetchCategories() async {
//     final response = await http.get(Uri.parse('${url}/api/categories'));

//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       setState(() {
//         categories = jsonResponse
//             .map((category) => Category.fromJson(category))
//             .toList();
//       });
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   }

//   // Fungsi untuk refresh halaman
//   Future<void> _refreshData() async {
//     await fetchProducts();
//     await fetchCategories();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home',
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshData, // Tambahkan RefreshIndicator
//         child: SingleChildScrollView(
//           physics:
//               AlwaysScrollableScrollPhysics(), // Agar bisa di-scroll meskipun kontennya sedikit
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Welcome & Search
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 25,
//                           backgroundImage:
//                               AssetImage('assets/images/profile.png'),
//                         ),
//                         SizedBox(width: 10),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Welcome,",
//                                 style: TextStyle(
//                                     fontSize: 14, color: Colors.grey)),
//                             Text("User1",
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Icon(Icons.search, size: 28),
//                   ],
//                 ),

//                 SizedBox(height: 16),
//                 Divider(),

//                 // Product Categories
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Product Categories",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => AllCategoriesScreen()),
//                         );
//                       },
//                       child: Text("See All"),
//                     ),
//                   ],
//                 ),

//                 SizedBox(height: 10),
//                 // Container(
//                 //   height: 100,
//                 //   child: ListView.builder(
//                 //     scrollDirection: Axis.horizontal,
//                 //     itemCount: categories.length,
//                 //     itemBuilder: (context, index) {
//                 //       return CategoryCard(title: categories[index].name);
//                 //     },
//                 //   ),
//                 // ),

//                 Container(
//                   height: 100,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: categories.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ProductScreen(
//                                   categoryId: categories[index].id),
//                             ),
//                           );
//                         },
//                         child: CategoryCard(title: categories[index].name),
//                       );
//                     },
//                   ),
//                 ),

//                 SizedBox(height: 16),

//                 // Products
//                 Text(
//                   "Products",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),

//                 SizedBox(height: 10),
//                 Container(
//                   height: 220,
//                   child: products.isEmpty
//                       ? Center(child: CircularProgressIndicator())
//                       : ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: products.length,
//                           itemBuilder: (context, index) {
//                             final product = products[index];
//                             return ProductCard(product: product);
//                           },
//                         ),
//                 ),

//                 SizedBox(height: 16),

//                 // News Section Placeholder
//                 Text(
//                   "News",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),

//                 Container(
//                   height: 100,
//                   color: Colors.grey[300],
//                   margin: EdgeInsets.only(top: 10),
//                   alignment: Alignment.center,
//                   child: Text("News Content Here"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),

//       // // Bottom Navigation Bar
//       // bottomNavigationBar: BottomNavigationBar(
//       //   type: BottomNavigationBarType.fixed,
//       //   selectedItemColor: Colors.blue,
//       //   unselectedItemColor: Colors.grey,
//       //   items: [
//       //     BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
//       //     BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ""),
//       //     BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
//       //     BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
//       //   ],
//       // ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_c14210052/views/pages/app/all_categories_screen.dart';
// import 'package:ta_c14210052/constant/api_url.dart';
// import 'package:ta_c14210052/models/category.dart';
// import 'package:ta_c14210052/models/product.dart';
// import 'package:ta_c14210052/views/pages/app/cart_page.dart';
// import 'package:ta_c14210052/views/pages/app/product_detail_screen.dart';
// import 'package:ta_c14210052/views/pages/app/product_screen.dart';
// import 'package:ta_c14210052/views/pages/app/product_search_page.dart';
// import 'package:ta_c14210052/widgets/category_card.dart';
// import 'package:ta_c14210052/widgets/news_card.dart';
// import 'package:ta_c14210052/widgets/product_card.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String _namaUser = '';
//   List<Product> products = [];
//   List<Category> categories = [];

//   @override
//   void initState() {
//     _loadNamaUser();
//     super.initState();
//     fetchProducts();
//     fetchCategories();
//   }

//   Future<void> _loadNamaUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       // _namaUser = prefs.getString('name') ?? 'Guest';
//       _namaUser = prefs.getString('namaUser') ?? 'Guest';
//     });
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Text(
//   //     _namaUser,
//   //     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//   //   );
//   // }

//   Future<void> fetchProducts() async {
//     final response =
//         await http.get(Uri.parse('$responseUrl/api/active/products'));

//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body)['data'];
//       if (mounted) {
//         setState(() {
//           products =
//               jsonResponse.map((product) => Product.fromJson(product)).toList();
//         });
//       }
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }

//   // Future<void> fetchCategories() async {
//   //   final response = await http.get(Uri.parse('${responseUrl}/api/categories'));

//   //   if (response.statusCode == 200) {
//   //     List jsonResponse = json.decode(response.body);
//   //     setState(() {
//   //       categories = jsonResponse
//   //           .map((category) => Category.fromJson(category))
//   //           .toList();
//   //     });
//   //   } else {
//   //     throw Exception('Failed to load categories');
//   //   }
//   // }

//   Future<void> fetchCategories() async {
//     final response = await http.get(Uri.parse('$responseUrl/api/categories'));

//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       if (mounted) {
//         setState(() {
//           categories = jsonResponse
//               .map((category) => Category.fromJson(category))
//               .toList();
//         });
//       }
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   }

//   Future<void> _refreshData() async {
//     await fetchProducts();
//     await fetchCategories();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home',
//             style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshData,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Welcome & Search
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   children: [
//                 //     Row(
//                 //       children: [
//                 //         CircleAvatar(
//                 //           radius: 25,
//                 //           backgroundImage:
//                 //               AssetImage('assets/images/profile.png'),
//                 //         ),
//                 //         SizedBox(width: 10),
//                 //         Column(
//                 //           crossAxisAlignment: CrossAxisAlignment.start,
//                 //           children: [
//                 //             Text("Welcome,",
//                 //                 style: TextStyle(
//                 //                     fontSize: 14, color: Colors.grey)),
//                 //             Text("User1",
//                 //                 style: TextStyle(
//                 //                     fontSize: 18, fontWeight: FontWeight.bold)),
//                 //           ],
//                 //         ),
//                 //       ],
//                 //     ),
//                 //     // Icon(Icons.search, size: 28),
//                 //     IconButton(
//                 //       icon: Icon(Icons.search, size: 28),
//                 //       onPressed: () {
//                 //         Navigator.push(
//                 //           context,
//                 //           MaterialPageRoute(
//                 //               builder: (context) =>
//                 //                   ProductSearchPage(products: products)),
//                 //         );
//                 //       },
//                 //     ),
//                 //   ],
//                 // ),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 25,
//                           backgroundImage:
//                               AssetImage('assets/images/profile.png'),
//                         ),
//                         SizedBox(width: 10),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Welcome,",
//                                 style: TextStyle(
//                                     fontSize: 14, color: Colors.grey)),
//                             Text(_namaUser,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         // Tambahan IconButton untuk Shopping Cart
//                         IconButton(
//                           icon: const Icon(Icons.shopping_cart, size: 28),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => CartPage()),
//                             );
//                           },
//                         ),
//                         // IconButton untuk Search
//                         IconButton(
//                           icon: const Icon(Icons.search, size: 28),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       ProductSearchPage(products: products)),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 16),
//                 const Divider(),

//                 // Product Categories
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text("Product Categories",
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                     // ElevatedButton(
//                     //   onPressed: () {
//                     //     Navigator.push(
//                     //       context,
//                     //       MaterialPageRoute(
//                     //           builder: (context) => AllCategoriesScreen()),
//                     //     );
//                     //   },
//                     //   child: Text("See All"),
//                     // ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => AllCategoriesScreen(),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             Colors.blue, // Warna latar belakang biru
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6), // Padding lebih kecil
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(
//                               16), // Sudut sedikit membulat
//                         ),
//                         elevation: 2, // Efek bayangan lebih ringan
//                         minimumSize: const Size(
//                             80, 32), // Ukuran minimum tombol lebih kecil
//                       ),
//                       child: const Text(
//                         "See All",
//                         style: TextStyle(
//                           fontSize: 14, // Ukuran teks lebih kecil
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white, // Warna teks putih agar kontras
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 10),

//                 SizedBox(
//                   height: 100,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: categories.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ProductScreen(
//                                   categoryId: categories[index].id,
//                                   products: products),
//                             ),
//                           );
//                         },
//                         child: CategoryCard(
//                             title: categories[index].name, products: products),
//                       );
//                     },
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 // Products
//                 const Text("Products",
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

//                 const SizedBox(height: 10),
//                 SizedBox(
//                   height: 270,
//                   child: products.isEmpty
//                       ? const Center(child: CircularProgressIndicator())
//                       : ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: products.length,
//                           itemBuilder: (context, index) {
//                             // return ProductCard(product: products[index]);
//                             return GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ProductDetailScreen(
//                                         product: products[index]),
//                                   ),
//                                 );
//                               },
//                               child: ProductCard(product: products[index]),
//                             );
//                           },
//                         ),
//                 ),

//                 const SizedBox(height: 16),

//                 // News Section Placeholder
//                 const Text("News",
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

//                 // Container(
//                 //   height: 100,
//                 //   color: Colors.grey[300],
//                 //   margin: EdgeInsets.only(top: 10),
//                 //   alignment: Alignment.center,
//                 //   child: Text("News Content Here"),
//                 // ),

//                 const SizedBox(
//                   height: 2,
//                 ),

//                 NewsWidget()
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_c14210052/views/pages/app/all_categories_screen.dart';
// import 'package:ta_c14210052/constant/api_url.dart';
// import 'package:ta_c14210052/models/category.dart';
// import 'package:ta_c14210052/models/product.dart';
// import 'package:ta_c14210052/views/pages/app/cart_page.dart';
// import 'package:ta_c14210052/views/pages/app/product_detail_screen.dart';
// import 'package:ta_c14210052/views/pages/app/product_screen.dart';
// import 'package:ta_c14210052/views/pages/app/product_search_page.dart';
// import 'package:ta_c14210052/widgets/category_card.dart';
// import 'package:ta_c14210052/widgets/news_card.dart';
// import 'package:ta_c14210052/widgets/product_card.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<Product> products = [];
//   List<Category> categories = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//     fetchCategories();
//   }

//   Future<String> getNamaUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('namaUser') ?? 'Guest';
//   }

//   Future<void> fetchProducts() async {
//     final response =
//         await http.get(Uri.parse('$responseUrl/api/active/products'));

//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body)['data'];
//       if (mounted) {
//         setState(() {
//           products =
//               jsonResponse.map((product) => Product.fromJson(product)).toList();
//         });
//       }
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }

//   Future<void> fetchCategories() async {
//     final response = await http.get(Uri.parse('$responseUrl/api/categories'));

//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       if (mounted) {
//         setState(() {
//           categories = jsonResponse
//               .map((category) => Category.fromJson(category))
//               .toList();
//         });
//       }
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   }

//   Future<void> _refreshData() async {
//     await fetchProducts();
//     await fetchCategories();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home',
//             style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshData,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Section: Welcome & Icons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         const CircleAvatar(
//                           radius: 25,
//                           backgroundImage:
//                               AssetImage('assets/images/profile.png'),
//                         ),
//                         const SizedBox(width: 10),
//                         FutureBuilder<String>(
//                           future: getNamaUser(),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const CircularProgressIndicator();
//                             }
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text("Welcome,",
//                                     style: TextStyle(
//                                         fontSize: 14, color: Colors.grey)),
//                                 Text(snapshot.data ?? "Guest",
//                                     style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold)),
//                               ],
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.shopping_cart, size: 28),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => CartPage()),
//                             );
//                           },
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.search, size: 28),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       ProductSearchPage(products: products)),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 16),
//                 const Divider(),

//                 // Section: Categories
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text("Product Categories",
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => AllCategoriesScreen()),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         elevation: 2,
//                         minimumSize: const Size(80, 32),
//                       ),
//                       child: const Text(
//                         "See All",
//                         style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 10),
//                 SizedBox(
//                   height: 100,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: categories.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ProductScreen(
//                                 categoryId: categories[index].id,
//                                 products: products,
//                               ),
//                             ),
//                           );
//                         },
//                         child: CategoryCard(
//                           title: categories[index].name,
//                           products: products,
//                         ),
//                       );
//                     },
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 // Section: Products
//                 const Text("Products",
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

//                 const SizedBox(height: 10),
//                 SizedBox(
//                   height: 270,
//                   child: products.isEmpty
//                       ? const Center(child: CircularProgressIndicator())
//                       : ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: products.length,
//                           itemBuilder: (context, index) {
//                             return GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ProductDetailScreen(
//                                       product: products[index],
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: ProductCard(product: products[index]),
//                             );
//                           },
//                         ),
//                 ),

//                 const SizedBox(height: 16),

//                 // Section: News
//                 const Text("News",
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 2),
//                 const NewsWidget()
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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
import 'package:ta_c14210052/widgets/news_card.dart';
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
        await http.get(Uri.parse('$responseUrl/api/active/products'));

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
    final response = await http.get(Uri.parse('$responseUrl/api/categories'));

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // const CircleAvatar(
                        //   radius: 25,
                        //   backgroundImage:
                        //       AssetImage('assets/images/profile.png'),
                        // ),

                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _profileImage != null
                              ? NetworkImage(
                                  '$responseUrl/storage/profile_images/$_profileImage')
                              : const AssetImage('assets/images/profile.png')
                                  as ImageProvider,
                        ),

                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Welcome,",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            Text(_namaUser,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    Row(
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
                                  builder: (context) => ProductSearchPage(
                                        products: products,
                                        // filteredProducts: productexp,
                                      )),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Product Categories",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AllCategoriesScreen()),
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
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                // SizedBox(
                //   height: 100,
                //   child
                SizedBox(
                  height: 100,
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
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                const SizedBox(height: 10),
                SizedBox(
                  height: 290,
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
                                    builder: (context) => ProductDetailScreen(
                                      product: products[index],
                                    ),
                                  ),
                                );
                              },
                              child: ProductCard(product: products[index]),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 16),

                // Section: News
                const Text("News",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                const NewsWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
