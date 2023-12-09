import 'package:flutter/material.dart';
import 'package:shoes_app/models/product/product_model.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

import '../user/product/product_page.dart';

class ProductCard extends StatelessWidget {
  final ProductModel? product;
  const ProductCard({this.product, super.key});

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
        width: 215,
        height: 278,
        margin: EdgeInsets.only(
          right: defaultMargin,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xffECEDEF),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            product!.galleries!.isEmpty
                ? Image.network(
                    'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                    width: 215,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    '${product?.galleries![0].url}',
                    width: 215,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
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
                    style: blackTextStyle.copyWith(
                        fontSize: 18, fontWeight: semiBold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    // '\$${product?.price}'
                    CurrencyFormat().parseNumberCurrencyWithRp(product!.price!),
                    style: priceTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: medium,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
