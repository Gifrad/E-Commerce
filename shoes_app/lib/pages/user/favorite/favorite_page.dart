import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/pages/widgets/favorite_card.dart';
import 'package:shoes_app/providers/favorite_provider.dart';

import '../../../providers/page_provider.dart';
import '../../../theme.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    Widget header() {
      return AppBar(
        backgroundColor: backgroundColor3,
        centerTitle: true,
        title: const Text('Favorite'),
        elevation: 0,
        automaticallyImplyLeading: false,
      );
    }

    Widget emptyFavorite() {
      return Expanded(
        child: Container(
          width: double.infinity,
          color: backgroundColor1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image_favorite.png',
                width: 74,
              ),
              const SizedBox(
                height: 23,
              ),
              Text(
                'Kamu belum memiliki sepatu Favorit?',
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Segera cari sepatu favoritmu',
                style: secondaryTextStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 44,
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 24,
                      ),
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                  onPressed: () {
                    pageProvider.currentIndex = 0;
                  },
                  child: Text(
                    'Jelajahi Produk',
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
      );
    }

    Widget content() {
      return Expanded(
        child: Container(
          color: backgroundColor1,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            children: favoriteProvider.favorite
                .map((product) => FavoriteCard(
                      product: product,
                    ))
                .toList(),
          ),
        ),
      );
    }

    return Column(
      children: [
        header(),
        favoriteProvider.favorite.isEmpty ? emptyFavorite() : content(),
      ],
    );
  }
}
