import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/pages/widgets/category_card.dart';
import 'package:shoes_app/providers/category_provider.dart';
import 'package:shoes_app/theme.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    PreferredSizeWidget header() {
      return AppBar(
        title: const Text('Category'),
        backgroundColor: bgColorAdmin1,
        centerTitle: true,
      );
    }

    Widget body() {
      return Consumer<CategoryProvider>(
        builder: (context, value, child) => Container(
          margin: EdgeInsets.only(
            left: defaultMargin,
            right: defaultMargin,
            top: 16,
          ),
          child: ListView.builder(
            itemCount:value.categories.length ,
            itemBuilder: (context, index) {
              final category = value.categories.elementAt(index);
              return CategoryCard(categories: category,);
            },
          ),
          // Column(
          //   children: categoryProvider.categories
          //       .map(
          //         (data) => CategoryCard(
          //           categories: data,
          //         ),
          //       )
          //       .toList(),
          // ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColorAdmin3,
      appBar: header(),
      body: categoryProvider.categories.isEmpty
          ? Center(
              child: Text(
                'Not Found...',
                style: blackTextStyle.copyWith(
                  fontSize: 22,
                  fontWeight: bold,
                ),
              ),
            )
          : body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-category');
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, size: 48),
      ),
    );
  }
}
