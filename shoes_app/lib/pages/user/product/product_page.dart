import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/providers/cart_provider.dart';
import 'package:shoes_app/providers/favorite_provider.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

import '../../../models/product/product_model.dart';
import '../chat/detail_chat_page.dart';

class ProductPage extends StatefulWidget {
  final ProductModel? product;
  const ProductPage({this.product, super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // List image = [
  //   'assets/image_shoes.png',
  //   'assets/image_shoes.png',
  //   'assets/image_shoes.png',
  // ];

  // List familiarShoes = [
  //   'assets/image_shoes.png',
  //   'assets/image_shoes2.png',
  //   'assets/image_shoes3.png',
  //   'assets/image_shoes4.png',
  //   'assets/image_shoes5.png',
  //   'assets/image_shoes6.png',
  //   'assets/image_shoes7.png',
  //   'assets/image_shoes8.png',
  // ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    Future<void> showSuccessDialog() async {
      return showDialog(
        context: context,
        builder: (BuildContext context) => SizedBox(
          width: MediaQuery.of(context).size.width - (2 * defaultMargin),
          child: AlertDialog(
            backgroundColor: backgroundColor3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/icon_success.png',
                    width: 100,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Hurray :)',
                    style: primaryTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Produk berhasil ditambahkan',
                    style: secondaryTextStyle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 154,
                    height: 44,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Lihat Keranjangku',
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: medium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget indicator(int index) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: currentIndex == index ? 16 : 4,
        height: 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: currentIndex == index ? primaryColor : const Color(0xffC4C4C4),
        ),
      );
    }

    // Widget familiarShoesCard(String imageUrl) {
    //   return Container(
    //     width: 54,
    //     height: 54,
    //     margin: const EdgeInsets.only(right: 16),
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //         image: AssetImage(imageUrl),
    //       ),
    //       borderRadius: BorderRadius.circular(6),
    //     ),
    //   );
    // }

    Widget header() {
      // ignore: unused_local_variable
      late String link;
      final imgPlaceHolder = {
        link =
            'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
      };

      int index = -1;

      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 20,
              left: defaultMargin,
              right: defaultMargin,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.chevron_left),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                  child: Icon(
                    Icons.shopping_cart_rounded,
                    color: blackColor,
                  ),
                )
              ],
            ),
          ),
          CarouselSlider(
            items: widget.product!.galleries!.isEmpty
                ? imgPlaceHolder
                    .map(
                      (data) => Image.network(
                        imgPlaceHolder.first,
                        width: MediaQuery.of(context).size.width * 0.60,
                        height: 350,
                        fit: BoxFit.cover,
                      ),
                    )
                    .toList()
                : widget.product?.galleries!
                    .map(
                      (image) => Image.network(
                        image.url!,
                        width: MediaQuery.of(context).size.width * 0.60,
                        height: 350,
                        fit: BoxFit.cover,
                      ),
                    )
                    .toList(),
            options: CarouselOptions(
              initialPage: 0,
              onPageChanged: ((index, reason) {
                setState(() {
                  currentIndex = index;
                });
              }),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.product!.galleries!.isEmpty
                ? imgPlaceHolder.map((data) => indicator(index)).toList()
                : widget.product!.galleries!.map((e) {
                    index++;
                    return indicator(index);
                  }).toList(),
          )
        ],
      );
    }

    Widget content() {
      // int index = -1;
      return Container(
        margin: const EdgeInsets.only(top: 17),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          color: backgroundColor1,
        ),
        child: Column(children: [
          // NOTE : Header
          Container(
            margin: EdgeInsets.only(
              top: defaultMargin,
              left: defaultMargin,
              right: defaultMargin,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.product?.name}',
                        style: primaryTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                        ),
                      ),
                      Text(
                        '${widget.product?.category?.name}',
                        style: secondaryTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    favoriteProvider.setProduct(widget.product!);
                    if (favoriteProvider.isFavorite(widget.product!)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: secondaryColor,
                          content: const Text(
                            'Has been added to the Favorite',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: alertColor,
                          content: const Text(
                            'Has been removed from the Favorite',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
                  child: Image.asset(
                    favoriteProvider.isFavorite(widget.product!)
                        ? 'assets/button_wishlist_blue.png'
                        : 'assets/button_wishlist.png',
                    width: 46,
                  ),
                ),
              ],
            ),
          ),
          // NOTE : PRICE
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            margin: EdgeInsets.only(
              top: 20,
              left: defaultMargin,
              right: defaultMargin,
            ),
            decoration: BoxDecoration(
              color: backgroundColor3,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Harga Mulai Dari',
                  style: primaryTextStyle,
                ),
                Text(
                  // '\$${widget.product?.price}'
                  CurrencyFormat()
                      .parseNumberCurrencyWithRp(widget.product!.price!),
                  style: priceTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                )
              ],
            ),
          ),
          // NOTE:DESCRIPTION
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              top: defaultMargin,
              left: defaultMargin,
              right: defaultMargin,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: primaryTextStyle.copyWith(
                    fontWeight: bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  '${widget.product?.description}',
                  style: secondaryTextStyle.copyWith(
                    fontWeight: light,
                  ),
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          ),
          //NOTE : FAMILIAR SHOES
          // Container(
          //   width: double.infinity,
          //   margin: EdgeInsets.only(top: defaultMargin),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Padding(
          //         padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          //         child: Text(
          //           'Familiar Shoes',
          //           style: primaryTextStyle.copyWith(
          //             fontWeight: medium,
          //           ),
          //         ),
          //       ),
          //       const SizedBox(
          //         height: 12,
          //       ),
          //       SingleChildScrollView(
          //         scrollDirection: Axis.horizontal,
          //         child: Row(
          //           children: familiarShoes.map((image) {
          //             index++;
          //             return Container(
          //               margin: EdgeInsets.only(
          //                 left: index == 0 ? defaultMargin : 0,
          //               ),
          //               child: familiarShoesCard(image),
          //             );
          //           }).toList(),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          //NOTE : BUTTONS
          const SizedBox(
            height: 125,
          ),
          Container(
            // height: 200,
            width: double.infinity,
            margin: EdgeInsets.only(
                top: defaultMargin,
                left: defaultMargin,
                right: defaultMargin,
                bottom: 20),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailChatPage(
                          product: widget.product,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/button_chat.png'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      onPressed: () {
                        cartProvider.addCart(widget.product!);
                        showSuccessDialog();
                      },
                      child: Text(
                        'Add to Cart',
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor6,
      body: ListView(
        children: [
          header(),
          content(),
        ],
      ),
    );
  }
}
