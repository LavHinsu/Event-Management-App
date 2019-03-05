import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'main_page.dart';
import 'user.dart' as User;

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  SharedPreferences prefs;
  String uid;
  String username;

  final myController = TextEditingController();
  String phoneNo;
  String verificationId;
  String smsCode;
  String password;

  static FirebaseUser user;
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() {
          this.prefs = prefs;
          uid = prefs.getString("user");
          username = prefs.getString('username');
        });
      });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  } // new Future.delayed(const Duration(seconds: 2));

  void sigIn() async {
    var url = "https://udaan19-events-api.herokuapp.com/users/login";
    var response = await http.post(
        url, body: {"username": username, "password": password});
  }

  void firebaseSigIn() async {
    try {
      final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
        verificationId = verId;
        print('code sent');
      };
      final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
        print('verified');
        prefs.setString('user', user.uid);
        prefs.setString("username", User.username);
        print(prefs.getString('user'));
        print(prefs.getString("username"));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      };
      final PhoneVerificationFailed veriFailed = (AuthException exception) {
        print('${exception.message}');
      };
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: this.phoneNo,
          forceResendingToken: 1,
          codeSent: smsCodeSent,
          timeout: const Duration(seconds: 20),
          verificationCompleted: verifiedSuccess,
          verificationFailed: veriFailed);
    } catch (e) {
      print(e.toString());
    } finally {
      User.username = phoneNo;
      User.user = user;
      print('Succesfull');
      prefs.setString("user", User.user.uid);
      prefs.setString('username', User.username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.fill)),
          child: new Center(
              child: Column(
            children: <Widget>[
              Spacer(),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage("assets/images/textfield.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration.collapsed(
                                hintText: "Enter your phone number"),
                            onChanged: (String val) {
                              if (val != null) phoneNo = "+91" + val;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage("assets/images/textfield.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            obscureText: true,
                            decoration:
                                InputDecoration.collapsed(hintText: "Password"),
                            onChanged: (String val) {
                              if (val != null) password = val;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: TextField(
                                          controller: myController,
                                          autofocus: true,
                                          onChanged: (String val) {
                                            if (val != null) {
                                              smsCode = val;
                                            }
                                          },
                                          decoration: InputDecoration(
                                              hintText:
                                                  'Enter OTP sent to your device'),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Send OTP'),
                                            onPressed: firebaseSigIn,
                                          ),
                                          FlatButton(
                                            child: Text('Confirm'),
                                            onPressed: () {
                                              FirebaseAuth.instance
                                                  .signInWithPhoneNumber(
                                                      verificationId:
                                                          verificationId,
                                                      smsCode: smsCode)
                                                  .then((user) {
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        '/afterlogin');
                                              }).catchError((e) {
                                                print(e);
                                              });
                                            },
                                          )
                                        ],
                                      ));
                            },
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: <Widget>[
                                Image(
                                  image: AssetImage("assets/images/button.png"),
                                  width: 150.0,
                                  height: 80.0,
                                ),
                                Align(
                                    child: Text(
                                      "Log In",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    alignment: AlignmentDirectional.center)
                              ],
                            ),
                          ),
                        ],
                      )),
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: FlatButton(
                      color: Colors.transparent,
                      child: Text("Forgot Password?"),
                      onPressed: () {},
                    ),
                  )
                ],
              ))
            ],
          )),
        ),
      ),
    );
  }
}