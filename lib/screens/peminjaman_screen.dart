import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sisfo_sarpras_mobile/components/card.dart';
import 'package:sisfo_sarpras_mobile/screens/form_pengembalian_screen.dart';
import 'package:sisfo_sarpras_mobile/services/api_services.dart';

class PeminjamanScreen extends StatefulWidget {
  final int id;
  const PeminjamanScreen({super.key, required this.id});

  @override
  State<PeminjamanScreen> createState() => _PeminjamanScreenState();
}

class _PeminjamanScreenState extends State<PeminjamanScreen> {
  List<Map<String, dynamic>> items = [];

  Future<void> getAllpeminjamUsers() async {
    final idUser = widget.id;
    try {
      final fetchBarang = await ApiServices().getAllPeminjaman(idUser);
      setState(() {
        items = fetchBarang;
      });
    } catch (e) {
      print("Failed fetch data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  void initState() {
    super.initState();
    getAllpeminjamUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items.isEmpty
          ? Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: Colors.blueAccent,
                size: 50,
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text("${widget.id}"),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final idDetailPeminjaman =
                          item['id_detail_peminjaman']['id_detail_peminjaman'];
                      final idBarang = item['id_detail_peminjaman']['id_barang']
                          ['id_barang'];
                      final jumlah = item['id_detail_peminjaman']['jumlah'];
                      final status =
                          item['status']?.toString().toLowerCase() ?? '';
                      final showButton = status == 'dipinjam';

                      return ProductCard(
                        id: item['id_peminjaman'],
                        imagePath: item['id_detail_peminjaman']['id_barang']
                            ['gambar_barang'],
                        title: item['id_detail_peminjaman']['id_barang']
                            ['nama_barang'],
                        description: item['id_detail_peminjaman']['keperluan'],
                        status: item['status'],
                        btnText: "Balikin",
                        showButton:
                            showButton, // Hanya tampil jika status approve
                        onButtonPressed: (context, id) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FormPengembalianScreen(
                                idBarang: idBarang,
                                idDetailPeminjaman: idDetailPeminjaman,
                                idPeminjaman: id,
                                jumlah: jumlah,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
