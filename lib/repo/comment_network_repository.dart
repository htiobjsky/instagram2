import 'dart:html';
import 'package:instagram_two_record/models/firestore/comment_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_two_record/constatns/firestore_keys.dart';
import 'package:instagram_two_record/repo/helper/transformers.dart';

class CommentNetworkRepository with Transformers {
  Future<void> createNewComment(
      String postKey, Map<String, dynamic> commentData) async {
    final DocumentReference postRef =
        FirebaseFirestore.instance.collection(COLLECTION_POST).doc(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();
    final DocumentReference commentRef =
        postRef.collection(COLLECTION_COMMENTS).doc();

    return FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      if (postSnapshot.exists) {
        await tx.set(commentRef, commentData);

        int numOfComments = postSnapshot[KEY_NUMOFCOMMENTS];
        await tx.update(postRef, {
          KEY_NUMOFCOMMENTS: numOfComments + 1,
          KEY_LASTCOMMENT: commentData[KEY_COMMENT],
          KEY_LASTCOMMENTTIME: commentData[KEY_COMMENTTIME],
          KEY_LASTCOMMENTOR: commentData[KEY_USERNAME],
        });
      }
    });
  }

  Stream<List<CommentModel>> fetchAllComments(String postKey) {
    return FirebaseFirestore.instance
        .doc(postKey)
        .collection(COLLECTION_COMMENTS)
        .orderBy(KEY_COMMENTTIME, descending: true,)
        .snapshots()
        .transform(toComments);
  }
}

CommentNetworkRepository commentNetworkRepository = CommentNetworkRepository();
