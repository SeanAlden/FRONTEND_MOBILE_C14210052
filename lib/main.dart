// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:ta_c14210052/views/cart_page.dart';
// import 'package:ta_c14210052/views/pages/app/home_screen.dart';
// import 'package:ta_c14210052/views/pages/app/notification_screen.dart';
// import 'package:ta_c14210052/views/pages/app/profile_page.dart';
// import 'package:ta_c14210052/views/pages/auth/login_page.dart';
// // import 'pages/home_screen.dart';
// import 'views/pages/app/transaction_list_page.dart';
// // import 'pages/shopping_cart_page.dart';
// // import 'pages/profile_page.dart';

// void main() {
//   runApp(MyApp());
//   // runApp(
//   //   MultiProvider(
//   //     providers: [
//   //       ChangeNotifierProvider(create: (_) => CartProvider()),
//   //     ],
//   //     child: MyApp(),
//   //   ),
//   // );
// }

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized(); // Wajib jika pakai async di main
// //   SharedPreferences prefs = await SharedPreferences.getInstance();
// //   bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

// //   runApp(MyApp(isLoggedIn: isLoggedIn));
// // }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   // final bool isLoggedIn;
//   // const MyApp({super.key, required this.isLoggedIn});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MainScreen(),
//     );
//   }

//   // Widget build(BuildContext context) {
//   //   return MaterialApp(
//   //     debugShowCheckedModeBanner: false,
//   //     home: isLoggedIn
//   //         ? const MainScreen()
//   //         : const LoginPage(), // Cek login di sini
//   //   );
//   // }
// }

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     HomeScreen(),
//     TransactionListPage(),
//     NotificationScreen(),
//     ProfilePage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_bag), label: "Transactions"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.notifications), label: "Notification"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_c14210052/views/pages/app/home_screen.dart';
// import 'package:ta_c14210052/views/pages/app/notification_screen.dart';
// import 'package:ta_c14210052/views/pages/app/profile_page.dart';
// import 'package:ta_c14210052/views/pages/app/transaction_list_page.dart';
// import 'package:ta_c14210052/views/pages/auth/login_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   Widget _defaultPage = const Scaffold(body: Center(child: CircularProgressIndicator()));

//   @override
//   void initState() {
//     super.initState();
//     _checkAuth();
//   }

//   Future<void> _checkAuth() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');

//     setState(() {
//       _defaultPage = token != null ? const MainScreen() : const LoginPage();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: _defaultPage,
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     const HomeScreen(),
//     const TransactionListPage(),
//     const NotificationScreen(),
//     const ProfilePage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_bag), label: "Transactions"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.notifications), label: "Notification"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_c14210052/views/pages/app/home_screen.dart';
// import 'package:ta_c14210052/views/pages/app/notification_screen.dart';
// import 'package:ta_c14210052/views/pages/app/profile_page.dart';
// import 'package:ta_c14210052/views/pages/app/transaction_list_page.dart';
// import 'package:ta_c14210052/views/pages/auth/login_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // Fungsi untuk mengecek apakah token ada
//   Future<bool> _isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     return token != null && token.isNotEmpty;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: FutureBuilder<bool>(
//         future: _isLoggedIn(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           } else if (snapshot.hasData && snapshot.data == true) {
//             return const MainScreen();
//           } else {
//             return const LoginPage();
//           }
//         },
//       ),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     const HomeScreen(),
//     const TransactionListPage(),
//     const NotificationScreen(),
//     const ProfilePage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Transactions"),
//           BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notification"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_c14210052/constant/api_url.dart';
// import 'package:ta_c14210052/views/pages/app/home_screen.dart';
// import 'package:ta_c14210052/views/pages/app/notification_screen.dart';
// import 'package:ta_c14210052/views/pages/app/profile_page.dart';
// import 'package:ta_c14210052/views/pages/app/transaction_list_page.dart';
// import 'package:ta_c14210052/views/pages/auth/login_page.dart';
// // import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';

