// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class QuantitySelectorCart extends StatefulWidget {
//   final int cartId;
//   final int quantity;
//   final int stock;
//   final Function(int, int, int) updateQuantity;

//   QuantitySelectorCart({
//     required this.cartId,
//     required this.quantity,
//     required this.stock,
//     required this.updateQuantity,
//   });

//   @override
//   _QuantitySelectorCartState createState() => _QuantitySelectorCartState();
// }

// class _QuantitySelectorCartState extends State<QuantitySelectorCart> {
//   late TextEditingController _controller;
//   bool _isUpdating = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController(text: widget.quantity.toString());
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _updateQuantity(int newQuantity) {
//     if (newQuantity < 1) {
//       newQuantity = 1;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Stok tidak dapat kosong!')),
//       );
//     } else if (newQuantity > widget.stock) {
//       newQuantity = widget.stock;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Jumlah melebihi stok!')),
//       );
//     }

//     if (!_isUpdating) {
//       _isUpdating = true;
//       setState(() {
//         _controller.text = newQuantity.toString();
//         _controller.selection = TextSelection.fromPosition(
//             TextPosition(offset: _controller.text.length));
//       });
//       widget.updateQuantity(widget.cartId, newQuantity, widget.stock);
//       _isUpdating = false;
//     }
//   }

//   void _onTextChanged(String value) {
//     if (_isUpdating) return;
//     int? newQuantity = int.tryParse(value);
//     if (newQuantity != null) {
//       _updateQuantity(newQuantity);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         // Tombol "-"
//         Container(
//           width: 32,
//           height: 28,
//           decoration: BoxDecoration(
//             color: Colors.grey[500],
//             borderRadius: BorderRadius.circular(4),
//           ),
//           child: IconButton(
//             icon: Icon(Icons.remove, color: Colors.white, size: 16),
//             onPressed: () {
//               int newQuantity = int.tryParse(_controller.text) ?? 1;
//               if (newQuantity > 1) {
//                 _updateQuantity(newQuantity - 1);
//               }
//             },
//             padding: EdgeInsets.zero,
//             constraints: BoxConstraints(),
//           ),
//         ),
//         SizedBox(width: 1),

//         // Inputan jumlah kuantitas
//         SizedBox(
//           width: 50,
//           child: TextField(
//             controller: _controller,
//             keyboardType: TextInputType.number,
//             textAlign: TextAlign.center,
//             decoration: InputDecoration(
//               contentPadding: EdgeInsets.symmetric(vertical: 6),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
//             ),
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             onChanged: _onTextChanged, // Update saat user mengetik
//           ),
//         ),

//         SizedBox(width: 1),

//         // Tombol "+"
//         Container(
//           width: 32,
//           height: 28,
//           decoration: BoxDecoration(
//             color: Colors.grey[500],
//             borderRadius: BorderRadius.circular(4),
//           ),
//           child: IconButton(
//             icon: Icon(Icons.add, color: Colors.white, size: 16),
//             onPressed: () {
//               int newQuantity = int.tryParse(_controller.text) ?? 1;
//               if (newQuantity < widget.stock) {
//                 _updateQuantity(newQuantity + 1);
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Jumlah kuantitas melebihi stok')),
//                 );
//               }
//             },
//             padding: EdgeInsets.zero,
//             constraints: BoxConstraints(),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class QuantitySelectorCart extends StatefulWidget {
  final int cartId;
  final int quantity;
  final int stock;
  final DateTime expiredDate;
  final Function(int, int, int, DateTime) updateQuantity;

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
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => changeQuantity(currentQuantity - 1),
        ),
        Text("$currentQuantity"),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => changeQuantity(currentQuantity + 1),
        ),
      ],
    );
  }
}
