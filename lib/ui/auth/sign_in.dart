import 'package:e_store/data/app_values/app_values.dart';
import 'package:e_store/ui/auth/auth_global.dart';
import 'package:e_store/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with AuthGlobal {
  final _formKey = GlobalKey<FormState>();
  String error = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(left: 40, right: 40),
              child: Container(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 25, bottom: 25, left: 40, right: 40),
                        child: Image.asset(AppValues.images.logo),
                      ),
                      Container(
                        child: TextFormField(
                          onChanged: setEmail,
                          validator: validateEmail,
                          decoration: InputDecoration(
                            labelText: AppValues.text.email,
                            contentPadding: const EdgeInsets.only(
                                left: 16, top: 8, bottom: 8),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25, bottom: 25),
                        child: TextFormField(
                          obscureText: true,
                          onChanged: setPass,
                          validator: validatePassword,
                          decoration: InputDecoration(
                            labelText: AppValues.text.password,
                            contentPadding: const EdgeInsets.only(
                                left: 16, top: 8, bottom: 8),
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Switch to sign up button
                            Container(
                              margin: EdgeInsets.only(left: 15, top: 15),
                              child: Align(
                                alignment: FractionalOffset.bottomLeft,
                                child: Container(
                                    child: FlatButton.icon(
                                  icon: Icon(Icons.person),
                                  label: Text(AppValues.text.signUp),
                                  onPressed: widget.toggleView,
                                )),
                              ),
                            ),
                            //Start login
                            Container(
                              margin: EdgeInsets.only(left: 15, top: 15),
                              child: Align(
                                alignment: FractionalOffset.bottomRight,
                                child: Column(
                                  children: [
                                    Container(
                                        color: AppTheme.greenColor,
                                        child: FlatButton.icon(
                                          icon: Icon(Icons.login),
                                          label: Text(AppValues.text.signIn),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              login().then((value) {
                                                setState(() {
                                                  error = value;
                                                });
                                              });
                                            }
                                          },
                                        )),
                                    FlatButton(
                                      onPressed: () {
                                        skip().then((value) {
                                          setState(() {
                                            error = value;
                                          });
                                        });
                                      },
                                      child: Text(AppValues.text.skip + " >"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Text(
                        error,
                        style: GoogleFonts.raleway(
                            fontSize: 18, color: Colors.redAccent),
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
