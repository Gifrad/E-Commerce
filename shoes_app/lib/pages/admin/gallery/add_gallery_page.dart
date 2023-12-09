import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/providers/gallery_provider.dart';
import 'package:shoes_app/providers/product_provider.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/get_token.dart';

class AddGallerypage extends StatefulWidget {
  final int productId;
  const AddGallerypage({required this.productId, super.key});

  @override
  State<AddGallerypage> createState() => _AddGallerypageState();
}

class _AddGallerypageState extends State<AddGallerypage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      imageQuality: 50,
      source: ImageSource.gallery,
    );

    setState(() {
      _imageFile = File(image!.path);
    });
  }

  Future<void> cameraImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );

    setState(() {
      _imageFile = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    GalleryProvider galleryProvider =
        Provider.of<GalleryProvider>(context, listen: false);
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    PreferredSizeWidget header() {
      return AppBar(
        title: const Text('Add Photo'),
        centerTitle: true,
        backgroundColor: bgColorAdmin1,
        actions: [
          InkWell(
            onTap: () async {
              if (_imageFile == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: alertColor,
                    content: const Text(
                      'Photo is Empty',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                final token = await GetToken.getToken();
                final result = await galleryProvider.addGallery(
                    widget.productId, _imageFile!, token!);
                if (result) {
                  await productProvider.reloadProduct();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: secondaryColor,
                        content: const Text(
                          'Success Add Photo',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                    // Navigator.pushNamedAndRemoveUntil(
                    //   context,
                    //   '/home-admin',
                    //   (route) => false,
                    // );
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: alertColor,
                        content: const Text(
                          'Failed Add Photo',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                }
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text('Save')),
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: header(),
      backgroundColor: bgColorAdmin3,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: defaultMargin, vertical: defaultMargin),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: bgColorAdmin2,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          fit: BoxFit.fill,
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: bgColorAdmin3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: cameraImage,
              child: const Text('Camera'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: pickImage,
              child: const Text('Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
