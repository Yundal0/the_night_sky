// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everyones_tone/app/models/chat_model.dart';
import 'package:everyones_tone/app/models/chat_message_model.dart';
import 'package:everyones_tone/app/repository/database_helper.dart';

class ReplyRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final DatabaseHelper databaseHelper = DatabaseHelper();

  //! Firestore - chat Collection method
  Future<void> uploadReplyRemote(
      ChatModel chatModel,
      ChatMessageModel postMessageModel,
      ChatMessageModel replyMessageModel,
      String replyDocmentId) async {
    /// Chat Doc 생성 및 ID 할당
    final DocumentReference chatRef = firestore.collection('chat').doc();
    chatModel.chatId = chatRef.id;

    /// Chat Field 생성
    await chatRef.set(chatModel.toMap());

    /// Post Message 정보 저장 및 ID 할당
    final DocumentReference postMessageRef =
        chatRef.collection('message').doc();
    postMessageModel.chatId = chatRef.id;
    postMessageModel.messageId = postMessageRef.id;
    await postMessageRef.set(postMessageModel.toMap());

    /// user - myChat SubCollection 생성
    await createUserChatSubcollection(postMessageModel.userEmail, chatRef.id);

    /// Reply Message 정보 저장 및 ID 할당
    final DocumentReference replyMessageRef =
        chatRef.collection('message').doc();
    replyMessageModel.chatId = chatRef.id;
    replyMessageModel.messageId = replyMessageRef.id;
    await replyMessageRef.set(replyMessageModel.toMap());

    await createUserChatSubcollection(replyMessageModel.userEmail, chatRef.id);
    await createPreviousRepliesSubcollection(
        replyMessageModel.userEmail, chatRef.id, replyDocmentId);
  }

  //! Firestore - Create myChat SubCollection
  Future<void> createUserChatSubcollection(
    String userEmail,
    String chatId,
  ) async {
    final DocumentReference userRef =
        firestore.collection('user').doc(userEmail);

    // myChat SubCollection
    final CollectionReference myChatRef = userRef.collection('myChat');
    final DocumentReference myChatNewDocRef = myChatRef.doc(chatId);

    await myChatNewDocRef.set({
      'chatId': chatId,
    });
  }

  //! Firestore - Create previousReplies SubCollection
  Future<void> createPreviousRepliesSubcollection(
      String userEmail, String chatId, String replyDocumentId) async {
    final DocumentReference userRef =
        firestore.collection('user').doc(userEmail);

    // previousReplies SubCollection
    final CollectionReference previousRepliesRef =
        userRef.collection('previousReplies');
    final DocumentReference previousRepliesNewDocRef =
        previousRepliesRef.doc(replyDocumentId);

    await previousRepliesNewDocRef.set({
      'previousReplyDocumentId': replyDocumentId,
    });
  }

  //! SQflite
  // Future<void> uploadReplyLocal(
  //     ChatModel chatModel,
  //     ChatMessageModel postMessageModel,
  //     ChatMessageModel replyMessageModel) async {
  //   final db = await databaseHelper.database;

  //   // Chat 정보 저장
  //   await db.insert('chat', chatModel.toMap());

  //   // Post Message 정보 저장
  //   await db.insert('message', postMessageModel.toMap());

  //   // Reply Message 정보 저장
  //   await db.insert('message', replyMessageModel.toMap());
  // }
}
