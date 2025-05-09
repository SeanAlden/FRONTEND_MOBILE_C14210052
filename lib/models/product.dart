// class Product {
//   final int id;
//   final String name;
//   final String description;
//   final String imageUrl;
//   final int stock;
//   final double price;
//   final String exp_date;

//   Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.imageUrl,
//     required this.stock,
//     required this.price,
//     required this.exp_date,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'] ?? '',
//       name: json['name'] ?? 'Unknown',
//       description: json['description'] ?? 'No Description',
//       imageUrl: json['photo'] ?? '',
//       stock: json['stock'] ?? 0,
//       // price: json['price'].toDouble(),
//       // price: json['price'] ?? 0.0,
//       price: (json['price'] is String)
//           ? double.tryParse(json['price']) ?? 0.0
//           : json['price'] ?? 0.0, // Perbaikan di sini
//       exp_date: json['exp_date'] ?? 0,
//     );
//   }

//   // factory Product.fromJson(Map<String, dynamic> json) {
//   //   return Product(
//   //     id: json['id'] ?? 0,
//   //     name: json['name'] ?? 'Unknown',
//   //     description: json['description'] ?? 'No Description',
//   //     imageUrl: json['photo'] ?? '', // Berikan nilai default jika null
//   //     stock: json['stock'] ?? 0,
//   //     price: (json['price'] is String)
//   //         ? double.tryParse(json['price']) ?? 0.0
//   //         : (json['price'] ?? 0.0), // Perbaikan di sini
//   //     exp_date: json['exp_date'] ?? '', // Pastikan ini juga aman
//   //   );
//   // }
// }

// class Product {
//   final int id;
//   final String name;
//   final String description;
//   final String imageUrl;
//   final int stock;
//   final double price;
//   final String exp_date;
//   final String? category; // Tambahkan kategori

//   Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.imageUrl,
//     required this.stock,
//     required this.price,
//     required this.exp_date,
//     this.category,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? 'Unknown',
//       description: json['description'] ?? 'No Description',
//       imageUrl: json['photo'] ?? '',
//       stock: json['stock'] ?? 0,
//       price: (json['price'] is String)
//           ? double.tryParse(json['price']) ?? 0.0
//           : json['price'] ?? 0.0,
//       exp_date: json['exp_date'] ?? '',
//       category: json['category'] != null ? json['category']['name'] : 'No Category', // Ambil kategori dari JSON
//     );
//   }
// }

// import 'package:intl/intl.dart';

// class Product {
//   final int id;
//   final String name;
//   final String description;
//   final String imageUrl;
//   final double price;
//   final String? category;
//   final List<ProductStock> stocks; // List untuk menyimpan stok berdasarkan exp_date

//   Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.imageUrl,
//     required this.price,
//     this.category,
//     required this.stocks,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? 'Unknown',
//       description: json['description'] ?? 'No Description',
//       imageUrl: json['photo'] ?? '',
//       price: (json['price'] is String)
//           ? double.tryParse(json['price']) ?? 0.0
//           : json['price'] ?? 0.0,
//       category: json['category'] != null ? json['category']['name'] : 'No Category',
//       stocks: (json['stocks'] as List<dynamic>?)
//               ?.map((stockJson) => ProductStock.fromJson(stockJson))
//               .toList() ??
//           [], // Jika tidak ada stok, gunakan list kosong
//     );
//   }

//   // Mendapatkan total stok dari semua entri `product_stocks`
//   int get totalStock => stocks.fold(0, (sum, stock) => sum + stock.stock);

//   // Mendapatkan tanggal kedaluwarsa terdekat
//   String get nearestExpDate {
//     if (stocks.isEmpty) return "No Exp Date";
//     stocks.sort((a, b) => a.expDate.compareTo(b.expDate)); // Urutkan dari yang paling dekat
//     return DateFormat('yyyy-MM-dd').format(stocks.first.expDate);
//   }
// }

// // Model untuk stok produk
// class ProductStock {
//   final DateTime expDate;
//   final int stock;

//   ProductStock({
//     required this.expDate,
//     required this.stock,
//   });

