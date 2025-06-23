// import 'package:ta_c14210052/models/cart.dart';

// class MergedCartItem {
//   final int productId;
//   final String productName;
//   final String productImage;
//   final double productPrice;
//   final List<Cart> originalItems; // semua item dengan tanggal expired berbeda
//   final int totalStock;
//   int quantity;

//   MergedCartItem({
//     required this.productId,
//     required this.productName,
//     required this.productImage,
//     required this.productPrice,
//     required this.originalItems,
//     required this.totalStock,
//     required this.quantity,
//   });
// }

// import 'package:ta_c14210052/models/cart.dart';

// class MergedCartItem {
//   final int productId;
//   final String productName;
//   final String productImage;
//   final double productPrice;
//   final List<Cart> originalItems; // semua item dengan tanggal expired berbeda
//   final int totalStock;
//   int quantity;
//   // final List<ProductStock> allProductStocks;

//   MergedCartItem({
//     required this.productId,
//     required this.productName,
//     required this.productImage,
//     required this.productPrice,
//     required this.originalItems,
//     required this.totalStock,
//     required this.quantity,
//     // required this.allProductStocks,
//   });

//   /// Getter untuk ambil ID dari cart pertama (untuk keperluan update/delete)
//   int get id => originalItems.first.id;

//   /// Getter untuk hitung grossAmount total dari semua item
//   double get grossAmount =>
//       originalItems.fold(0.0, (sum, item) => sum + item.grossAmount);

//   /// Getter untuk tanggal expired terdekat (FIFO)
//   DateTime? get expiredDate => originalItems.first.expiredDate;

//   /// Getter stok adalah total stok dari semua item
//   int get stock => totalStock;
// }

import 'package:ta_c14210052/models/cart.dart';

// class ini digunakan untuk menggabungkan / menjumlahkan stok dari tiap tanggal kadaluarsa 
class MergedCartItem {
  final int productId; // id produk
  final String productName; // nama produk
  final String productImage; // gambar produk
  final double productPrice; // harga produk
  final List<Cart> originalItems; // item produk-produk dari keranjang sebelum digabung / dijumlahkan stoknya  
  final int totalStock; // total stok dari gabungan/jumlahan tiap stok pada per tanggal expired
  int quantity; // kuantitas yang dipilih employee pada produk terkait

  MergedCartItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.originalItems,
    required this.totalStock,
    required this.quantity,
  });

  // getter untuk mengambil id dari cart pertama (untuk keperluan update/delete)
  int get id => originalItems.first.id;

  // getter untuk hitung harga total dari semua item produk yang masuk
  double get grossAmount =>
      originalItems.fold(0.0, (sum, item) => sum + item.grossAmount);

  // getter untuk mencari dan mengambil tanggal expired terdekat pada tiap barang
  DateTime? get expiredDate => originalItems.first.expiredDate;

  // getter total stok dari semua item tanggal kadaluarsa
  int get stock => totalStock;

  // mengambil data dari API
  factory MergedCartItem.fromJson(Map<String, dynamic> json) {
    return MergedCartItem(
      productId: (json['product_id'] is String)
          ? int.tryParse(json['product_id']) ?? 0
          : json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      productImage: json['product_image'] ?? '',
      productPrice: double.tryParse(json['product_price'].toString()) ?? 0.0,
      originalItems: (json['original_items'] as List<dynamic>? ?? [])
          .map((item) => Cart.fromJson(item))
          .toList(),
      totalStock: (json['total_stock'] is String)
          ? int.tryParse(json['total_stock']) ?? 0
          : json['total_stock'] ?? 0,
      quantity: (json['quantity'] is String)
          ? int.tryParse(json['quantity']) ?? 0
          : json['quantity'] ?? 0,
    );
  }
}

// import 'package:ta_c14210052/models/cart.dart';

// class MergedCartItem {
//   final int productId;
//   final String productName;
//   final String productImage;
//   final double productPrice;
//   final List<Cart> originalItems; // semua item dengan tanggal expired berbeda
//   final int totalStock;
//   int quantity;

//   MergedCartItem({
//     required this.productId,
//     required this.productName,
//     required this.productImage,
//     required this.productPrice,
//     required this.originalItems,
//     required this.totalStock,
//     required this.quantity,
//   });

//   /// Getter untuk ambil ID dari cart pertama (untuk keperluan update/delete)
//   int get id => originalItems.first.id;

//   /// Getter untuk hitung grossAmount total dari semua item
//   double get grossAmount =>
//       originalItems.fold(0.0, (sum, item) => sum + item.grossAmount);

//   /// Getter untuk tanggal expired terdekat (FIFO)
//   DateTime? get expiredDate {
//     final allDates = originalItems
//         .expand((cart) => cart.stockDetails)
//         .map((detail) => detail.expiredDate)
//         .toList();

//     if (allDates.isEmpty) return null;
//     allDates.sort();
//     return allDates.first;
//   }

//   /// Getter stok adalah total stok dari semua item
//   int get stock => totalStock;
// }
