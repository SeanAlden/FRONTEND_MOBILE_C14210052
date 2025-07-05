import 'package:flutter/material.dart';

// widget quantity selector
class QuantitySelectorCart extends StatefulWidget {
  final int cartId; // mencari cart id
  final int quantity; // kuantitas yang dipilih
  final int stock; // stok produk pada tanggal yg dipilih
  final DateTime expiredDate; // tanggal kadaluarsa yang dipilih
  final Function(int, int, int, DateTime) updateQuantity; // fungsi untuk update kuantitas

  const QuantitySelectorCart({super.key, 
    required this.cartId,
    required this.quantity,
    required this.stock,
    required this.expiredDate,
    required this.updateQuantity,
  });

  @override
  _QuantitySelectorCartState createState() => _QuantitySelectorCartState();
}

class _QuantitySelectorCartState extends State<QuantitySelectorCart> {
  late int currentQuantity;

  @override
  void initState() {
    super.initState();
    currentQuantity = widget.quantity;
  }

  // fungsi mengubah kuantitas produk
  void changeQuantity(int newQuantity) {
    if (newQuantity > 0 && newQuantity <= widget.stock) {
      setState(() {
        currentQuantity = newQuantity;
      });
      widget.updateQuantity(widget.cartId, newQuantity, widget.stock, widget.expiredDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // menghapus kuantitas
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => changeQuantity(currentQuantity - 1),
        ),
        Text("$currentQuantity"),
        // menambah kuantitas
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => changeQuantity(currentQuantity + 1),
        ),
      ],
    );
  }
}
