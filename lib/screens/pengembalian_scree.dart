import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sisfo_sarpras_mobile/components/card.dart';
import 'package:sisfo_sarpras_mobile/services/api_services.dart';

class PengembalianScree extends StatefulWidget {
  final int id;
  const PengembalianScree({super.key, required this.id});

  @override
  State<PengembalianScree> createState() => _PengembalianScreeState();
}

class _PengembalianScreeState extends State<PengembalianScree> {
  List<Map<String, dynamic>> items = [];

  Future<void> getAllPengembalian() async {
    final idUser = widget.id;
    try {
      final fetchBarang = await ApiServices().getAllPengembalian(idUser);
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
    getAllPengembalian();
  }

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
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ProductCard(
                        id: item['id_detail_pengembalian'],
                        imagePath: item['id_detail_peminjaman']['id_barang']
                            ['gambar_barang'],
                        title: item['id_detail_peminjaman']['id_barang']
                            ['nama_barang'],
                        description: item['id_detail_peminjaman']['keperluan'],
                        status: item['status'],
                        btnText: "Detail",
                        showButton: false,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
