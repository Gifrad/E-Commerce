import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/models/product/product_model.dart';
import 'package:shoes_app/pages/admin/gallery/gallery_admin_page.dart';
import 'package:shoes_app/pages/admin/product/edit_product_admin_page.dart';
import 'package:shoes_app/providers/product_provider.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/get_token.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

class ProductDetailAdminPage extends StatefulWidget {
  final ProductModel? product;
  const ProductDetailAdminPage({this.product, super.key});

  @override
  State<ProductDetailAdminPage> createState() => _ProductDetailAdminPageState();
}

class _ProductDetailAdminPageState extends State<ProductDetailAdminPage> {
  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    PreferredSizeWidget header() {
      return AppBar(
        title: const Text('Product Detail'),
        centerTitle: true,
        backgroundColor: bgColorAdmin1,
      );
    }

    Widget body() {
      final dateTime = Timestamp.fromDate(widget.product!.createdAt!).toDate();
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: defaultMargin,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              maxLines: 2,
              '${widget.product!.name}',
              style: blackTextStyle.copyWith(
                fontSize: 20,
                fontWeight: semiBold,
              ),
            ),
            Text(
              maxLines: 2,
              '${widget.product!.category!.name}',
              style: blackTextStyle.copyWith(
                fontSize: 12,
                fontWeight: reguler,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 80,
              child: Card(
                color: bgColorAdmin3,
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Harga',
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semiBold,
                        ),
                      ),
                      Text(
                        // '\$${widget.product!.price}'
                        CurrencyFormat()
                            .parseNumberCurrencyWithRp(widget.product!.price!),
                        style: priceTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semiBold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Description',
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 8,
                color: bgColorAdmin3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${widget.product!.description}',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: light,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  Text(
                    DateFormat.yMMMMd().format(dateTime),
                  ),
                  Text(
                    DateFormat.Hms().format(dateTime),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Photo Gallery',
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GalleryAdminPage(
                        product: widget.product!,
                      ),
                    ),
                  );
                },
                child: Text(
                  'See Gallery',
                  style: primaryTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget footer() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColorAdmin3,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProductAdminPage(product: widget.product!),
                    ),
                  );
                },
                child: Text(
                  'EDIT',
                  style: primaryTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: alertColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (widget.product!.galleries!.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title:
                              const Text('Please Delete Photo in Gallery!!!'),
                          content: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("OK", style: alertTextStyle.copyWith()),
                          ),
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          backgroundColor: primaryTextColor,
                          content:
                              const Text('Are you sure delete this product?'),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: secondaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final token = await GetToken.getToken();
                                    final result =
                                        await productProvider.deleteProduct(
                                            token!, widget.product!.id!);
                                    if (result) {
                                      if (mounted) {}
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: secondaryColor,
                                          content: Text(
                                            'Success Delete Product ${widget.product!.name!}',
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
                                            'Failed Delete Product',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
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
                                      borderRadius: BorderRadius.circular(12),
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
                  }
                },
                child: Text(
                  'DELETE',
                  style: primaryTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColorAdmin3,
      appBar: header(),
      body: body(),
      bottomSheet: footer(),
    );
  }
}
