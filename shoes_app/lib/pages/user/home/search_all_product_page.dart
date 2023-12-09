import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/pages/widgets/product_tile.dart';
import 'package:shoes_app/providers/product_provider.dart';
import 'package:shoes_app/theme.dart';

class SearchAllProductPage extends StatelessWidget {
  const SearchAllProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: backgroundColor3,
        title: const Text('Cari Produk'),
        centerTitle: true,
        elevation: 0,
      );
    }

    Widget body() {
      return Consumer<ProductProvider>(
        builder: (context, value, child) => Column(
          children: [
            Container(
              margin:
                  EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 8),
              child: TextField(
                onChanged: (text) async {
                  value
                      .implSquentialSearch(searchController.text.toLowerCase());
                },
                controller: searchController,
                style: primaryTextStyle,
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: secondaryTextStyle,
                  prefixIcon: Icon(
                    Icons.search,
                    color: primaryColor,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    borderSide: BorderSide(width: 3, color: Colors.white),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    borderSide: BorderSide(width: 3, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            value.products.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        'Not Found...',
                        style: primaryTextStyle.copyWith(
                            fontSize: 22, fontWeight: semiBold),
                      ),
                    ),
                  )
                : value.squentialSearchAllProduct.isEmpty
                    ? Expanded(
                      child: Center(
                          child: Text(
                            'Not Found...',
                            style: primaryTextStyle.copyWith(
                              fontSize: 22,
                              fontWeight: bold,
                            ),
                          ),
                        ),
                    )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: value.squentialSearchAllProduct.length,
                          itemBuilder: (context, index) {
                            final product = value.squentialSearchAllProduct
                                .elementAt(index);
                            return ProductTile(
                              product: product,
                            );
                          },
                        ),
                      )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: body(),
    );
  }
}
