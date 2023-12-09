import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/models/product/product_model.dart';
import 'package:shoes_app/models/product/uninitialized_product_model.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

import '../../providers/cart_provider.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final ProductModel? product;
  const ChatBubble({
    this.text = '',
    this.isSender = false,
    this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    Widget productReview() {
      return Container(
        width: 230,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: primaryTextColor),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 12 : 0),
            topRight: Radius.circular(isSender ? 0 : 12),
            bottomLeft: const Radius.circular(12),
            bottomRight: const Radius.circular(12),
          ),
          color: isSender ? backgroundColor3 : backgroundColor4,
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: product!.galleries!.isEmpty
                      ? Image.network(
                          'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          '${product?.galleries?[0].url}',
                          width: 70,
                        ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${product?.name}',
                        style: primaryTextStyle,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        // '\$${product?.price}'
                        CurrencyFormat()
                            .parseNumberCurrencyWithRp(product!.price!),
                        style: priceTextStyle.copyWith(fontWeight: medium),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: primaryTextColor,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    cartProvider.addCart(product!);
                    Navigator.pushNamed(context, '/cart');
                  },
                  child: Text(
                    'Add to Cart',
                    style: primaryTextStyle,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    cartProvider.addCart(product!);
                    Navigator.pushNamed(context, '/cart');
                  },
                  child: Text(
                    'Buy Now',
                    style: primaryTextStyle.copyWith(fontWeight: medium)
                  ),
                )
              ],
            )
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        top: defaultMargin,
      ),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          product is UninitializedProductModel
              ? const SizedBox.shrink()
              : productReview(),
          Row(
            mainAxisAlignment:
                isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isSender ? 12 : 0),
                      topRight: Radius.circular(isSender ? 0 : 12),
                      bottomLeft: const Radius.circular(12),
                      bottomRight: const Radius.circular(12),
                    ),
                    color: isSender ? backgroundColor3 : backgroundColor4,
                  ),
                  child: Text(
                    text,
                    style: primaryTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
