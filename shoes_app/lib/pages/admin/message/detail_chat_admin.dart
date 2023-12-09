import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/models/message/message_model.dart';
import 'package:shoes_app/models/product/uninitialized_product_model.dart';
import 'package:shoes_app/pages/widgets/chat_bubble_admin.dart';
import 'package:shoes_app/providers/auth_provider.dart';
import 'package:shoes_app/services/message_service.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/url.dart';

import '../../../models/product/product_model.dart';

// ignore: must_be_immutable
class DetailChatPageAdmin extends StatefulWidget {
  MessageModel? messageModel;
  late ProductModel? product;
  DetailChatPageAdmin({this.messageModel,this.product, super.key});

  @override
  State<DetailChatPageAdmin> createState() => _DetailChatPageAdminState();
}

class _DetailChatPageAdminState extends State<DetailChatPageAdmin> {
  TextEditingController messageController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    void handleAddMessage() async {
      await MesssageService().addMessageAdmin(
        authProvider.user,
        widget.messageModel!.userId!,
        false,
        messageController.text,
        widget.product!,
      );

      setState(() {
        widget.product = UninitializedProductModel();
        messageController.text = '';
      });
    }

    PreferredSizeWidget header() {
      return PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: bgColorAdmin1,
          centerTitle: false,
          title: Row(
            children: [
             widget.messageModel!.userImage == basePhotoProfile ? Image.asset(
                'assets/image_profile.png',
                width: 50,
              ) : CircleAvatar(
                maxRadius: 25,
                backgroundImage: NetworkImage('${widget.messageModel!.userImage}'),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.messageModel!.userName}',
                    style: blackTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Online',
                    style: primaryTextStyle.copyWith(
                      fontWeight: light,
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    Widget productPreview() {
      return Container(
        width: 225,
        height: 74,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: backgroundColor5,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primaryColor,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: widget.product!.galleries!.isEmpty
                  ? Image.network(
                      'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      '${widget.product?.galleries?[0].url}',
                      width: 54,
                    ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.product?.name}',
                    style: primaryTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    '\$${widget.product?.price}',
                    style: priceTextStyle.copyWith(
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.product = UninitializedProductModel();
                });
              },
              child: Image.asset(
                'assets/button_close.png',
                width: 22,
              ),
            ),
          ],
        ),
      );
    }

    Widget chatInput() {
      return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.product is UninitializedProductModel
                ? const SizedBox.shrink()
                : productPreview(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: bgColorAdmin1,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextFormField(
                        style: primaryTextStyle,
                        controller: messageController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Type Message...',
                          hintStyle: secondaryTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: handleAddMessage,
                  child: Image.asset(
                    'assets/button_submit.png',
                    width: 45,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget content() {
      return StreamBuilder<List<MessageModel>>(
        stream: MesssageService().getMessagesByUserId(widget.messageModel!.userId!),
        builder: (context, snapshot) {
          if (kDebugMode) {
            print("has data ${snapshot.hasData}");
          }
          if (snapshot.hasData) {
            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: defaultMargin,
              ),
              children: snapshot.data!
                  .map((MessageModel message) => ChatBubbleAdmin(
                        isSender: message.isFromUser!,
                        text: message.message!,
                        product: message.product,
                      ))
                  .toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }

    return Scaffold(
      backgroundColor: bgColorAdmin3,
      appBar: header(),
      bottomNavigationBar: chatInput(),
      body: content(),
    );
  }
}
