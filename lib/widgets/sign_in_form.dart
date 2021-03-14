import 'package:flutter/material.dart';
import 'package:instagram_two_record/constatns/auth_input_decor.dart';
import 'package:instagram_two_record/constatns/common_size.dart';
import 'package:instagram_two_record/home_page.dart';
import 'package:instagram_two_record/models/firebase_auth_state.dart';
import 'package:instagram_two_record/widgets/or_divider.dart';
import 'package:provider/provider.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  // _formKey는 사용할 Form위젯의 상태를 저장하는 key 이걸 이용해서 폼안에 어떤 텍스트가 있고 올바르게 인풋이 되는지 알아볼것
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: Builder(
        builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(common_gap),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: common_l_gap,
                ),
                Image.asset('assets/images/insta_text_logo.png'),
                TextFormField(
                  controller: _emailController,
                  cursorColor: Colors.black54,
                  decoration: textInputDeco('Email'),
                  validator: (text) {
                    if (text.isNotEmpty && text.contains("@")) {
                      return null;
                    } else {
                      return '정확한 이메일 주소를 입력해 주세요';
                    }
                  },
                ),
                SizedBox(
                  height: common_xs_gap,
                ),
                TextFormField(
                  controller: _pwController,
                  cursorColor: Colors.black54,
                  obscureText: true,
                  decoration: textInputDeco('Password'),
                  validator: (text) {
                    if (text.isNotEmpty && text.length > 5) {
                      return null;
                    } else {
                      return '제대로된 비밀번호를 입력해 주세요';
                    }
                  },
                ),
                FlatButton(
                  onPressed: () {},
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgotten Password?",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: common_s_gap,
                ),
                _submitButton(_scaffoldKey.currentContext),
                SizedBox(
                  height: common_s_gap,
                ),
                OrDivider(),
                FlatButton.icon(
                  onPressed: () {
                    Provider.of<FirebaseAuthState>(context, listen: false)
                        .loginWithFacebook(context);
                  },
                  textColor: Colors.blue,
                  icon: ImageIcon(AssetImage('assets/images/facebook.png')),
                  label: Text("Login with Facebook"),
                ),
              ],
            ),
          ),
        );},
      ),
    );
  }

  FlatButton _submitButton(BuildContext context) {
    return FlatButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          //form안의 validator들이 실행된다.
          print("Validation Success!!");
          // Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(builder: (context) => HomePage()));
          Provider.of<FirebaseAuthState>(context, listen: false)
              .logIn(context, email: _emailController.text, password: _pwController.text);
        }
      },
      child: Text(
        "Sign in",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
