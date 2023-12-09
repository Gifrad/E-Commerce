import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/models/category/category_model.dart';
import 'package:shoes_app/pages/admin/category/edit_category_page.dart';
import 'package:shoes_app/providers/category_provider.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/get_token.dart';

class CategoryCard extends StatefulWidget {
  final CategoryModel? categories;
  const CategoryCard({this.categories, super.key});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    void handleDelete() async {
      final token = await GetToken.getToken();
      final result =
          await categoryProvider.deleteCategory(token!, widget.categories!.id!);
      if (result) {
        if (mounted) {}
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: secondaryColor,
            content: const Text(
              'Success Delete Category',
              textAlign: TextAlign.center,
            ),
          ),
        );
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   '/home-admin',
        //   (route) => false,
        // );
        Navigator.pop(context);
      } else {
        if (mounted) {}
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: alertColor,
            content: const Text(
              'Failed Delete Category',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }

    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: bgColorAdmin2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Id : ${widget.categories!.id}',
                style: primaryTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
              Text(
                'Name : ${widget.categories!.name}',
                style: primaryTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCategoryPage(
                        name: widget.categories!.name!,
                        id: widget.categories!.id!,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 55,
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: primaryTextColor)),
                  child: Center(
                      child: Text(
                    'EDIT',
                    style: primaryTextStyle,
                  )),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: bgColorAdmin1,
                      content: SizedBox(
                        width: 50,
                        height: 115,
                        child: Column(
                          children: [
                            Text(
                              "Are you sure to delete this data?",
                              style: primaryTextStyle,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: secondaryColor),
                                  onPressed: handleDelete,
                                  child: Text(
                                    'Yes',
                                    style: primaryTextStyle,
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: alertColor,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'No',
                                    style: primaryTextStyle,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 55,
                  decoration: BoxDecoration(
                    color: alertColor,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: primaryTextColor),
                  ),
                  child: Center(
                      child: Text(
                    'DELETE',
                    style: primaryTextStyle,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
