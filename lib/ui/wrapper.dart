import 'package:e_store/data/app_values/app_values.dart';
import 'package:e_store/data/models/app_start_model.dart';
import 'package:e_store/data/models/user_model.dart';
import 'package:e_store/services/start_app_service.dart';
import 'package:e_store/ui/app_intro/app_intro.dart';
import 'package:e_store/ui/auth/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home/home_wrapper.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserModel>(context);
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data is AppStartModel) {
            if (user is UserModel) {
              //loggined
              return HomeWrapper();
            } else {
              //not loggined
              if (snapshot.data.introState) {
                return AuthWrapper(true);
              } else
                return AppIntro();
            }
          } else
            return Text("${snapshot.data.introState}");
        } else
          return Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Center(child: Image.asset(AppValues.images.logo))],
              ));
      },
      future: StartAppService.introState(),
    );
  }
}
