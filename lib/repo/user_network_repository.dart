import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_two_record/constatns/firestore_keys.dart';
import 'package:instagram_two_record/models/firestore/user_model.dart';
import 'package:instagram_two_record/repo/helper/transformers.dart';

class UserNetworkRepository with Transformers {
  Future<void> attemptCreateUser({String userKey, String email}) async {
    final DocumentReference userRef =
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(userKey);

    DocumentSnapshot snapshot = await userRef.get();
    if (!snapshot.exists) {
      return await userRef.set(UserModel.getMapForCreateUser(email));
    }
  }

  Stream<UserModel> getUserModelStream(String userKey) {
    return FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(userKey)
        .snapshots()
        .transform(toUser);
  }

  Stream<List<UserModel>> getAllUsersWithoutMe() {
    return FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .snapshots()
        .transform(toUsersExceptMe);
  }

  Future<void> followUser({String myUserKey, String otherUserKey}) async {
    final DocumentReference myUserRef =
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(myUserKey);
    final DocumentSnapshot mySnapshot = await myUserRef.get();
    final DocumentReference otherUserRef = FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(otherUserKey);
    final DocumentSnapshot otherSnapshot = await otherUserRef.get();

    FirebaseFirestore.instance.runTransaction((tx) async {
      if (mySnapshot.exists && otherSnapshot.exists) {
        await tx.update(myUserRef, {
          KEY_FOLLOWINGS: FieldValue.arrayUnion([otherUserKey])
        });
        int currentFollowers = otherSnapshot[KEY_FOLLOWERS];
        await tx.update(otherUserRef, {KEY_FOLLOWERS: currentFollowers + 1});
      }
    });
  }

  Future<void> unfollowUser({String myUserKey, String otherUserKey}) async {
    final DocumentReference myUserRef =
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(myUserKey);
    final DocumentSnapshot mySnapshot = await myUserRef.get();
    final DocumentReference otherUserRef = FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(otherUserKey);
    final DocumentSnapshot otherSnapshot = await otherUserRef.get();

    FirebaseFirestore.instance.runTransaction((tx) async {
      if (mySnapshot.exists && otherSnapshot.exists) {
        await tx.update(myUserRef, {
          KEY_FOLLOWINGS: FieldValue.arrayRemove([otherUserKey])
        });
        int currentFollowers = otherSnapshot[KEY_FOLLOWERS];
        await tx.update(otherUserRef, {KEY_FOLLOWERS: currentFollowers - 1});
      }
    });
  }
}

//다른 파일에서 쓸 수 있도록 내보기
UserNetworkRepository userNetworkRepository = UserNetworkRepository();
