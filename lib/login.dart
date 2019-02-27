import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        child: Container(
          decoration: BoxDecoration(image: DecorationImage(
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
                                Image(image: AssetImage(
                                    "assets/images/textfield.png"),),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "Phone number"),
                                    onChanged: (String val) {
                                      if (val != null) Username = val;
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
                                Image(image: AssetImage(
                                    "assets/images/textfield.png"),),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: TextField(
                                    obscureText: true,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "Password"),
                                    onChanged: (String val) {
                                      if (val != null) Password = val;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 15, 30, 0),
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: <Widget>[
                                  Image(image: AssetImage(
                                      "assets/images/button.png"),),
                                  Align(child: Text("Log In",
                                    style: TextStyle(fontSize: 18.0,),),
                                      alignment: AlignmentDirectional.center)
                                ],
                              )),
                          Expanded(

                              child: FlatButton(
                                child: Text('Forgot Password'),
                                onPressed: () {},
                              ))
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
  }
}
