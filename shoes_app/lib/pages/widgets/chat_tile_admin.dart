import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoes_app/models/message/message_model.dart';
import 'package:shoes_app/pages/admin/message/detail_chat_admin.dart';
import 'package:shoes_app/services/message_service.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/url.dart';

import '../../models/product/uninitialized_product_model.dart';

class ChatTileAdmin extends StatelessWidget {
  final MessageModel? messageModel;
  const ChatTileAdmin({this.messageModel, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailChatPageAdmin(
              messageModel: messageModel,
              product: UninitializedProductModel(),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                messageModel!.userImage == basePhotoProfile
                    ? Image.asset(
                        'assets/image_profile.png',
                        width: 54,
                      )
                    : CircleAvatar(
                        maxRadius: 27,
                        backgroundImage: NetworkImage(
                          messageModel!.userImage!,
                        ),
                      ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messageModel!.userName!,
                      style: blackTextStyle.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    StreamBuilder(
                      stream: MesssageService()
                          .getMessagesByUserId(messageModel!.userId!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {}
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: LastText(
                              messageModel:
                                  snapshot.data![snapshot.data!.length - 1],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
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
                      style: blackTextStyle.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      DateFormat.Hms()
                          .format(messageModel!.createdAt!)
                          .toString(),
                      style: blackTextStyle.copyWith(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(thickness: 2),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class LastText extends StatelessWidget {
  final MessageModel? messageModel;
  const LastText({this.messageModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      messageModel!.message!,
      style: secondaryTextStyle.copyWith(
        fontWeight: light,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
