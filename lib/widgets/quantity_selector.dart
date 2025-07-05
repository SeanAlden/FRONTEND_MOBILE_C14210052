import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget {
  final int stock;
  final Function(int) onQuantityChanged;

  const QuantitySelector({super.key, required this.stock, required this.onQuantityChanged});

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int quantity = 0; 
  late TextEditingController _controller;
  bool isEmpty = false; // Menandai apakah input kosong

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateAndSetQuantity(String value) {
    if (value.isEmpty) {
      setState(() {
        isEmpty = true;
      });
      return;
    }

    int? newQuantity = int.tryParse(value);

    if (newQuantity == null || newQuantity < 1) {
      newQuantity = 1;
    } else if (newQuantity > widget.stock) {
      newQuantity = widget.stock;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah kuantitas melebihi stok')),
      );
    }

    setState(() {
      isEmpty = false;
      quantity = newQuantity!;
      _controller.value = TextEditingValue(
        text: quantity.toString(),
        selection: TextSelection.collapsed(offset: quantity.toString().length),
      );
    });

    widget.onQuantityChanged(quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey[500],
            shape: BoxShape.rectangle,
          ),
          child: IconButton(
            icon: const Icon(Icons.remove, color: Colors.white, size: 16),
            onPressed: () {
              if (quantity > 1) {
                setState(() {
                  quantity--;
                  _controller.text = quantity.toString();
                });
                widget.onQuantityChanged(quantity);
              }
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
        const SizedBox(width: 1),

        // Input jumlah kuantitas
        SizedBox(
          width: 50,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 6),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() => isEmpty = true);
              } else {
                _validateAndSetQuantity(value);
              }
            },
            onEditingComplete: () {
              if (isEmpty) {
                _validateAndSetQuantity('1'); // Kembalikan ke 1 jika kosong
              }
            },
          ),
        ),

        const SizedBox(width: 1),

        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey[500],
            shape: BoxShape.rectangle,
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 16),
            onPressed: () {
              if (quantity < widget.stock) {
                setState(() {
                  quantity++;
                  _controller.text = quantity.toString();
                });
                widget.onQuantityChanged(quantity);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Jumlah kuantitas melebihi stok')),
                );
              }
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }
}
