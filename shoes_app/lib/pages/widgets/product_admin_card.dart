import 'package:flutter/material.dart';
import 'package:shoes_app/models/product/product_model.dart';
import 'package:shoes_app/pages/admin/product/product_detail_admin_page.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

class ProductAdminCard extends StatelessWidget {
  final ProductModel? product;
  const ProductAdminCard({this.product,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              product!.galleries!.isEmpty
                  ? Image.network(
                      'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                      width: 90,
                      height: 90,
                    )
                  : Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.fill,
                        image:
                            NetworkImage(product!.galleries![0].url.toString()),
                      )),
                    ),
              const SizedBox(
                width: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.47,
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 4,
                  right: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${product!.category!.name}',
                      style: blackTextStyle.copyWith(
                        fontSize: 10,
                        fontWeight: reguler,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${product!.name}',
                      style: blackTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: semiBold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      // '\$${product!.price}'
                      CurrencyFormat()
                          .parseNumberCurrencyWithRp(product!.price!),
                      style: priceTextStyle,
                    )
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailAdminPage(
                      product: product,
                    ),
                  ),
                );
              },
              child: Text(
                'Lihat Detail',
                style: secondaryColorStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
