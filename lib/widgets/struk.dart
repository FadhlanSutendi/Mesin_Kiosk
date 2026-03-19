import 'package:flutter/material.dart';

class StrukWidget extends StatelessWidget {
  final String rumahSakit;
  final String nama;
  final String poli;
  final String nomorAntrian;

  const StrukWidget({
    super.key,
    required this.rumahSakit,
    required this.nama,
    required this.poli,
    required this.nomorAntrian,
  });

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 44,
          child: Text(label),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 260, // ukuran cocok untuk thermal printer
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Nama Rumah Sakit
            Text(
              rumahSakit,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Divider(thickness: 1),

            const SizedBox(height: 10),

            /// Data Pasien
            _buildInfoRow("Nama", nama),

            const SizedBox(height: 6),

            _buildInfoRow("Poli", poli),

            const SizedBox(height: 14),

            const Divider(thickness: 1),

            const SizedBox(height: 10),

            /// Nomor Antrian
            const Text(
              "Nomor Antrian",
              style: TextStyle(
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              nomorAntrian,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),

            const SizedBox(height: 14),

            const Divider(thickness: 1),

            const SizedBox(height: 8),

            const Text(
              "Silahkan menunggu panggilan",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
