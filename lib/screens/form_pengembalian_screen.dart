// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sisfo_sarpras_mobile/screens/main_screen.dart';
import 'package:sisfo_sarpras_mobile/services/api_services.dart';

class FormPengembalianScreen extends StatefulWidget {
  final int idDetailPeminjaman;
  final int idPeminjaman;
  final int idBarang;
  final int jumlah;

  const FormPengembalianScreen({
    super.key,
    required this.idDetailPeminjaman,
    required this.idPeminjaman,
    required this.idBarang,
    required this.jumlah,
  });

  @override
  State<FormPengembalianScreen> createState() => _FormPengembalianScreenState();
}

class _FormPengembalianScreenState extends State<FormPengembalianScreen> {
  final _formKey = GlobalKey<FormState>();

  final kondisiController = TextEditingController();
  final keteranganController = TextEditingController();

  File? _selectedImageFile; // For Android/iOS
  Uint8List? _selectedImageBytes; // For Web

 Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageFile = null;
        });
      } else {
        setState(() {
          _selectedImageFile = File(pickedFile.path);
          _selectedImageBytes = null;
        });
      }
    }
  }

  Widget _buildImagePreview() {
    if (kIsWeb && _selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else if (_selectedImageFile != null) {
      return Image.file(
        _selectedImageFile!,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else {
      return Text("Belum ada gambar yang dipilih.");
    }
  }

  Future<void> handlePengembalian() async {
    final kondisi = kondisiController.text.trim();
    final keterangan = keteranganController.text.trim();
    final jumlah = widget.jumlah;
    final idPeminjaman = widget.idPeminjaman;
    final idBarang = widget.idBarang;
    final idDetailPeminjaman = widget.idDetailPeminjaman;
    String? itemImagePath;
    if (!kIsWeb) {
      itemImagePath = _selectedImageFile?.path;
    }
    // print("DEBUG - Path Gambar: $itemImagePath");
    // print("DEBUG - Image Bytes: ${_selectedImageBytes?.length}");
    final ApiServices api = ApiServices();

    try {
      // Jika kamu ingin mengirim gambar di web, modifikasi bagian ini agar pakai bytes/base64
      final result = await api.storePengembalian(
        idDetailPeminjaman,
        idPeminjaman,
        idBarang,
        jumlah,
        kondisi,
        keterangan,
        itemImagePath,
      );

      const message = 'Pengembalian Berhasil!';

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(message)));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } catch (e) {
      print("Failed fetch data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Form Pengembalian ${widget.idBarang}, ${widget.idDetailPeminjaman}, ${widget.idPeminjaman}, ${widget.jumlah}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: kondisiController,
                decoration: InputDecoration(
                  labelText: "Kondisi (Opsional)",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: keteranganController,
                decoration: InputDecoration(
                  labelText: "Keterangan (Opsional)",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              Text("Item Image (Opsional)",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildImagePreview(),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.photo),
                label: Text("Pilih Gambar dari Galeri"),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: handlePengembalian,
                child: Text('Kirim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
