import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/url.dart';

class GalleryService {
  String baseUrl = base;

  Future<bool> delete(int id, String token) async {
    Uri url = Uri.parse('$baseUrl/galleries/$id');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.delete(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Success Delete: ${response.body}');
      }
      return true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed Delete Gallery');
    }
  }

  Future<bool> addGallery(int productId, File image, String token) async {
    Uri url = Uri.parse('$baseUrl/galleries');
    final header = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    final request = http.MultipartRequest('POST', url);

    request.fields['products_id'] = productId.toString();
    request.headers.addAll(header);

    final multipartFile = await http.MultipartFile.fromPath('url', image.path);

    request.files.add(multipartFile);

    final response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      if (kDebugMode) {
        print(res.body);
      }
      return true;
    } else {
      throw Exception('Failed Add Photo');
    }

  }
}
