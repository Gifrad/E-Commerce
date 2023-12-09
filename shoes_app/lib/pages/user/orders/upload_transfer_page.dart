import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/models/transaction/transaction_model.dart';
import 'package:shoes_app/providers/transaction_provider.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/url.dart';

import '../../../utils/get_token.dart';

class UploadTransferPage extends StatefulWidget {
  final TransactionModel transaction;
  final int transactionId;
  const UploadTransferPage(
      {required this.transaction, required this.transactionId, super.key});

  @override
  State<UploadTransferPage> createState() => _UploadTransferPageState();
}

class _UploadTransferPageState extends State<UploadTransferPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      imageQuality: 50,
      source: ImageSource.gallery,
    );

    setState(() {
      _imageFile = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    PreferredSizeWidget header() {
      return AppBar(
        elevation: 0,
        backgroundColor: backgroundColor3,
        centerTitle: true,
        title: const Text('Konfirmasi Pembayaran'),
      );
    }

    Widget body() {
      return SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terima Kasih',
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Silahkan melakukan pembayaran pada salah satu nomer rekening dibawah ini.',
                style: primaryTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: light,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'BNI',
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: bold,
                ),
              ),
              Text(
                '9358395839 a/n Admin Sparrow 1',
                style: primaryTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'BRI',
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: bold,
                ),
              ),
              Text(
                '8439473948 a/n Admin Sparrow 2',
                style: primaryTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'BCA',
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: bold,
                ),
              ),
              Text(
                '9358395344 a/n Admin Sparrow 3',
                style: primaryTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              widget.transaction.transfer != baseTransfer
                  ? const Text(
                      'SUDAH TRANSFER',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: pickImage,
                          child: const Text('Pick'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_imageFile == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: alertColor,
                                  content: const Text(
                                    'Photo is Empty',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            } else {
                              final token = await GetToken.getToken();
                              final result =
                                  await transactionProvider.uploadTransfer(
                                      widget.transactionId,
                                      _imageFile!,
                                      token!);
                              if (result) {
                                // await productProvider.reloadProduct();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: secondaryColor,
                                      content: const Text(
                                        'Success Upload Transfer',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                  // Navigator.pushNamedAndRemoveUntil(
                                  //   context,
                                  //   '/home-admin',
                                  //   (route) => false,
                                  // );
                                }
                              } else {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: alertColor,
                                      content: const Text(
                                        'Failed Upload Transfer',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: const Text('Upload'),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 16,
              ),
              widget.transaction.transfer == baseTransfer
                  ? Container(
                      decoration: BoxDecoration(
                        color: bgColorAdmin2,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: _imageFile != null
                          ? Image.file(
                              _imageFile!,
                              fit: BoxFit.fill,
                            )
                          : const SizedBox.shrink(),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: body(),
    );
  }
}
