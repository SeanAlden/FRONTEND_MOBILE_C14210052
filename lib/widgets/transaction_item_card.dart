import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:ta_c14210052/models/transaction_response.dart';
import 'package:ta_c14210052/views/pages/app/transaction_detail_page.dart';

class TransactionItemCard extends StatelessWidget {
  final TransactionResponse
      transactionResponse; // untuk mengambil data transaksi
  final VoidCallback?
      onRefresh; // memperbarui tampilan widget langsung jika pemanggilan data dari api nya berubah

  const TransactionItemCard({
    super.key,
    required this.transactionResponse,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final transaction =
        transactionResponse.transaction; // mengambil data transaksi
    final firstProduct = transaction.details.isNotEmpty
        ? transaction.details[0]
        : null; // mengambil data salah satu produk dari tiap transaksi
    final remainingProductCount = transaction.details.length -
        1; // menghitung jumlah produk dalam tiap transaksi
    final formatCurrency = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2); // format harga

    return GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (_) =>
      //           TransactionDetailPage(transactionId: transaction.id),
      //     ),
      //   );
      // },

      // mengarahkan user ke halaman detail transaksi berdasarkan id transaksi yang di tap
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                TransactionDetailPage(transactionId: transaction.id),
          ),
        );

        // Panggil callback untuk refresh jika ada
        onRefresh?.call();
      },

      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kode Transaksi & Tanggal
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       transaction.transactionCode ?? '-',
              //       style: const TextStyle(
              //           fontWeight: FontWeight.bold, fontSize: 16),
              //     ),
              //     Text(
              //       DateFormat('dd MMM yyyy, HH:mm')
              //           .format(transaction.transactionDate),
              //       style: TextStyle(color: Colors.grey[600], fontSize: 12),
              //       overflow: TextOverflow.ellipsis,
              //       maxLines: 1,
              //     ),
              //   ],
              // ),

              // menampilkan data transaksi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    // kode transaksi
                    child: Text(
                      transaction.transactionCode ?? '-',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // waktu transaksi
                  Text(
                    DateFormat('dd MMM yyyy, HH:mm')
                        .format(transaction.transactionDate),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // widget status transaksi
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color:
                      getStatusColor(transaction.status ?? 'Dalam pengemasan'),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  transaction.status ?? 'Dalam pengemasan',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),

              // menampilkan produk
              if (firstProduct != null) ...[
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "$responseUrl/public/storage/${firstProduct.product!.imageUrl}",
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          // errorBuilder: (context, error, stackTrace) {
                          //   return const Icon(Icons.broken_image);
                          // },

                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            'assets/images/product.png',
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        )
                        //     Image(
                        //   // borderRadius: BorderRadius.circular(8),
                        //   image: firstProduct.photo!.isNotEmpty
                        //       ? NetworkImage(
                        //           "$responseUrl/storage/${firstProduct.photo}")
                        //       : const AssetImage('assets/images/product.png')
                        //           as ImageProvider,
                        //   width: 60,
                        //   height: 60,
                        //   fit: BoxFit.cover,
                        // ),
                        ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // nama salah satu produk yang terdapat pada transaksi terkait
                          Text(firstProduct.name ?? 'Unknown',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          // menampilkan tanggal kadaluarsa dari produk terkait
                          Text('Exp : ${firstProduct.expDate}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          // menampilkan teks jumlah produk yang ada pada transaksi terkait
                          Text(
                            remainingProductCount > 0
                                ? 'Klik untuk lihat +$remainingProductCount produk lainnya'
                                : '',
                            style: const TextStyle(color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // metode pengiriman dan pembayaran
              Row(
                children: [
                  const Icon(Icons.local_shipping,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  // metode pengiriman dari transaksi terkait
                  Text(transaction.shippingMethod ?? 'Tidak ada',
                      style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 16),
                  const Icon(Icons.payment, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  // metode pembayaran dari transaksi terkait
                  Text(transaction.paymentMethod ?? 'Cash',
                      style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 12),

              // total biaya dari transaksi terkait
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Total: ${formatCurrency.format(transaction.totalPayment)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // mengatur warna UI pada bagian status transaksi
  Color getStatusColor(String status) {
    switch (status) {
      case 'Pembayaran lunas':
      case 'Pesanan sampai':
      case 'Pesanan selesai dikemas':
        return Colors.blue;
      case 'Pesanan selesai':
      case 'Pembatalan berhasil':
        return Colors.green;
      case 'Belum bayar':
      case 'Dalam perjalanan':
      case 'Dalam pengemasan':
      case 'Proses pembatalan':
        return Colors.orange;
      case 'Pembayaran gagal':
      case 'Dibatalkan':
      case 'Pengiriman gagal':
        return Colors.red;
      default:
        return Colors.black87;
    }
  }
}
