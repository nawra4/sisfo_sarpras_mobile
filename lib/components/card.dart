import 'package:flutter/material.dart';
import 'package:sisfo_sarpras_mobile/screens/form_peminjaman_screen.dart';

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String status;
  final String btnText;
  final int id;
  final void Function(BuildContext context, int id)? onButtonPressed;
  final bool showButton; // <-- NEW

  const ProductCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.status,
    required this.btnText,
    required this.id,
    this.onButtonPressed,
    this.showButton = true, // <-- NEW, default true
  }) : super(key: key);

  final baseurl = "http://192.168.56.1:8000";

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'dipinjam':
      case 'tersedia':
        return Colors.green;
      case 'pending':
        return Colors.yellow;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: (imagePath == null || imagePath.isEmpty)
                    ? Image.asset(
                        "no_photo.jpg",
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        "$baseurl/storage/gambar_barang/$imagePath",
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/no_photo.png",
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite, color: Colors.red, size: 16),
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Status indicator
                        Container(
                          width: 10,
                          height: 10,
                          margin: EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: getStatusColor(status),
                          ),
                        ),
                        Text(
                          status,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    if (showButton) // <-- Only show if true
                      ElevatedButton(
                        onPressed: () {
                          if (onButtonPressed != null) {
                            onButtonPressed!(context, id);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FormPeminjamanScreen(id: id),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: Text(btnText),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
