import 'package:e_store/ui/auth/sign_in.dart';
import 'package:e_store/ui/auth/sign_up.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatefulWidget {
  final bool shoSignIn;

  AuthWrapper(this.shoSignIn);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  static bool showSignIn = true;

  @override
  void initState() {
    showSignIn = widget.shoSignIn != null ? widget.shoSignIn : true;
    super.initState();
  }

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn ? SignIn(toggleView) : SignUp(toggleView);
  }
}
