import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/pages/widgets/product_grid_card.dart';

import '../../../providers/product_provider.dart';
import '../../../theme.dart';

class AllProductsPage extends StatefulWidget {
  final int? currentIndex;
  const AllProductsPage({this.currentIndex, super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: backgroundColor3,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.currentIndex == 0
              ? 'Semua'
              : widget.currentIndex == 1
                  ? 'Sepatu'
                  : widget.currentIndex == 2
                      ? 'Sendal'
                      : widget.currentIndex == 3
                          ? 'Jaket'
                          :
                          // widget.currentIndex == 4?
                          'Tas',
          // : 'Running',
          style: primaryTextStyle.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
      );
    }

    Widget content() {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: GridView.count(
          childAspectRatio: (215 / 290),
          crossAxisCount: 2,
          children: widget.currentIndex == 0
              ? productProvider.products
                  .map((product) => ProductGirdCard(product: product))
                  .toList()
              : widget.currentIndex == 1
                  ? productProvider.productsSepatu
                      .map((product) => ProductGirdCard(product: product))
                      .toList()
                  : widget.currentIndex == 2
                      ? productProvider.productSendal
                          .map((product) => ProductGirdCard(product: product))
                          .toList()
                      : widget.currentIndex == 3
                          ? productProvider.productsJaket
                              .map((product) =>
                                  ProductGirdCard(product: product))
                              .toList()
                          :
                          // widget.currentIndex == 4?
                          productProvider.productsTas
                              .map((product) =>
                                  ProductGirdCard(product: product))
                              .toList(),
          // : productProvider.productsRunning
          //     .map((product) =>
          //         ProductGirdCard(product: product))
          //     .toList(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: content(),
    );
  }
}
