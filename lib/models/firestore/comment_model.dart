import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_two_record/constatns/firestore_keys.dart';

class CommentModel {
  final String username;
  final String userKey;
  final String comment;
  final DateTime commentTime;
  final String commentKey;
  final DocumentReference reference;


  CommentModel.fromMap(Map<String, dynamic> map, this.commentKey,
      {this.reference})
      : username = map[KEY_USERNAME],
        userKey = map[KEY_USERKEY],
        comment = map[KEY_COMMENT],
        commentTime = map[KEY_COMMENTTIME] == null
            ? DateTime.now().toUtc()
            : (map[KEY_COMMENTTIME] as Timestamp).toDate();

  // firebase에서 JSON데이터를 받아와서 각각 item을 채워줌

  CommentModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), snapshot.id,
      reference: snapshot.reference);

  static Map<String, dynamic> getMapForNewComment(String userKey, String username, String comment) {
    Map<String, dynamic> map = Map();
    map[KEY_USERKEY] = userKey;
    map[KEY_USERNAME] = username;
    map[KEY_COMMENT] = comment;
    map[KEY_COMMENTTIME] = DateTime.now().toUtc();
    return map;
  }


}