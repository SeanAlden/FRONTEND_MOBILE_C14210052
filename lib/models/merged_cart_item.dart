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

import 'package:ta_c14210052/models/cart.dart';

class MergedCartItem {
  final int productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final List<Cart> originalItems; // semua item dengan tanggal expired berbeda
  final int totalStock;
  int quantity;

  MergedCartItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.originalItems,
    required this.totalStock,
    required this.quantity,
  });

  /// Getter untuk ambil ID dari cart pertama (untuk keperluan update/delete)
  int get id => originalItems.first.id;

  /// Getter untuk hitung grossAmount total dari semua item
  double get grossAmount =>
      originalItems.fold(0.0, (sum, item) => sum + item.grossAmount);

  /// Getter untuk tanggal expired terdekat (FIFO)
  DateTime? get expiredDate => originalItems.first.expiredDate;

  /// Getter stok adalah total stok dari semua item
  int get stock => totalStock;
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
