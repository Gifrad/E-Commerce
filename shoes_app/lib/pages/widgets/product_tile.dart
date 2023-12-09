import 'package:flutter/material.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

import '../../models/product/product_model.dart';
import '../user/product/product_page.dart';

class ProductTile extends StatelessWidget {
  final ProductModel? product;
  const ProductTile({this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(
              product: product,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
            left: defaultMargin, right: defaultMargin, bottom: defaultMargin),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: product!.galleries!.isEmpty
                  ? Image.network(
                      'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      '${product?.galleries?[0].url}',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
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
                    '${product?.category?.name}',
                    style: secondaryTextStyle.copyWith(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    '${product?.name}',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    // '\$${product?.price}'
                    CurrencyFormat().parseNumberCurrencyWithRp(product!.price!),
                    style: priceTextStyle.copyWith(fontWeight: medium),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
