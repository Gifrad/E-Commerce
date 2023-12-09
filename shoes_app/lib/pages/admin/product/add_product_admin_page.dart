import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/providers/product_provider.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/get_token.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

class AddProductAdminPage extends StatefulWidget {
  const AddProductAdminPage({super.key});

  @override
  State<AddProductAdminPage> createState() => _AddProductAdminPageState();
}

class _AddProductAdminPageState extends State<AddProductAdminPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameProductController;
  late TextEditingController _priceProductController;
  late TextEditingController _descriptionProductController;
  String dropdownValue = '';

  @override
  void initState() {
    _nameProductController = TextEditingController();
    _priceProductController = TextEditingController();
    _descriptionProductController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameProductController.dispose();
    _priceProductController.dispose();
    _descriptionProductController.dispose();
    super.dispose();
  }

  late int categoriesId;

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of(context, listen: false);

    void handleSave() async {
      if (dropdownValue == 'Sepatu') {
        categoriesId = 1;
      } else if (dropdownValue == 'Sendal') {
        categoriesId = 2;
      } else if (dropdownValue == 'Jaket') {
        categoriesId = 3;
      } else if (dropdownValue == 'Tas') {
        categoriesId = 4;
      } 

      final token = await GetToken.getToken();
      if (_formKey.currentState!.validate()) {
        if (dropdownValue == '') {
          if (mounted) {}
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: alertColor,
              content: const Text(
                'Please Select Category',
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          final result = await productProvider.addProduct(
            token!,
            _nameProductController.text,
            _descriptionProductController.text,
            int.parse(CurrencyFormat()
                .replaceFormatCurrency(_priceProductController.text)),
            categoriesId,
          );
          if (result == true) {
            if (mounted) {}
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: secondaryColor,
                content: const Text(
                  'Success Add Product',
                  textAlign: TextAlign.center,
                ),
              ),
            );
            // Navigator.pushNamedAndRemoveUntil(
            //     context, '/home-admin', (route) => false);
            // Navigator.pushNamedAndRemoveUntil(
            //     context, '/product-admin', (route) => false);
            // Navigator.pop(context);
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
                  'Failed Add Product',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        }
      }
    }

    PreferredSizeWidget header() {
      return AppBar(
        title: const Text('Add product'),
        centerTitle: true,
        backgroundColor: bgColorAdmin1,
      );
    }

    Widget body() {
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: defaultMargin,
          ),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NOTE : DROPDOWNBUTTON
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    decoration: BoxDecoration(color: bgColorAdmin2),
                    child: DropdownButton(
                      dropdownColor: bgColorAdmin2,
                      isExpanded: true,
                      items: <String>[
                        'Sepatu',
                        'Sendal',
                        'Jaket',
                        'Tas',
                        // 'Running'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          alignment: AlignmentDirectional.centerStart,
                          value: value,
                          child: Text(
                            value,
                            style: primaryTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: semiBold,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          if (kDebugMode) {
                            print(dropdownValue);
                          }
                        });
                      },
                      hint: dropdownValue == ''
                          ? Text(
                              'Select Category',
                              style: primaryTextStyle.copyWith(
                                  fontSize: 14, fontWeight: semiBold),
                            )
                          : Text(
                              dropdownValue,
                              style: primaryTextStyle.copyWith(
                                  fontSize: 14, fontWeight: semiBold),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  /// NOTE : TEXTFIELD NAME
                  Text(
                    'Product Name',
                    style: blackTextStyle.copyWith(
                      fontWeight: semiBold,
                    ),
                  ),
                  Card(
                    elevation: 6,
                    color: bgColorAdmin3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 6),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Can\'t not empty';
                          }
                          return null;
                        },
                        controller: _nameProductController,
                        cursorColor: blackColor,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'write product name',
                            hintStyle: secondaryTextStyle),
                      ),
                    ),
                  ),

                  /// NOTE : TEXTFIELD PRICE
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Product Price',
                    style: blackTextStyle.copyWith(
                      fontWeight: semiBold,
                    ),
                  ),
                  Card(
                    elevation: 6,
                    color: bgColorAdmin3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 6),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Can\'t not empty';
                          }
                          return null;
                        },
                        controller: _priceProductController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyFormat()
                        ],
                        keyboardType: TextInputType.number,
                        cursorColor: blackColor,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'write product price',
                          hintStyle: secondaryTextStyle,
                        ),
                      ),
                    ),
                  ),

                  /// NOTE : TEXTFIELD DESCTIPTION
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Product Description',
                    style: blackTextStyle.copyWith(
                      fontWeight: semiBold,
                    ),
                  ),
                  Card(
                    elevation: 6,
                    color: bgColorAdmin3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Can\'t not empty';
                          }
                          return null;
                        },
                        controller: _descriptionProductController,
                        maxLines: 5,
                        cursorColor: blackColor,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'write product description',
                          hintStyle: secondaryTextStyle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: handleSave,
                        child: Text(
                          'SAVE',
                          style: primaryTextStyle,
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

    return Scaffold(
      backgroundColor: bgColorAdmin3,
      appBar: header(),
      body: body(),
    );
  }
}
