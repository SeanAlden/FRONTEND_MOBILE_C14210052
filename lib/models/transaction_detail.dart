class TransactionDetail {
  final int? productId;
  final String? name;
  final String? code;
  final double? price;
  final int? quantity;
  final String? photo;
  final String expDate;

  TransactionDetail({
    required this.productId,
    required this.name,
    required this.code,
    required this.price,
    required this.quantity,
    required this.photo,
    required this.expDate,  
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      productId: json['product_id'] ?? 0,
      name: json['product_name'] ?? 'Unknown',      
      code: json['product_code'] ?? '',             
      price: double.tryParse(json['product_price'].toString()) ?? 0.0,
      quantity: json['quantity'] ?? 0,
      expDate: json['exp_date'] ?? '',
      // photo: json['photo'] ?? '',  
      photo: json['product_photo'],
      // photo: json['product']?['photo'] ?? '',
    );
  }
}


