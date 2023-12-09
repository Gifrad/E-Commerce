import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shoes_app/models/message/message_model.dart';
import 'package:shoes_app/models/product/product_model.dart';
import 'package:shoes_app/models/product/uninitialized_product_model.dart';

import '../models/auth/user_model.dart';

class MesssageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map? data;

  Stream<List<MessageModel>> getAllMessages() {
    try {
      return firestore
          .collection('chats')
          .orderBy('createdAt',descending: false)
          .snapshots()
          .map((QuerySnapshot list) {
        final result = list.docs.map<MessageModel>((DocumentSnapshot message) {
          if (kDebugMode) {
            print('message admin data : ${message.data()}');
          }
          return MessageModel.fromJson(message.data() as Map<String, dynamic>);
        }).toList();

        result.sort(
          (MessageModel a, MessageModel b) =>
              b.createdAt!.compareTo(a.createdAt!),
        );
        return result;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<MessageModel>> getMessagesByUserId(int userId) {
    try {
      return firestore
          .collection('chats')
          .doc(userId.toString())
          .collection('messages')
          .snapshots()
          .map((QuerySnapshot list) {
        final result = list.docs.map<MessageModel>((DocumentSnapshot message) {
          if (kDebugMode) {
            print(message.data());
          }
          return MessageModel.fromJson(message.data() as Map<String, dynamic>);
        }).toList();

        result.sort(
          (MessageModel a, MessageModel b) =>
              a.createdAt!.compareTo(b.createdAt!),
        );
        return result;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addMessage(
    UserModel user,
    bool isFromUser,
    String message,
    ProductModel product,
  ) async {
    try {
      firestore.collection('chats').doc(user.id.toString()).set({
        'userPhone': user.phone,
        'userId': user.id,
        'userName': user.name,
        'userPhoto': user.photo,
        'isFromUser': isFromUser,
        'message': message,
        'product': product is UninitializedProductModel ? {} : product.toJson(),
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
        // ignore: avoid_print
      }).then(
        (value) {
          if (kDebugMode) {
            print('pesan berhasil di kirim');
          }
          firestore.collection('chats').doc(user.id.toString()).collection('messages').add({
            'userPhone': user.phone,
            'userId': user.id,
            'userName': user.name,
            'userPhoto': user.photo,
            'isFromUser': isFromUser,
            'message': message,
            'product':
                product is UninitializedProductModel ? {} : product.toJson(),
            'createdAt': DateTime.now().toString(),
            'updatedAt': DateTime.now().toString(),
          });
        },
      );
    } catch (e) {
      throw Exception('Pesan gagal di kirim');
    }
  }

  Future<void> addMessageAdmin(
    UserModel user,
    int userId,
    bool isFromUser,
    String message,
    ProductModel product,
  ) async {
    try {
      firestore
          .collection('chats')
          .doc(userId.toString())
          .collection('messages')
          .add({
        'userPhone': user.phone,
        'userId': userId,
        'userName': user.name,
        'userPhoto': user.photo,
        'isFromUser': isFromUser,
        'message': message,
        'product': product is UninitializedProductModel ? {} : product.toJson(),
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
        // ignore: avoid_print
      }).then((value) => print('pesan berhasil di kirim'));
    } catch (e) {
      throw Exception('Pesan gagal di kirim');
    }
  }
}
