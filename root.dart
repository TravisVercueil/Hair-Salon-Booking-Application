import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_haircutters/currentUser.dart';
import 'package:the_haircutters/homepage.dart';
import 'package:the_haircutters/login.dart';


enum AuthStatus{
  notLoggedIn,
  LoggedIn,
}

class OurRoot extends StatefulWidget {
  const OurRoot({super.key});

  @override
  State<OurRoot> createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus _authStatus = AuthStatus.notLoggedIn;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    var _currentUser = Provider.of<CurrentUser>(context, listen: false);
    var _returnString = _currentUser.onStartUp();
    if (_returnString == "success") {
      setState(() => _authStatus = AuthStatus.LoggedIn);
    } else if (_returnString == "error") {
      setState(() => _authStatus = AuthStatus.notLoggedIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? retVal;
    switch(_authStatus){
      case AuthStatus.notLoggedIn:
        retVal = HomeScreen();
        break;
      case AuthStatus.LoggedIn:
        retVal = HomePage();
        break;
      default:

    }


    return retVal!;
  }
}
