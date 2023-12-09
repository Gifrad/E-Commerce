import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/providers/category_provider.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/get_token.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  late TextEditingController _nameCategoryController;
  @override
  void initState() {
    _nameCategoryController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: bgColorAdmin1,
        title: const Text("Add Category"),
        centerTitle: true,
      );
    }

    Widget body() {
      return Container(
        margin: EdgeInsets.only(
          left: defaultMargin,
          right: defaultMargin,
          top: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Category',
              style: blackTextStyle.copyWith(
                fontSize: 20,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _nameCategoryController,
              cursorColor: blackColor,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.post_add_rounded,
                  color: primaryColor,
                  size: 30,
                ),
                hintText: 'Add Category',
                hintStyle: secondaryTextStyle,
                focusColor: blackColor,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: blackColor,
                    )),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: blackColor),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                  onPressed: () async {
                    if (_nameCategoryController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: alertColor,
                          content: const Text(
                            'Text Can\'t Empty',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      final token = await GetToken.getToken();
                      final result = await categoryProvider.addCategory(
                          token!, _nameCategoryController.text);
                      if (result == true) {
                        if (mounted) {}
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: secondaryColor,
                            content: const Text(
                              'Success Add Category',
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
                              'Failed Add Category',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    'SAVE',
                    style: primaryTextStyle.copyWith(
                      fontWeight: semiBold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColorAdmin3,
      appBar: header(),
      body: body(),
    );
  }
}
