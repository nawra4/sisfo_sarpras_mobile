import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisfo_sarpras_mobile/components/card.dart';
import 'package:sisfo_sarpras_mobile/screens/login_screen.dart';
import 'package:sisfo_sarpras_mobile/services/api_services.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  List<Map<String, dynamic>> items = [];

  Future<void> getAllBarang() async {
    try{
      final fetchBarang = await ApiServices().getAllBarang();
      setState(() {
        items = fetchBarang;
      });
    }catch(e){
      print("Failed fetch data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    getAllBarang();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: items.isEmpty ? Center(
      child: LoadingAnimationWidget.discreteCircle(
        color: Colors.blueAccent,
        size: 50,
      ),
    ) : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Barang di sapras",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text("SMK TARUNA BHAKTI", style: 
                    TextStyle(
                      color: Colors.blueAccent
                    ),),
                  ],
                ),
                Spacer(),
                IconButton(icon: Icon(Icons.logout),color: Colors.blueAccent, onPressed: logout),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 30),

            // ✅ Dinamis pakai ListView.builder
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ProductCard(
                  id: item['id_barang'],
                  imagePath: item['gambar_barang'],
                  title: item['nama_barang'],
                  description: item['brand'],
                  status: item['status'],
                  btnText: "Pinjam",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
