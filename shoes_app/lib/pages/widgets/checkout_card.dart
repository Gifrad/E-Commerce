import 'package:flutter/material.dart';
import 'package:shoes_app/models/cart/cart_model.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

class CheckoutCard extends StatelessWidget {
  final CartModel? cart;
  const CheckoutCard({this.cart, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: backgroundColor4,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: cart!.product!.galleries!.isEmpty
                    ? const NetworkImage(
                        'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png')
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
                      fontSize: 14,
                      fontWeight: semiBold,
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  // '\$${cart?.product?.price}'
                  CurrencyFormat()
                      .parseNumberCurrencyWithRp(cart!.product!.price!),
                  style: priceTextStyle,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            '${cart?.quantity} items',
            style: secondaryTextStyle.copyWith(
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
