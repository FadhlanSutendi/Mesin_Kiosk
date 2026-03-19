import 'package:flutter/material.dart';
import 'umum_belum_terdaftar.dart';
import 'umum_terdaftar.dart';

class DaftarUmum extends StatelessWidget {
  const DaftarUmum({super.key});

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          /// HEADER DENGAN TOMBOL BACK
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, topInset + 10, 24, 34),
            decoration: const BoxDecoration(
              color: Color(0xff0b2a6f),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white),
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  "Menu Pendaftaran",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Pilih Kategori",
                  style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Silahkan pilih jenis layanan pendaftaran anda",
                  style: TextStyle(color: Colors.white70, fontSize: 17),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          /// CARD MENU
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildCard(
                    context,
                    "Terdaftar",
                    Icons.person,
                    const LinearGradient(
                      colors: [Color(0xff1d76e2), Color.fromARGB(255, 17, 10, 158)],
                    ),
                    UmumTerdaftar(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildCard(
                    context,
                    "Belum\nTerdaftar",
                    Icons.person_add,
                    const LinearGradient(
                      colors: [Color.fromARGB(255, 34, 13, 225), Color.fromARGB(255, 66, 2, 139)],
                    ),
                    UmumBelumTerdaftar(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    IconData icon,
    Gradient gradient,
    Widget page,
  ) {
    return InkWell(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        height: 190, // Sedikit ditambah agar tulisan 2 baris muat
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Pilih",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