//   factory ProductStock.fromJson(Map<String, dynamic> json) {
//     return ProductStock(
//       expDate: DateTime.parse(json['exp_date']),
//       stock: json['stock'] ?? 0,
//     );
//   }
// }

// import 'package:intl/intl.dart';

// class Product {
//   final int id;
//   final String name;
//   final String description;
//   final String imageUrl;
//   final double price;
//   final String? category;
//   final List<ProductStock> stocks; // List untuk menyimpan stok berdasarkan exp_date

//   Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.imageUrl,
//     required this.price,
//     this.category,
//     required this.stocks,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? 'Unknown',
//       description: json['description'] ?? 'No Description',
//       imageUrl: json['photo'] ?? '',
//       price: (json['price'] is String)
//           ? double.tryParse(json['price']) ?? 0.0
//           : json['price'] ?? 0.0,
//       category: json['category'] != null ? json['category']['name'] : 'No Category',
//       stocks: (json['stocks'] as List<dynamic>?)
//               ?.map((stockJson) => ProductStock.fromJson(stockJson))
//               .toList() ??
//           [], // Jika tidak ada stok, gunakan list kosong
//     );
//   }

//   // Mendapatkan total stok dari semua entri `product_stocks`
//   int get totalStock => stocks.fold(0, (sum, stock) => sum + stock.stock);

//   // Mendapatkan tanggal kedaluwarsa terdekat
//   String get nearestExpDate {
//     if (stocks.isEmpty) return "No Exp Date";
//     stocks.sort((a, b) => a.expDate.compareTo(b.expDate)); // Urutkan dari yang paling dekat
//     return DateFormat('yyyy-MM-dd').format(stocks.first.expDate);
//   }

//   // Mendapatkan daftar stok per tanggal expired dalam format yang bisa ditampilkan
//   List<String> get stockPerExpDate {
//     if (stocks.isEmpty) return ["No stock available"];
//     stocks.sort((a, b) => a.expDate.compareTo(b.expDate)); // Urutkan stok dari yang paling dekat
//     return stocks
//         .map((s) => "${DateFormat('yyyy-MM-dd').format(s.expDate)}: ${s.stock} pcs")
//         .toList();
//   }
// }

// // Model untuk stok produk
// class ProductStock {
//   final DateTime expDate;
//   final int stock;

//   ProductStock({
//     required this.expDate,
//     required this.stock,
//   });

//   factory ProductStock.fromJson(Map<String, dynamic> json) {
//     return ProductStock(
//       expDate: DateTime.parse(json['exp_date']),
//       stock: json['stock'] ?? 0,
//     );
//   }
// }

// class Product {
//   final int id;
//   final String name;
//   final String category;
//   final String description;
//   final String imageUrl;
//   final int price;
//   final List<ExpStock> expStocks; // List tanggal expired dan stoknya

//   Product({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.description,
//     required this.imageUrl,
//     required this.price,
//     required this.expStocks,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       name: json['name'],
//       category: json['category'] ?? "No Category",
//       description: json['description'],
//       imageUrl: json['imageUrl'] ?? "",
//       price: json['price'],
//       expStocks: (json['expStocks'] as List)
//           .map((exp) => ExpStock.fromJson(exp))
//           .toList(),
//     );
//   }
// }

// class ExpStock {
//   final String expDate;
//   final int stock;

//   ExpStock({required this.expDate, required this.stock});

//   factory ExpStock.fromJson(Map<String, dynamic> json) {
//     return ExpStock(
//       expDate: json['exp_date'],
//       stock: json['stock'],
//     );
//   }
// }

// import 'package:intl/intl.dart';

// class Product {
//   final int id;
//   final String name;
//   final String description;
//   final String imageUrl;
//   final double price;
//   final String? category;
//   final List<ProductStock> stocks;

