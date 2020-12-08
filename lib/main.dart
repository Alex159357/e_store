import 'package:e_store/data/models/user_model.dart';
import 'package:e_store/services/auth.dart';
import 'package:e_store/ui/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'handlers/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              StreamProvider<UserModel>.value(value: AuthService().user),
            ],
            child: MaterialApp(
              title: 'E-Commerce App',
              debugShowCheckedModeBanner: false,
              home: Wrapper(),
            ),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          title: 'E-Commerce App',
          debugShowCheckedModeBanner: false,
          home: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Image.asset("assets/drawable/logo.png"))
                ],
              )),
        );
      },
    );
  }
}
