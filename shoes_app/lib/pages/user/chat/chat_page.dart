import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/models/message/message_model.dart';
import 'package:shoes_app/pages/widgets/chat_tile.dart';
import 'package:shoes_app/providers/auth_provider.dart';
import 'package:shoes_app/services/message_service.dart';

import '../../../providers/page_provider.dart';
import '../../../theme.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    Widget header() {
      return AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: backgroundColor3,
        centerTitle: true,
        title: Text(
          'Message Support',
          style: primaryTextStyle.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
      );
    }

    Widget emptyChat() {
      return Expanded(
        child: Container(
          width: double.infinity,
          color: backgroundColor1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image_empty_massage.png',
                width: 80,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Opss belum ada pesan?',
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Anda belum pernah melakukan transaksi',
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
                        horizontal: 24,
                        vertical: 10,
                      ),
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      pageProvider.currentIndex = 0;
                    },
                    child: Text(
                      'Jelajahi Produk',
                      style: primaryTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: medium,
                      ),
                    )),
              )
            ],
          ),
        ),
      );
    }

    Widget content() {
      return StreamBuilder<List<MessageModel>>(
        stream: MesssageService().getMessagesByUserId(authProvider.user.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return emptyChat();
            }
            return Expanded(
              child: Container(
                width: double.infinity,
                color: backgroundColor1,
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultMargin,
                  ),
                  children: [
                    ChatTile(
                        messageModel:
                            snapshot.data![snapshot.data!.length - 1]),
                  ],
                ),
              ),
            );
          } else {
            return emptyChat();
          }
        },
      );
    }

    return Column(
      children: [
        header(),
        content(),
      ],
    );
  }
}
