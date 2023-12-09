import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/pages/widgets/product_admin_card.dart';
import 'package:shoes_app/providers/product_provider.dart';
import 'package:shoes_app/theme.dart';


class ProductAdminPage extends StatelessWidget {
  const ProductAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);

    PreferredSizeWidget header() {
      return AppBar(
        title: const Text('Product'),
        centerTitle: true,
        backgroundColor: bgColorAdmin1,
      );
    }

    Widget body() {
      return Consumer<ProductProvider>(
        builder: (context, value, child) => Container(
            margin: EdgeInsets.only(
              left: defaultMargin,
              right: defaultMargin,
              top: 16,
              bottom: 16,
            ),
            child: ListView.builder(
              // reverse: true,
              itemCount: value.products.length,
              itemBuilder: (context, index) {
                final product = value.products.elementAt(index);
                return Card(
                  elevation: 8,
                  color: bgColorAdmin3,
                  child: ProductAdminCard(
                    product: product,
                  ),
                );
              },
            ),

            // Column(
            //   children: productProvider.products
            //       .map(
            //         (product) => Card(
            //           color: bgColorAdmin3,
            //           elevation: 8,
            //           child: ProductAdminCard(
            //             product: product,
            //           ),
            //         ),
            //       )
            //       .toList(),
            // ),
            ),
      );
    }

    return Scaffold(
      backgroundColor: bgColorAdmin3,
      appBar: header(),
      body: productProvider.products.isEmpty
          ? Center(
              child: Text(
                'Not Found...',
                style: blackTextStyle.copyWith(
                  fontSize: 22,
                  fontWeight: bold,
                ),
              ),
            )
          : body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-product-admin');
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, size: 48),
      ),
    );
  }
}