// void main() async {
//   await Hive.initFlutter();
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeDateFormatting('id_ID', null); // Inisialisasi lokal bahasa Indonesia
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   Future<bool> _isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     return token != null && token.isNotEmpty;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: FutureBuilder<bool>(
//         future: _isLoggedIn(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           } else if (snapshot.hasData && snapshot.data == true) {
//             return const MainScreen();
//           } else {
//             return const LoginPage();
//           }
//         },
//       ),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     const HomeScreen(),
//     const TransactionListPage(),
//     const NotificationScreen(),
//     const ProfilePage(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     fetchUserProfile(); // Ambil nama user saat MainScreen dimulai
//   }

//   Future<void> fetchUserProfile() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');

//     if (token == null) return;

//     try {
//       final response = await http.get(
//         Uri.parse(
//             '$responseUrl/api/user'), // Ganti dengan base URL backend kamu
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final name = data['name'];
//         final email = data['email'];
//         await prefs.setString('namaUser', name);
//         await prefs.setString('emailUser', email);
//       } else {
//         debugPrint("Gagal ambil user profile: ${response.body}");
//       }
//     } catch (e) {
//       debugPrint("Error ambil user profile: $e");
//     }
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_bag), label: "Transactions"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.notifications), label: "Notification"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_c14210052/constant/api_url.dart';
// import 'package:ta_c14210052/views/pages/app/home_screen.dart';
// import 'package:ta_c14210052/views/pages/app/notification_page.dart';
// import 'package:ta_c14210052/views/pages/app/profile_page.dart';
// import 'package:ta_c14210052/views/pages/app/transaction_list_page.dart';
// import 'package:ta_c14210052/views/pages/auth/login_page.dart';
// import 'package:intl/date_symbol_data_local.dart'; // untuk format tanggal indo

// final RouteObserver<ModalRoute<void>> routeObserver =
//     RouteObserver<ModalRoute<void>>();

// void main() async {
//   await Hive.initFlutter();
//   WidgetsFlutterBinding.ensureInitialized();
//   // supaya aplikasi hanya bisa pada orientasi portrait saja
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//   // untuk inisialisasi bahasa indonesia
//   await initializeDateFormatting(
//       'id_ID', null); 
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // untuk melakukan pengecekan apakah user telah login dengan mencari token dengan SharedPreferences
//   Future<bool> _isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     return token != null && token.isNotEmpty;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       navigatorObservers: [routeObserver],
//       home: FutureBuilder<bool>(
//         future: _isLoggedIn(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           }
//           // jika ditemukan data user yang sedang login, maka akan diarahkan ke "MainScreen" yang menampung halaman-halaman utama pada aplikasi  
//           else if (snapshot.hasData && snapshot.data == true) {
//             return const MainScreen();
//           }
//           // jika tidak ditemukan data user login, maka akan diarahkan ke halaman login 
//           else {
//             return const LoginPage();
//           }
//         },
//       ),
//     );
//   }
// }

// // class untuk menampung halaman-halaman utama aplikasi
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   // variabel yang menyimpan indeks terpilih pada bottom navbar
//   int _selectedIndex = 0;

//   // halaman-halaman pada bottom navbar
//   final List<Widget> _pages = [
//     const HomeScreen(), // halaman home  
//     const TransactionListPage(), // halaman daftar transaksi
//     const NotificationPage(), // halaman notifikasi
//     const ProfilePage(), // halaman profil
//   ];

//   // mengambil data profil dari user saat init state
//   @override
//   void initState() {
//     super.initState();
//     fetchUserProfile();
//   }

//   // untuk mengambil data profil user
//   Future<void> fetchUserProfile() async {
//     // mengambil data token user
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');

//     if (token == null) return;

//     // respon http ke endpoint mendapatkan data user
//     try {
//       final response = await http.get(
//         Uri.parse('$responseUrl/api/user'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       // mengirimkan data user jika respon berhasil
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final name = data['name'];
//         final email = data['email'];
//         await prefs.setString('namaUser', name);
//         await prefs.setString('emailUser', email);
//       } else {
//         debugPrint("Gagal ambil user profile: ${response.body}");
//       }
//     } catch (e) {
//       debugPrint("Error ambil user profile: $e");
//     }
//   }
  
