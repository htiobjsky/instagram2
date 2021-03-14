import 'package:instagram_two_record/models/firestore/user_model.dart';

String getNewPostKey(UserModel userModel) => '${DateTime.now().millisecondsSinceEpoch}_${userModel.userKey}';