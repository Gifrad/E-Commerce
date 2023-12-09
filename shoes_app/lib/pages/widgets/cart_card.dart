import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/models/cart/cart_model.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

import '../../providers/cart_provider.dart';

class CartCard extends StatelessWidget {
  final CartModel? cart;
  const CartCard({this.cart, super.key});

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Container(
      margin: EdgeInsets.only(top: defaultMargin),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor4,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: cart!.product!.galleries!.isEmpty
                        ? const NetworkImage(
                            'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                          )
                        : NetworkImage('${cart?.product?.galleries?[0].url}'),
                  ),
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
                      '${cart?.product?.name}',
                      style: primaryTextStyle.copyWith(
                        fontWeight: semiBold,
                      ),
                    ),
                    Text(
                      // '\$${cart?.product?.price}'
                      CurrencyFormat().parseNumberCurrencyWithRp(cart!.product!.price!),
                      style: priceTextStyle,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      cartProvider.addQuantity(cart!.id!);
                    },
                    child: Image.asset(
                      'assets/button_add.png',
                      width: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    cart!.quantity.toString(),
                    style: primaryTextStyle.copyWith(
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      cartProvider.reduceQuantity(cart!.id!);
                    },
                    child: Image.asset(
                      'assets/button_min.png',
                      width: 16,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              cartProvider.removeProduct(cart!.id!);
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/icon_delete.png',
                  width: 10,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  'Remove',
                  style: alertTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: light,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
