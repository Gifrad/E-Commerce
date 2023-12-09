import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shoes_app/services/gallery_service.dart';

class GalleryProvider extends ChangeNotifier {
  GalleryService galleryService = GalleryService();

  Future<bool> delete(int id, String token) async {
    try {
      final result = await galleryService.delete(id, token);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> addGallery(int productId, File image, String token) async {
    try {
      final result = await galleryService.addGallery(productId, image, token);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}
