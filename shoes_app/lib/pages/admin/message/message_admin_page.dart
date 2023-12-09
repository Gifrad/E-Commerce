import 'package:flutter/material.dart';
import 'package:shoes_app/models/message/message_model.dart';
import 'package:shoes_app/pages/widgets/chat_tile_admin.dart';
import 'package:shoes_app/services/message_service.dart';
import 'package:shoes_app/theme.dart';

class MessageAdminPage extends StatelessWidget {
  const MessageAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        title: const Text('Responses'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: bgColorAdmin1,
      );
    }

    Widget emptyChat() {
      return Container(
        width: double.infinity,
        color: bgColorAdmin3,
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
              'Opss no message yet?',
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Please Wait Okey...',
              style: secondaryTextStyle,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    }

    Widget body() {
      return StreamBuilder<List<MessageModel>>(
        stream: MesssageService().getAllMessages(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return emptyChat();
            }
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              color: bgColorAdmin3,
              child: ListView(
                children:
                    // [
                    //   ChatTileAdmin(
                    //     messageModel: snapshot.data![snapshot.data!.length - 1],
                    //   )
                    // ],

                    snapshot.data!
                        .map((data) => ChatTileAdmin(
                              messageModel: data,
                            ))
                        .toList(),
              ),
            );
          } else {
            return emptyChat();
          }
        },
      );
    }

    return Scaffold(
      backgroundColor: bgColorAdmin3,
      appBar: header(),
      body: body(),
    );
  }
}
