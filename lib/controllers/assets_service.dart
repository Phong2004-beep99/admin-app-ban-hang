import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Uint8List> loadImage(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Lỗi tải ảnh');
  }
}

class ImageLoader extends StatelessWidget {
  final String imageUrl;

  ImageLoader({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: loadImage(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Icon(Icons.error);
        } else {
          return Image.memory(snapshot.data!, fit: BoxFit.cover);
        }
      },
    );
  }
}
