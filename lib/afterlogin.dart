import 'package:flutter/material.dart';
import 'user.dart' as user;

class AfterLogin  extends StatefulWidget {
  @override
  _AfterLogin createState() => new _AfterLogin();
}
class _AfterLogin extends State<AfterLogin> {
    @override
    // TODO: implement widget
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('AfterLogin'),
      ),
      body: Center(
        child: Text(user.user.uid),
      ),
    );
  }
}
