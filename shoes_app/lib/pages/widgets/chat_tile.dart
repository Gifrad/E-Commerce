import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoes_app/models/message/message_model.dart';
import 'package:shoes_app/models/product/uninitialized_product_model.dart';
import 'package:shoes_app/theme.dart';

import '../user/chat/detail_chat_page.dart';

class ChatTile extends StatelessWidget {
  final MessageModel? messageModel;
  const ChatTile({this.messageModel, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailChatPage(
              product: UninitializedProductModel(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 33),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  maxRadius: 27,
                  backgroundImage: AssetImage('assets/image_splash.png'),
                ),
                // Image.asset(
                //   'assets/image_splash.png',
                //   width: 54,
                // ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sparrow Leather Works',
                      style: primaryTextStyle.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        '${messageModel?.message}',
                        style: secondaryTextStyle.copyWith(
                          fontWeight: light,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      DateFormat.yMMMd()
                          .format(messageModel!.createdAt!)
                          .toString(),
                      style: primaryTextStyle.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      DateFormat.Hms()
                          .format(messageModel!.createdAt!)
                          .toString(),
                      style: primaryTextStyle.copyWith(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            const Divider(
              thickness: 1,
              color: Color(0xff282939),
            )
          ],
        ),
      ),
    );
  }
}
