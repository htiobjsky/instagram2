import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_two_record/home_page.dart';
import 'package:instagram_two_record/models/firebase_auth_state.dart';
import 'package:instagram_two_record/models/firestore/user_model.dart';
import 'package:instagram_two_record/models/user_model_state.dart';
import 'package:instagram_two_record/repo/user_network_repository.dart';
import 'package:instagram_two_record/screens/auth_screen.dart';
import 'package:instagram_two_record/widgets/my_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'constatns/material_white.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  FirebaseAuthState _firebaseAuthState = FirebaseAuthState();
  Widget _currentWidget;

  @override
  Widget build(BuildContext context) {
    _firebaseAuthState.watchAuthChange();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseAuthState>.value(
            value: _firebaseAuthState),
        ChangeNotifierProvider<UserModelState>(
          create: (_) => UserModelState(),
        ),
      ],
      child: MaterialApp(
        home: Consumer<FirebaseAuthState>(
          builder: (BuildContext context, FirebaseAuthState firebaseAuthState,
              Widget child) {
            switch (firebaseAuthState.firebaseAuthStatus) {
              case FirebaseAuthStatus.signout:
                _clearUserModel(context);
                _currentWidget = AuthScreen();
                break;
              case FirebaseAuthStatus.signin:
                _initUserModel(firebaseAuthState, context);
                _currentWidget = HomePage();
                break;
              default:
                _currentWidget = MyProgressIndicator();
            }
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              child: _currentWidget,
            );
          },
        ),
        theme: ThemeData(primarySwatch: white),
      ),
    );
  }

  void _initUserModel(
      FirebaseAuthState firebaseAuthState, BuildContext context) {

    UserModelState userModelState = Provider.of<UserModelState>(context, listen: false);

    userModelState.currentStreamSub = userNetworkRepository
        .getUserModelStream(firebaseAuthState.user.uid)
        .listen((userModel) {
      userModelState.userModel = userModel;
    });
  }

  void _clearUserModel(BuildContext context) {
    UserModelState userModelState = Provider.of<UserModelState>(context, listen: false);
    userModelState.clear();
  }
}
