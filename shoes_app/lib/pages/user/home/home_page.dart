import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/models/auth/user_model.dart';
import 'package:shoes_app/pages/user/home/search_all_product_page.dart';
import 'package:shoes_app/pages/widgets/product_card.dart';
import 'package:shoes_app/pages/widgets/product_tile.dart';
import 'package:shoes_app/providers/product_provider.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/url.dart';

import '../../../providers/auth_provider.dart';
import '../product/all_products_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;

    Widget header() {
      return Container(
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
                    'Hallo, ${user.name}',
                    style: primaryTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: semiBold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user.email!,
                    style: primaryTextStyle.copyWith(fontSize: 16),
                  )
                ],
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/edit-profile');
                },
                child: user.photo == basePhotoProfile
                    ? const CircleAvatar(
                        maxRadius: 27,
                        backgroundImage: AssetImage('assets/image_profile.png'),
                      )
                    : CircleAvatar(
                        maxRadius: 27,
                        backgroundImage: NetworkImage('${user.photo}'),
                      )),
          ],
        ),
      );
    }

    Widget searchText() {
      return Container(
        margin:
            EdgeInsets.only(top: 16, left: defaultMargin, right: defaultMargin),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchAllProductPage(),
              ),
            );
          },
          child: Row(
            children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Cari Produk...',
                      style: secondaryTextStyle,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Icon(
                  Icons.search,
                  color: primaryColor,
                  size: 32,
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget categories() {
      List<String> items = [
        'Semua',
        'Sepatu',
        'Sendal',
        'Jaket',
        '  Tas  ',
        // 'Running',
      ];

      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        Visibility(
                          visible: index == 0,
                          child: const SizedBox(
                            width: 30,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              currentIndex = index;
                            });
                            if (currentIndex != 0) {
                              await productProvider
                                  .getProductsByCategoryId(currentIndex);
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: currentIndex == index
                                  ? primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: currentIndex == index
                                  ? Border.all(color: primaryColor, width: 2)
                                  : Border.all(color: primaryTextColor),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Text(
                                  items[index],
                                  style: currentIndex == index
                                      ? primaryTextStyle.copyWith(
                                          fontSize: 13,
                                          fontWeight: medium,
                                        )
                                      : secondaryTextStyle.copyWith(
                                          fontSize: 13,
                                          fontWeight: medium,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: index == 5,
                          child: const SizedBox(
                            width: 30,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    Widget popularProductTitle() {
      return Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            currentIndex == 0
                ? Text(
                    'Semua Produk',
                    style: primaryTextStyle.copyWith(
                      fontSize: 22,
                      fontWeight: semiBold,
                    ),
                  )
                : currentIndex == 1
                    ? Text(
                        'Sepatu',
                        style: primaryTextStyle.copyWith(
                          fontSize: 22,
                          fontWeight: semiBold,
                        ),
                      )
                    : currentIndex == 2
                        ? Text(
                            'Sendal',
                            style: primaryTextStyle.copyWith(
                              fontSize: 22,
                              fontWeight: semiBold,
                            ),
                          )
                        : currentIndex == 3
                            ? Text(
                                'Jaket',
                                style: primaryTextStyle.copyWith(
                                  fontSize: 22,
                                  fontWeight: semiBold,
                                ),
                              )
                            : currentIndex == 4
                                ? Text(
                                    'Tas',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 22,
                                      fontWeight: semiBold,
                                    ),
                                  )
                                :
                                // currentIndex == 5
                                //     ? Text(
                                //         'Running',
                                //         style: primaryTextStyle.copyWith(
                                //           fontSize: 22,
                                //           fontWeight: semiBold,
                                //         ),
                                //       )
                                Text(
                                    'All Shoes',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 22,
                                      fontWeight: semiBold,
                                    ),
                                  ),
            productProvider.products.isEmpty &&
                    productProvider.productsSepatu.isEmpty &&
                    productProvider.productSendal.isEmpty &&
                    productProvider.productsJaket.isEmpty &&
                    productProvider.productsTas.isEmpty
                // &&
                // productProvider.productsRunning.isEmpty
                ? const SizedBox.shrink()
                : InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllProductsPage(
                              currentIndex: currentIndex,
                            ),
                          ));
                    },
                    child: Text(
                      'Lihat Semua',
                      textAlign: TextAlign.center,
                      style: priceTextStyle.copyWith(fontWeight: light),
                    ),
                  ),
          ],
        ),
      );
    }

    Widget popularProducts() {
      List<dynamic> items = [
        {'dummy': 'dummy'}
      ];
      return Container(
        margin: const EdgeInsets.only(
          top: 14,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: defaultMargin,
              ),
              Row(
                  children: currentIndex == 0
                      ? productProvider.products.isEmpty
                          ? items
                              .map((e) => Container(
                                    width: 215,
                                    height: 278,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: NetworkImage(
                                          'https://nadurra.ae/wp-content/themes/nadurra/images/no-product.png',
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList()
                          : productProvider.products
                              .map((product) => ProductCard(product: product))
                              .toList()
                      : currentIndex == 1
                          ? productProvider.productsSepatu.isEmpty
                              ? items
                                  .map((e) => Container(
                                        width: 215,
                                        height: 278,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: NetworkImage(
                                              'https://nadurra.ae/wp-content/themes/nadurra/images/no-product.png',
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList()
                              : productProvider.productsSepatu
                                  .map((product) =>
                                      ProductCard(product: product))
                                  .toList()
                          : currentIndex == 2
                              ? productProvider.productSendal.isEmpty
                                  ? items
                                      .map((e) => Container(
                                            width: 215,
                                            height: 278,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.contain,
                                                image: NetworkImage(
                                                  'https://nadurra.ae/wp-content/themes/nadurra/images/no-product.png',
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList()
                                  : productProvider.productSendal
                                      .map((product) =>
                                          ProductCard(product: product))
                                      .toList()
                              : currentIndex == 3
                                  ? productProvider.productsJaket.isEmpty
                                      ? items
                                          .map((e) => Container(
                                                width: 215,
                                                height: 278,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.contain,
                                                    image: NetworkImage(
                                                      'https://nadurra.ae/wp-content/themes/nadurra/images/no-product.png',
                                                    ),
                                                  ),
                                                ),
                                              ))
                                          .toList()
                                      : productProvider.productsJaket
                                          .map((product) =>
                                              ProductCard(product: product))
                                          .toList()
                                  :
                                  // currentIndex == 4?
                                  productProvider.productsTas.isEmpty
                                      ? items
                                          .map((e) => Container(
                                                width: 215,
                                                height: 278,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.contain,
                                                    image: NetworkImage(
                                                      'https://nadurra.ae/wp-content/themes/nadurra/images/no-product.png',
                                                    ),
                                                  ),
                                                ),
                                              ))
                                          .toList()
                                      : productProvider.productsTas
                                          .map((product) =>
                                              ProductCard(product: product))
                                          .toList()),
              // :
              // productProvider.productsRunning.isEmpty
              //     ? items
              //         .map((e) => Container(
              //               width: 215,
              //               height: 278,
              //               decoration:
              //                   const BoxDecoration(
              //                 image: DecorationImage(
              //                   fit: BoxFit.contain,
              //                   image: NetworkImage(
              //                     'https://nadurra.ae/wp-content/themes/nadurra/images/no-product.png',
              //                   ),
              //                 ),
              //               ),
              //             ))
              //         .toList()
              //     : productProvider.productsRunning
              //         .map((product) =>
              //             ProductCard(product: product))
              //         .toList())
            ],
          ),
        ),
      );
    }

    Widget newArrivalsTitle() {
      return Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Text(
          'Produk Terbaru',
          style: primaryTextStyle.copyWith(
            fontSize: 22,
            fontWeight: semiBold,
          ),
        ),
      );
    }

    Widget newArrivals() {
      List<dynamic> item = [
        {"dum": 'dum'}
      ];
      return Container(
        margin: const EdgeInsets.only(top: 14),
        child: Column(
          children: productProvider.productsLimit.isEmpty
              ? item
                  .map((e) => Container(
                        margin: EdgeInsets.only(bottom: defaultMargin),
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage(
                              'https://nadurra.ae/wp-content/themes/nadurra/images/no-product.png',
                            ),
                          ),
                        ),
                      ))
                  .toList()
              : productProvider.productsLimit
                  .map((product) => ProductTile(product: product))
                  .toList(),
        ),
      );
    }

    return ListView(
      children: [
        header(),
        searchText(),
        categories(),
        popularProductTitle(),
        popularProducts(),
        newArrivalsTitle(),
        newArrivals(),
      ],
    );
  }
}
