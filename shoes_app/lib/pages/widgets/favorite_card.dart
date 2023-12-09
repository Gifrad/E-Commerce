import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/models/product/product_model.dart';
import 'package:shoes_app/providers/favorite_provider.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

import '../user/product/product_page.dart';

class FavoriteCard extends StatelessWidget {
  final ProductModel? product;
  const FavoriteCard({this.product, super.key});

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(product: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding:
            const EdgeInsets.only(top: 10, bottom: 12, right: 20, left: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: backgroundColor4),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: product!.galleries!.isEmpty
                  ? Image.network(
                      'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      '${product?.galleries?[0].url}',
                      width: 60,
                    ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${product?.name}',
                    style: primaryTextStyle.copyWith(
                      fontWeight: semiBold,
                    ),
                  ),
                  Text(
                    // '\$${product?.price}'
                    CurrencyFormat().parseNumberCurrencyWithRp(product!.price!),
                    style: priceTextStyle,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                favoriteProvider.setProduct(product!);
              },
              child: Image.asset(
                'assets/button_wishlist_blue.png',
                width: 34,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