//   // fungsi untuk merekam item yang ditap   
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // menampilkan halaman sesuai dengan indeks terpilih pada bottom navbar 
//       body: _pages[_selectedIndex],
//       // mengatur tampilan bottom navbar & isi item halaman per indeks pada bottom navbar
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_bag), label: "Transactions"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.notifications), label: "Notification"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:ta_c14210052/views/pages/app/home_screen.dart';
import 'package:ta_c14210052/views/pages/app/notification_page.dart';
import 'package:ta_c14210052/views/pages/app/profile_page.dart';
import 'package:ta_c14210052/views/pages/app/transaction_list_page.dart';
import 'package:ta_c14210052/views/pages/auth/login_page.dart';
import 'package:intl/date_symbol_data_local.dart'; // untuk format tanggal indo

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

// GLOBAL VALUE NOTIFIER UNTUK JUMLAH NOTIFIKASI
final ValueNotifier<int> notificationCountNotifier = ValueNotifier(0);

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  // supaya aplikasi hanya bisa pada orientasi portrait saja
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // untuk inisialisasi bahasa indonesia
  await initializeDateFormatting(
      'id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // untuk melakukan pengecekan apakah user telah login dengan mencari token dengan SharedPreferences
  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      home: FutureBuilder<bool>(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // jika ditemukan data user yang sedang login, maka akan diarahkan ke "MainScreen" yang menampung halaman-halaman utama pada aplikasi
          else if (snapshot.hasData && snapshot.data == true) {
            return const MainScreen();
          }
          // jika tidak ditemukan data user login, maka akan diarahkan ke halaman login
          else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

// class untuk menampung halaman-halaman utama aplikasi
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // variabel yang menyimpan indeks terpilih pada bottom navbar
  int _selectedIndex = 0;

  // halaman-halaman pada bottom navbar
  final List<Widget> _pages = [
    const HomeScreen(), // halaman home
    const TransactionListPage(), // halaman daftar transaksi
    const NotificationPage(), // halaman notifikasi
    const ProfilePage(), // halaman profil
  ];

  // mengambil data profil dari user saat init state
  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    _fetchInitialNotificationCount(); // Panggil untuk mendapatkan jumlah notifikasi awal
  }

  // untuk mengambil data profil user
  Future<void> fetchUserProfile() async {
    // mengambil data token user
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    // respon http ke endpoint mendapatkan data user
    try {
      final response = await http.get(
        Uri.parse('$responseUrl/api/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      // mengirimkan data user jika respon berhasil
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final name = data['name'];
        final email = data['email'];
        await prefs.setString('namaUser', name);
        await prefs.setString('emailUser', email);
      } else {
        debugPrint("Gagal ambil user profile: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error ambil user profile: $e");
    }
  }

  // Untuk mengambil jumlah notifikasi saat aplikasi pertama kali dimuat
  Future<void> _fetchInitialNotificationCount() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      notificationCountNotifier.value = 0; // Set to 0 if no token
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$responseUrl/api/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Pastikan data adalah List sebelum mengambil panjangnya
        if (data is List) {
          notificationCountNotifier.value = data.length;
        } else {
          notificationCountNotifier.value = 0;
        }
      } else {
        debugPrint("Failed to fetch initial notification count: ${response.body}");
        notificationCountNotifier.value = 0;
      }
    } catch (e) {
      debugPrint("Error fetching initial notification count: $e");
      notificationCountNotifier.value = 0;
    }
  }

  // fungsi untuk merekam item yang ditap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // menampilkan halaman sesuai dengan indeks terpilih pada bottom navbar
      body: _pages[_selectedIndex],
      // mengatur tampilan bottom navbar & isi item halaman per indeks pada bottom navbar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: "Transactions"),
          // Menggunakan ValueListenableBuilder untuk badge notifikasi
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<int>(
              valueListenable: notificationCountNotifier,
              builder: (context, count, child) {
                return Stack(
                  children: [
                    const Icon(Icons.notifications),
                    if (count > 0) // Tampilkan badge hanya jika count > 0
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                  ],
                );
              },
            ),
            label: "Notification",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
