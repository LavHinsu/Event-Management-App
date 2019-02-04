import 'package:flutter/material.dart';
//import 'user.dart' as user;

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
        child: Container(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: (){},
                child: Card(
                  child: Center(
                    child: Text('Event_1'),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: Card(
                  child: Center(
                    child: Text('Event_2'),
                  ),
                
                  
                ),
              )
            ],
          ),
        ),
        
      ),
    );
  }
}