//   Product(
//       {
//         required this.id,
//         required this.name,
//         required this.description,
//         required this.imageUrl,
//         required this.price,
//         this.category,
//         required this.stocks,
//       }
//     );

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? 'Unknown',
//       description: json['description'] ?? 'No Description',
//       imageUrl: json['photo'] ?? '',
//       price: (json['price'] is String)
//           ? double.tryParse(json['price']) ?? 0.0
//           : json['price'] ?? 0.0,
//       category:
//           json['category'] != null ? json['category']['name'] : 'No Category',
//       stocks: (json['stocks'] as List<dynamic>?)
//               ?.map((stockJson) => ProductStock.fromJson(stockJson))
//               .toList() ??
//           [],
//     );
//   }

//   // Mendapatkan total stok dari semua entri `product_stocks`
//   int get totalStock => stocks.fold(0, (sum, stock) => sum + stock.stock);

//   // Mendapatkan tanggal kedaluwarsa terdekat
//   String get nearestExpDate {
//     if (stocks.isEmpty) return "No Exp Date";
//     stocks.sort((a, b) => a.expDate.compareTo(b.expDate));
//     return DateFormat('yyyy-MM-dd').format(stocks.first.expDate);
//   }

//   // Mendapatkan daftar stok berdasarkan tanggal kedaluwarsa
//   List<Map<String, dynamic>> get stockByExpDate {
//     stocks.sort((a, b) => a.expDate.compareTo(b.expDate));
//     return stocks.map((stock) {
//       return {
//         "expDate": DateFormat('yyyy-MM-dd').format(stock.expDate),
//         "stock": stock.stock,
//       };
//     }).toList();
//   }
// }

// class ProductStock {
//   final DateTime expDate;
//   final int stock;

//   ProductStock({
//     required this.expDate,
//     required this.stock,
//   });

//   factory ProductStock.fromJson(Map<String, dynamic> json) {
//     return ProductStock(
//       expDate: DateTime.parse(json['exp_date']),
//       stock: json['stock'] ?? 0,
//     );
//   }
// }

import 'package:intl/intl.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String? category;
  final List<ProductStock> stocks;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.category,
    required this.stocks,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'No Description',
      imageUrl: json['photo'] ?? '',
      price: (json['price'] is String)
          ? double.tryParse(json['price']) ?? 0.0
          : json['price'] ?? 0.0,
      category:
          json['category'] != null ? json['category']['name'] : 'No Category',
      stocks: (json['stocks'] as List<dynamic>?)
              ?.map((stockJson) => ProductStock.fromJson(stockJson))
              .toList() ??
          [],
    );
  }

  // Mendapatkan total stok dari semua entri `product_stocks`
  int get totalStock => stocks.fold(0, (sum, stock) => sum + stock.stock);

  // Mendapatkan tanggal kedaluwarsa terdekat
  // String get nearestExpDate {
  ProductStock? get nearestExpDate {
    // if (stocks.isEmpty) return "No Exp Date";
    // stocks.sort((a, b) => a.expDate.compareTo(b.expDate));
    // return DateFormat('yyyy-MM-dd').format(stocks.first.expDate);
    List<ProductStock> validStocks =
        stocks.where((stock) => stock.expDate.isAfter(DateTime.now())).toList();
    if (validStocks.isEmpty) return null;
    validStocks.sort((a, b) => a.expDate.compareTo(b.expDate));
    return validStocks.first;
  }

  String get fifoExp {
    if (stocks.isEmpty) return "No Exp Date";
    stocks.sort((a, b) => a.expDate.compareTo(b.expDate));
    return DateFormat('yyyy-MM-dd').format(stocks.first.expDate);
  }

  // Mendapatkan daftar stok berdasarkan tanggal kedaluwarsa
  List<Map<String, dynamic>> get stockByExpDate {
    stocks.sort((a, b) => a.expDate.compareTo(b.expDate));
    return stocks.map((stock) {
      return {
        "expDate": DateFormat('yyyy-MM-dd').format(stock.expDate),
        "stock": stock.stock,
      };
    }).toList();
  }
}

class ProductStock {
  final DateTime expDate;
  final int stock;

  ProductStock({
    required this.expDate,
    required this.stock,
  });

  factory ProductStock.fromJson(Map<String, dynamic> json) {
    return ProductStock(
      expDate: DateTime.parse(json['exp_date']),
      stock: json['stock'] ?? 0,
    );
  }
}
