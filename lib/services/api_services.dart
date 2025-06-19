import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  //seting base url (localhost/127.0.0.1 ganti ke -> ipaddres local computer)
  // jadi format nya seperti ini http://ipadressLocal:8000/api
  final baseUrl = "http://127.0.0.1:8000/api";

  Future<dynamic> Login(String username, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$baseUrl/login');
    var response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: {"username": username, "password": password});
    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      await prefs.setString('token', json['access_token']);
      await prefs.setInt('id', json['user']['users_id']);
      return json;
    } else {
      String errorMessage = json['message'];
      print(response.statusCode);
      throw Exception(errorMessage);
    }
  }

  Future<List<Map<String, dynamic>>> getAllBarang() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('$baseUrl/barang');
    var response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": 'Bearer $token'},
    );

    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> items =
          List<Map<String, dynamic>>.from(json);
      return items;
    } else {
      String errorMessage = json['message'];
      print(response.statusCode);
      throw Exception(errorMessage);
    }
  }

  Future<dynamic> storePeminjaman(
    int idBarang,
    int jumlah,
    String keperluan,
    String kelas,
    String tanggalPinjam,
    String tanggalKembali,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final uri = Uri.parse("$baseUrl/peminjaman");
    var response = await http.post(uri, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    }, body: {
      'id_barang': idBarang.toString(),
      'jumlah': jumlah.toString(),
      'keperluan': keperluan,
      'class': kelas,
      'tanggal_pinjam': tanggalPinjam,
      'tanggal_kembali': tanggalKembali,
    });

    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 201) {
      return json;
    } else {
      String errorMessage = json['message'];
      print(response.statusCode);
      throw Exception(errorMessage);
    }
  }

  Future<List<Map<String, dynamic>>> getAllPeminjaman(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final uri = Uri.parse("$baseUrl/peminjaman/$id/users");
    var response = await http.get(
      uri,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> items =
          List<Map<String, dynamic>>.from(json);
      return items;
    } else {
      String errorMessage = json['message'];
      print(response.statusCode);
      throw Exception(errorMessage);
    }
  }

  Future<dynamic> storePengembalian(
      int idDetailPeminjaman,
      int idPeminjaman,
      int idBarang,
      int jumlah,
      String kondisi,
      String keterangan,
      String? item_image) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final uri = Uri.parse("$baseUrl/detail-pengembalian");
    var response = await http.post(uri, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'id_detail_peminjaman': idDetailPeminjaman.toString(),
      'id_peminjaman': idPeminjaman.toString(),
      'id_barang': idBarang.toString(),
      'jumlah': jumlah.toString(),
      'kondisi': kondisi,
      'keterangan': keterangan,
      'item_image': item_image ?? '',
    });
  }

  Future<List<Map<String, dynamic>>> getAllPengembalian(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final uri = Uri.parse("$baseUrl/detail-pengembalian/$id/users");
    var response = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> items =
          List<Map<String, dynamic>>.from(json);
      return items;
    } else {
      String errorMessage = json['message'];
      print(response.statusCode);
      throw Exception(errorMessage);
    }
  }
}
