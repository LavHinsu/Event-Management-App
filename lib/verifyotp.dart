import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'afterlogin.dart';



class Verifyotp extends StatefulWidget{
  @override
   final String username;
    Verifyotp({Key key, @required this.username}) : super(key: key);

  _Verifyotp createState() => new _Verifyotp();
   
  
}
class _Verifyotp extends State<Verifyotp> {

  String smsCode;
  String verificationId;

    

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };
 
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
  
    };
 
    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
      print('verified');
    };
 
    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
    };
 
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.widget.username,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);
  } 


  signIn() {
    FirebaseAuth.instance
        .signInWithPhoneNumber(verificationId: verificationId, smsCode: smsCode)
        .then((user) {
      Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AfterLogin()));
    }).catchError((e) {
      print(e);
    });
  }
 
  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('PhoneAuth'),
      ),
      body: new Center(
        child: Container(
            padding: EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(hintText: 'Enter the otp sent to your phone no'),
                  onChanged: (value) {
                      this.smsCode = value;
                  },
                ),
                SizedBox(height: 10.0),
                FlatButton(
                child: Text('Verify'
                ),
                onPressed: () {
                    FirebaseAuth.instance.currentUser().then((user) {
                    if (user != null) {
                       Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AfterLogin()));
                    } else {
                     signIn();
                    }
                  });
                },
              ),
              RaisedButton(
                    onPressed: verifyPhone,
                    child: Text('Send OTP'),
                    textColor: Colors.white,
                    elevation: 7.0,
                    color: Colors.blue)
              ],
            )),
      ),
    );
  }
}

