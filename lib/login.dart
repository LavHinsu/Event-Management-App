import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'afterlogin.dart';
import 'user.dart' as User;

class AfterSplash extends StatefulWidget {
  @override
  _AfterSplash createState() => new _AfterSplash();
}

class _AfterSplash extends State<AfterSplash> {
  SharedPreferences prefs;
  String uid;
  String usern;
  //var prefs=null;

  String Username, Password;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseUser user;
  void initState() {
     /*prefs= await SharedPreferences.getInstance();
      if(prefs.getBool("isloggedin",false))
     {
      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => (AfterLogin())));
     }
     else{}
     
    */
    //refs=  await SharedPreferences.getInstance();
    SharedPreferences.getInstance()..then((prefs){
        setState(() {
          this.prefs=prefs;
           uid=prefs.getString("user");
           usern=prefs.getString('username');
           
        });
    });
   
    

  }
  
  

  // new Future.delayed(const Duration(seconds: 2));
 

  void signIn() async {
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: Username, password: Password);
    } catch (e) {
      print(e.toString());
    } finally {
      if (user != null) {
        User.username = Username;
        User.user = user;
        print('Succesfull');
        prefs.setString("user", User.user.uid);
        prefs.setString('username',User.username);
        Navigator.pushReplacementNamed(context, "/afterlogin");
      } else {
        print('Unsuccessfull');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: new Center(
            child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[FlutterLogo(size: 100)],
                  )
                ],
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Email Address',
                    ),
                    onChanged: (String val) {
                      if (val != null) Username = val;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Password',
                    ),
                    onChanged: (String val) {
                      if (val != null) Password = val;
                    },
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 30, 0),
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      child: Text('Login'),
                      onPressed: () {
                        signIn();
                      },
                    )),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    alignment: Alignment.bottomCenter,
                    child: FlatButton(
                      child: Text('Forgot Password'),
                      onPressed: () {},
                    ))
              ],
            ))
          ],
        )),
      ),
    );
  }
}
