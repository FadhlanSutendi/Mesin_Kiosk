import 'package:flutter/material.dart';
import 'bpjs/daftar_bpjs.dart';
import 'spesialis/daftar_spesialis.dart';
import 'umum/daftar_umum.dart';

class DaftarMenu extends StatelessWidget {
  Widget _buildHorizontalCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Color> gradientColors,
    required Widget page,
    required double width,
  }) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => page));
          },
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Holder yang lebih besar dan mewah
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                  ),
                  child: Icon(icon, color: Colors.white, size: 50),
                ),
                const SizedBox(height: 25),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "Daftar Sekarang",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF00155E);
    const Color accentBlue = Color(0xFF2448C3);
    const Color accentPink = Color(0xFF006DD4);
    const double paddingSize = 30.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text("Menu Pendaftaran", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        backgroundColor: darkBlue,
        elevation: 0,
        centerTitle: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Menghitung lebar kartu agar pas dengan layar
          // Jika layar lebar (tablet/desktop), kita bagi 3. Jika sempit, kita buat bisa scroll.
          double spacing = 20.0;
          double cardWidth = (constraints.maxWidth - (paddingSize * 2) - (spacing * 2)) / 3;
          
          // Pastikan kartu tidak terlalu kecil (min 200)
          if (cardWidth < 200) cardWidth = 250; 

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(paddingSize, 10, paddingSize, 50),
                  decoration: const BoxDecoration(
                    color: darkBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pilih Kategori", 
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text("Silahkan pilih jenis layanan pendaftaran anda", 
                        style: TextStyle(color: Colors.white54, fontSize: 16)),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Menu Horizontal Area
                SizedBox(
                  height: 350, // Tinggi area kartu diperbesar
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildHorizontalCard(
                        context: context,
                        title: "Umum",
                        icon: Icons.person_pin_rounded,
                        gradientColors: [const Color(0xFF1E3C72), const Color(0xFF2A5298)],
                        page: DaftarUmum(),
                        width: cardWidth,
                      ),
                      _buildHorizontalCard(
                        context: context,
                        title: "BPJS",
                        icon: Icons.security_rounded,
                        gradientColors: [accentBlue, const Color(0xFF2448C3)],
                        page: DaftarBPJS(),
                        width: cardWidth,
                      ),
                      _buildHorizontalCard(
                        context: context,
                        title: "Spesialis",
                        icon: Icons.biotech_rounded,
                        gradientColors: [accentPink, const Color(0xFF2966F4)],
                        page: DaftarSpesialis(),
                        width: cardWidth,
                      ),
                    ],
                  ),
                ),

              Padding(
  padding: const EdgeInsets.all(paddingSize),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        "Informasi Layanan",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: darkBlue,
        ),
      ),
      IconButton(
        icon: const Icon(Icons.arrow_forward_ios, size: 16, color: darkBlue),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  width: 320, // mengatur supaya popup tidak terlalu lebar
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Informasi Layanan",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Menyediakan layanan medis, penunjang medis, IGD, rawat inap, administrasi, layanan khusus, serta informasi jam operasional untuk membantu pasien mendapatkan pelayanan kesehatan.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Tutup",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    ],
  ),
)
              ],
            ),
          );
        },
      ),
    );
  }
}