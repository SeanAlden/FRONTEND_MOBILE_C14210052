// class Cart {
//   final int id;
//   final int productId;
//   final String productName;
//   final String productImage;
//   final double productPrice;
//   final int productStock;
//   final int quantity;
//   final double grossAmount; // Ubah dari int ke double

//   Cart({
//     required this.id,
//     required this.productId,
//     required this.productName,
//     required this.productImage,
//     required this.productPrice,
//     required this.productStock,
//     required this.quantity,
//     required this.grossAmount,
//   });

//   factory Cart.fromJson(Map<String, dynamic> json) {
//     return Cart(
//       id: json['id'],
//       productId: json['product']['id'] ?? 0,
//       productName: json['product']['name'] ?? '',
//       productImage: json['product']['photo'] ?? '', // Perbaikan field
//       productPrice: double.parse(json['product']['price']) ?? 0.0,
//       productStock: json['product']['stock'] ?? 0,
//       quantity: json['quantity'] ?? 0,
//       grossAmount: double.parse(json['gross_amount']) ?? 0.0, // Perbaikan tipe data
//     );
//   }
// }

// class Cart {
//   final int id;
//   final int productId;
//   final String productName;
//   final String productImage;
//   final double productPrice;
//   final int productStock;
//   final int quantity;
//   final double grossAmount;
//   final List<DateTime> expiredDates; // Menampung daftar tanggal kadaluarsa

//   Cart({
//     required this.id,
//     required this.productId,
//     required this.productName,
//     required this.productImage,
//     required this.productPrice,
//     required this.productStock,
//     required this.quantity,
//     required this.grossAmount,
//     required this.expiredDates,
//   });

//   factory Cart.fromJson(Map<String, dynamic> json) {
//     return Cart(
//       id: json['id'],
//       productId: json['product']['id'] ?? 0,
//       productName: json['product']['name'] ?? '',
//       productImage: json['product']['photo'] ?? '',
//       productPrice: double.parse(json['product']['price'].toString()) ?? 0.0,
//       productStock: json['product']['stock'] ?? 0,
//       quantity: json['quantity'] ?? 0,
//       grossAmount: double.parse(json['gross_amount'].toString()) ?? 0.0,
//       expiredDates: (json['product']['expired_dates'] as List?)?.map((date) {
//             return DateTime.tryParse(date.toString()) ?? DateTime.now();
//           }).toList() ??
//           [], // Pastikan tidak null
//     );
//   }
// }

// class Cart {
//   final int id;
//   final int productId;
//   final String productName;
//   final String productImage;
//   final double productPrice;
//   final int quantity;
//   final double grossAmount;
//   final DateTime? expiredDate; // Ubah menjadi nullable

//   Cart({
//     required this.id,
//     required this.productId,
//     required this.productName,
//     required this.productImage,
//     required this.productPrice,
//     required this.quantity,
//     required this.grossAmount,
//     this.expiredDate, // Tidak perlu required karena nullable
//   });

//   factory Cart.fromJson(Map<String, dynamic> json) {
//     return Cart(
//       id: json['id'],
//       productId: json['product_id'],
//       productName: json['product_name'],
//       productImage: json['product_image'],
//       productPrice: double.parse(json['product_price'].toString()),
//       quantity: json['quantity'],
//       grossAmount: double.parse(json['gross_amount'].toString()),
//       expiredDate: json['expired_date'] != null
//           ? DateTime.tryParse(json['expired_date']) ?? DateTime(1970, 1, 1) // Default jika gagal parse
//           : null, // Jika null, tetap null
//     );
//   }
// }

// class Cart {
//   final int id;
//   final int productId;
//   final String productName;
//   final String productImage;
//   final double productPrice;
//   final int quantity;
//   final double grossAmount;
//   final DateTime? expiredDate; // Nullable untuk tanggal kadaluarsa
//   final int stock; // Tambahkan properti stock

//   Cart({
//     required this.id,
//     required this.productId,
//     required this.productName,
//     required this.productImage,
//     required this.productPrice,
//     required this.quantity,
//     required this.grossAmount,
//     this.expiredDate, // Tidak perlu required karena nullable
//     required this.stock, // Tambahkan stock sebagai required
//   });

//   factory Cart.fromJson(Map<String, dynamic> json) {
//     return Cart(
//       id: json['id'],
//       productId: json['product_id'],
//       productName: json['product_name'],
//       productImage: json['product_image'],
//       productPrice: double.parse(json['product_price'].toString()),
//       quantity: json['quantity'],
//       grossAmount: double.parse(json['gross_amount'].toString()),
//       expiredDate: json['expired_date'] != null
//           ? DateTime.tryParse(json['expired_date']) ?? DateTime(1970, 1, 1) // Default jika gagal parse
//           : null,
//       stock: json['stock'] ?? 0, // Ambil stock dari JSON, jika null set ke 0
//     );
//   }
// }

class Cart {
  final int id;
  final int userId;
  final int productId;
  final String productName;
  final String productImage;
  final double productPrice;
  int quantity;
  double grossAmount;
  final DateTime? expiredDate;
  int stock;
  final String? shippingMethod;
  final String paymentMethod;

  Cart({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.quantity,
    required this.grossAmount,
    this.expiredDate,
    required this.stock,
    this.shippingMethod,
    required this.paymentMethod,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      productImage: json['product_image'],
      productPrice: double.tryParse(json['product_price'].toString()) ?? 0.0,
      quantity: json['quantity'],
      grossAmount: double.tryParse(json['gross_amount'].toString()) ?? 0.0,
      expiredDate: json['expired_date'] != null
          ? DateTime.tryParse(json['expired_date'])
          : null,
      stock: json['stock'] ?? 0,
      shippingMethod: json['shipping_method'],
      paymentMethod: json['payment_method'] ?? 'Cash',
      // stockByDates: (json['stock_by_dates'] as List).map((s) => StockByDate.fromJson(s)).toList(),

    );
  }
}


