import 'package:flutter/material.dart';
import 'package:shoes_app/models/product/product_model.dart';
import 'package:shoes_app/models/product/uninitialized_product_model.dart';
import 'package:shoes_app/theme.dart';


class ChatBubbleAdmin extends StatelessWidget {
  final String text;
  final bool isSender;
  final ProductModel? product;
  const ChatBubbleAdmin({
    this.text = '',
    this.isSender = false,
    this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // CartProvider cartProvider = Provider.of<CartProvider>(context);
    Widget productReview() {
      return Container(
        width: 230,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 0 : 12),
            topRight: Radius.circular(isSender ? 12 : 0),
            bottomLeft: const Radius.circular(12),
            bottomRight: const Radius.circular(12),
          ),
          color: isSender ? bgColorAdmin2 : backgroundColor5,
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
                        style: blackTextStyle,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '\$${product?.price}',
                        style: primaryTextStyle.copyWith(fontWeight: medium),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            // Row(
            //   children: [
            //     OutlinedButton(
            //       style: OutlinedButton.styleFrom(
            //           side: BorderSide(
            //             color: primaryColor,
            //           ),
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(8))),
            //       onPressed: () {
            //         cartProvider.addCart(product!);
            //         Navigator.pushNamed(context, '/cart');
            //       },
            //       child: Text(
            //         'Add to Cart',
            //         style: purpleTextStyle,
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 8,
            //     ),
            //     TextButton(
            //       style: TextButton.styleFrom(
            //         backgroundColor: primaryColor,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //       ),
            //       onPressed: () {
            //         cartProvider.addCart(product!);
            //         Navigator.pushNamed(context, '/cart');
            //       },
            //       child: Text(
            //         'Buy Now',
            //         style: GoogleFonts.poppins(
            //           color: backgroundColor5,
            //           fontWeight: medium,
            //         ),
            //       ),
            //     )
            //   ],
            // )
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
            isSender ?  CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          product is UninitializedProductModel
              ? const SizedBox.shrink()
              : productReview(),
          Row(
            mainAxisAlignment:
                isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
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
                      topLeft: Radius.circular(isSender ? 0 : 12),
                      topRight: Radius.circular(isSender ? 12 : 0),
                      bottomLeft: const Radius.circular(12),
                      bottomRight: const Radius.circular(12),
                    ),
                    color: isSender ? bgColorAdmin2 : bgColorAdmin1
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
