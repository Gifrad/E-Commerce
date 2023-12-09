import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/models/product/product_model.dart';
import 'package:shoes_app/pages/admin/gallery/add_gallery_page.dart';
import 'package:shoes_app/providers/gallery_provider.dart';
import 'package:shoes_app/providers/product_provider.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/get_token.dart';

class GalleryAdminPage extends StatefulWidget {
  final ProductModel product;
  const GalleryAdminPage({required this.product, super.key});

  @override
  State<GalleryAdminPage> createState() => _GalleryAdminPageState();
}

class _GalleryAdminPageState extends State<GalleryAdminPage> {
  @override
  Widget build(BuildContext context) {
    GalleryProvider galleryProvider =
        Provider.of<GalleryProvider>(context, listen: false);

    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    PreferredSizeWidget header() {
      return AppBar(
        title: const Text('Product Gallery'),
        backgroundColor: bgColorAdmin1,
        centerTitle: true,
      );
    }

    Widget body() {
      return widget.product.galleries!.isNotEmpty
          ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: widget.product.galleries!.length,
              itemBuilder: (context, index) {
                final data = widget.product.galleries!.elementAt(index);
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(2, 2),
                          )
                        ],
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(data.url!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              backgroundColor: primaryTextColor,
                              content:
                                  const Text('Are you sure delete this photo?'),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: secondaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final token = await GetToken.getToken();
                                        final result = await galleryProvider
                                            .delete(data.id!, token!);
                                        if (result) {
                                          await productProvider.reloadProduct();
                                          if (mounted) {}
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              backgroundColor: secondaryColor,
                                              content: const Text(
                                                'Success Delete Photo',
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
                                        } else {
                                          if (mounted) {}
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              backgroundColor: alertColor,
                                              content: const Text(
                                                'Failed Delete Photo',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: alertColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No'),
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.delete,
                            color: alertColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          : Center(
              child: Text(
                'Not Found',
                style: blackTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
            );
    }

    return Scaffold(
      backgroundColor: bgColorAdmin3,
      appBar: header(),
      body: body(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Add Photo'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddGallerypage(productId: widget.product.id!),
            ),
          );
        },
      ),
    );
  }
}
