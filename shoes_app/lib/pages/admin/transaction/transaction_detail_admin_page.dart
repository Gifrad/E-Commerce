import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/models/transaction/transaction_model.dart';
import 'package:shoes_app/pages/admin/transaction/picture_transfer_page.dart';
import 'package:shoes_app/pages/widgets/transaction_item_admin.dart';
import 'package:shoes_app/providers/transaction_provider.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/get_token.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shoes_app/utils/url.dart';

class TransactionDetailAdminPage extends StatefulWidget {
  final TransactionModel? transaction;
  const TransactionDetailAdminPage({this.transaction, super.key});

  @override
  State<TransactionDetailAdminPage> createState() =>
      _TransactionDetailAdminPageState();
}

class _TransactionDetailAdminPageState
    extends State<TransactionDetailAdminPage> {
  String dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    final userDate =
        Timestamp.fromDate(widget.transaction!.user!.createdAt!).toDate();
    TransactionProvider transactionProvider =
        Provider.of(context, listen: false);

    void invoice() async {
      List<String> headers = [
        'Produk',
        'Harga',
        'Quantity',
        'Total Harga',
      ];

      final data = widget.transaction!.items!.map((item) {
        final totalHarga = item.quantity! * item.product!.price!;
        return [
          item.product!.name,
          CurrencyFormat().parseNumberCurrencyWithOutRp(item.product!.price!),
          item.quantity,
          CurrencyFormat().parseNumberCurrencyWithOutRp(totalHarga),
        ];
      }).toList();

      final dateTime =
          Timestamp.fromDate(widget.transaction!.createdAt!).toDate();

      var dataImage = await rootBundle.load("assets/image_splash.png");
      var myImage = dataImage.buffer.asUint8List();
      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    children: [
                      pw.Container(
                        width: 50,
                        height: 50,
                        decoration: pw.BoxDecoration(
                          borderRadius: pw.BorderRadius.circular(12),
                          image: pw.DecorationImage(
                            image: pw.MemoryImage(myImage),
                          ),
                        ),
                      ),
                      pw.Text('Sparrow Leather\nWorks Jakarta',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center),
                      pw.SizedBox(height: 4),
                    ],
                  ),
                  pw.SizedBox(height: 22),
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        fontSize: 32,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 40),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Alamat Perusahaan',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                              'Jl Tebet Barat Gg.Trijaya II No.5\nRT.5/RW.7, Kec. Tebet\nKota Jakarta Selatan,12810'),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Text('Nomor Invoice: ',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Text('${widget.transaction!.id}-'
                                  '${DateFormat.yMd().format(dateTime)}')
                            ],
                          ),
                          pw.SizedBox(height: 20),
                          pw.Row(
                            children: [
                              pw.Text('Tanggal Invoice: ',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Text(
                                DateFormat.yMMMd().format(DateTime.now()),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 30),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Tujuan Tagihan',
                        style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Row(
                        children: [
                          pw.Text(
                            'Nama: ',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(widget.transaction!.user!.name!),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text(
                            'Alamat: ',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(widget.transaction!.address!),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text(
                            'Nomor Telepon: ',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(widget.transaction!.user!.phone!),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Table.fromTextArray(
                    headers: headers,
                    data: data,
                    border: const pw.TableBorder(
                        bottom: pw.BorderSide(),
                        left: pw.BorderSide(),
                        right: pw.BorderSide(),
                        top: pw.BorderSide()),
                    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    headerDecoration:
                        pw.BoxDecoration(color: PdfColor.fromHex('#999')),
                    cellHeight: 30,
                    cellAlignments: {
                      0: pw.Alignment.center,
                      1: pw.Alignment.center,
                      2: pw.Alignment.center,
                      3: pw.Alignment.center,
                    },
                  ),
                  pw.SizedBox(height: 6),
                  pw.Row(
                    children: [
                      pw.Text(
                        'Jumlah Pembayaran',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Spacer(),
                      pw.Text(
                          CurrencyFormat().parseNumberCurrencyWithOutRp(
                              widget.transaction!.totalPrice!),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(
                        width: 35,
                      ),
                    ],
                  ),
                  pw.Divider(),
                  pw.SizedBox(height: 100),
                  pw.Align(
                    alignment: pw.Alignment.bottomCenter,
                    child: pw.Text(
                      'TERIMAKASIH ATAS PEMEBELIAN ANDA',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ];
          },
        ),
      );
      Uint8List bytes = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${widget.transaction!.user!.name!}'
          '${widget.transaction!.id!}'
          '.pdf');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    }

    void handleSave() async {
      if (dropdownValue == '') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: alertColor,
            content: const Text(
              'Please Select Status',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        final token = await GetToken.getToken();
        final result = await transactionProvider.updateTransaction(
          token!,
          dropdownValue,
          widget.transaction!.id!,
        );

        if (result) {
          if (mounted) {}
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: secondaryColor,
              content: const Text(
                'Success Change Status',
                textAlign: TextAlign.center,
              ),
            ),
          );
          Navigator.pop(context);
        } else {
          if (mounted) {}
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: alertColor,
              content: const Text(
                'Failed Change Status',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      }
    }

    PreferredSizeWidget header() {
      return AppBar(
        title: const Text('Transaction Detail'),
        centerTitle: true,
        backgroundColor: bgColorAdmin1,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: bgColorAdmin3,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  context: context,
                  builder: (context) => Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: defaultMargin, vertical: 16),
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detail Customer',
                          style: blackTextStyle.copyWith(
                            fontWeight: semiBold,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text('id : ${widget.transaction!.user!.id}'),
                        const SizedBox(
                          height: 4,
                        ),
                        Text('Name : ${widget.transaction!.user!.name}'),
                        const SizedBox(
                          height: 4,
                        ),
                        Text('Email : ${widget.transaction!.user!.email}'),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                            'Username : ${widget.transaction!.user!.username}'),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                            'Mendaftar : ${DateFormat.yMMMMd().format(userDate)}'),
                        const SizedBox(
                          height: 4,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text('Phone : ${widget.transaction!.user!.phone}'),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.person,
                color: primaryTextColor,
              ),
            ),
          ),
        ],
      );
    }

    Widget body() {
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        children: [
          const SizedBox(
            height: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// NOTE : LISTITEM
              Text(
                'List Items',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.transaction!.items!
                      .map((transactionItem) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            child: TransactionItemAdmin(
                              transactionItem: transactionItem,
                              transaction: widget.transaction,
                            ),
                          ))
                      .toList()),

              /// NOTE : ADDRESS TO
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    thickness: 2,
                    color: primaryTextColor,
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Delivery To',
                    style: blackTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: bgColorAdmin2,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Address',
                          style: primaryTextStyle.copyWith(
                              fontWeight: medium, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          '${widget.transaction!.address}',
                          style: primaryTextStyle.copyWith(
                            fontWeight: reguler,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: primaryTextColor,
                    height: 20,
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Status',
                            style: blackTextStyle.copyWith(
                              fontWeight: semiBold,
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          widget.transaction!.status == 'SUCCESS'
                              ? Text(
                                  '${widget.transaction!.status}',
                                  style: secondaryColorStyle.copyWith(
                                    fontWeight: semiBold,
                                  ),
                                )
                              : Text(
                                  '${widget.transaction!.status}',
                                  style: alertTextStyle.copyWith(
                                    fontWeight: semiBold,
                                  ),
                                ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: bgColorAdmin2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: StatefulBuilder(
                                    builder: (context, setState) => SizedBox(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            DropdownButton(
                                              isExpanded: true,
                                              hint: dropdownValue == ''
                                                  ? const Text(
                                                      'Select Status',
                                                    )
                                                  : Text(
                                                      dropdownValue,
                                                    ),
                                              items: <String>[
                                                'PENDING',
                                                'SHIPPING',
                                                'SUCCESS',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .centerStart,
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownValue = newValue!;
                                                  // if (kDebugMode) {
                                                  //   print(dropdownValue);
                                                  // }
                                                });
                                              },
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      bgColorAdmin2),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Are you sure?'),
                                                      content: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        secondaryColor,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12),
                                                                    )),
                                                            onPressed:
                                                                handleSave,
                                                            child: const Text(
                                                                'YES'),
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  alertColor,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'NO'),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: const Text('Save'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Text('Ubah Status'),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColorAdmin2,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price',
                      style: blackTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: bgColorAdmin3,
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        CurrencyFormat().parseNumberCurrencyWithRp(
                            widget.transaction!.totalPrice!),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.transaction?.transfer != baseTransfer
                      ? const Text(
                          'SUDAH TRANSFER',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )
                      : const Text(
                          'BELUM TRANSFER',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                  widget.transaction!.transfer != baseTransfer
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PictureTransfer(
                                    transaction: widget.transaction!),
                              ),
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(2, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image:
                                    NetworkImage(widget.transaction!.transfer!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ],
      );
    }

    Widget bottom() {
      return Container(
        width: double.infinity,
        color: bgColorAdmin3,
        height: 50,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: alertColor,
              ),
              child: TextButton(
                onPressed: invoice,
                child: Text(
                  'CETAK INVOICE',
                  style: primaryTextStyle,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColorAdmin3,
      appBar: header(),
      body: body(),
      bottomSheet: widget.transaction!.status == 'SHIPPING'
          ? const SizedBox.shrink()
          : widget.transaction!.status == 'SUCCESS'
              ? const SizedBox.shrink()
              : bottom(),
    );
  }
}
