// import 'package:ta_c14210052/models/product.dart';

// class TransactionDetail {
//   final int? productId;
//   final String? name;
//   final String? code;
//   final double? price;
//   final int? quantity;
//   final String? photo;
//   final String expDate;
//   final Product? product; // Add this line

//   TransactionDetail({
//     required this.productId,
//     required this.name,
//     required this.code,
//     required this.price,
//     required this.quantity,
//     required this.photo,
//     required this.expDate,
//     this.product, // Add this line
//   });

//   factory TransactionDetail.fromJson(Map<String, dynamic> json) {
//     return TransactionDetail(
//       productId: json['product_id'] ?? 0,
//       name: json['product_name'] ?? 'Unknown',
//       code: json['product_code'] ?? '',
//       price: double.tryParse(json['product_price'].toString()) ?? 0.0,
//       quantity: json['quantity'] ?? 0,
//       expDate: json['exp_date'] ?? '',
//       // photo: json['photo'] ?? '',
//       photo: json['product_photo'],
//       // photo: json['product']?['photo'] ?? '',
//       product: json['product'] != null
//           ? Product.fromJson(json['product'])
//           : null, // Add this line
//     );
//   }
// }

import 'package:ta_c14210052/models/product.dart';

class TransactionDetail {
  final int? productId; // id produk didalam transaksi terkait
  final String? name; // nama produk
  final String? code; // kode produk
  final double? price; // harga produk
  final int? quantity; // kuantitas produk
  final String? photo; // gambar produk
  final String expDate; // tanggal kadaluarsa produk
  final Product? product; // produk 

  TransactionDetail({
    required this.productId,
    required this.name,
    required this.code,
    required this.price,
    required this.quantity,
    required this.photo,
    required this.expDate,
    this.product,
  });

  // API response
  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      productId: _parseInt(json['product_id']),
      name: json['product_name'] ?? 'Unknown',
      code: json['product_code'] ?? '',
      price: _parseDouble(json['product_price']),
      quantity: _parseInt(json['quantity']),
      expDate: json['exp_date'] ?? '',
      photo: json['product_photo'],
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }

  // melakukan parse ke int
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // melakukan parse ke double
  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
