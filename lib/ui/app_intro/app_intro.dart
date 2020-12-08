import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_store/data/app_intro_model/app_intro_model.dart';
import 'package:e_store/data/app_values/app_values.dart';
import 'package:e_store/handlers/shared_preferences.dart';
import 'package:e_store/services/auth.dart';
import 'package:e_store/ui/auth/auth_state.dart';
import 'package:e_store/ui/auth/auth_wrapper.dart';
import 'package:e_store/ui/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppIntro extends StatefulWidget {
  AppIntro({Key key}) : super(key: key);

  @override
  _AppIntroState createState() => _AppIntroState();
}

class _AppIntroState extends State<AppIntro> {
  static int currentPage = 0;
  List<AppIntroModel> slides = List();
  final AuthService authService = AuthService();
  AuthState authState;

  @override
  void initState() {
    super.initState();
  }

  void _initSlides() {
    slides.clear();
    slides.add(AppIntroModel(
        "Welcome to Fluxstore",
        "Lorem Ipsum Dolor Sit Amet Consectetur Adipisicing Elit",
        "assets/drawable/slide1.png"));
    slides.add(AppIntroModel(
        "Lorconsectetur adipisicing",
        "Lorem Ipsum Dolor Sit Amet Consectetur Adipisicing Elit",
        "assets/drawable/slide2.png"));
    slides.add(AppIntroModel(
        null,
        "Lorem Ipsum Dolor Sit Amet Consectetur Adipisicing Elit",
        "assets/drawable/slide3.png"));
  }

  @override
  Widget build(BuildContext context) {
    _initSlides();
    double scrW = MediaQuery.of(context).size.width;
    double scrH = MediaQuery.of(context).size.height;

    if (authState == AuthState.signIn) {
      return AuthWrapper(false);
    } else if (authState == AuthState.signUp) {
      return AuthWrapper(false);
    } else
      return Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: CarouselSlider(
                  items: slides.map((e) {
                    bool withLogin = currentPage == slides.length - 1;
                    return _getSliderItem(e, withLogin);
                  }).toList(),
                  options: CarouselOptions(
                    height: scrH - 30,
                    initialPage: currentPage,
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                    reverse: false,
                    autoPlay: false,
                    enlargeCenterPage: false,
                    onPageChanged: (int position, reason) {
                      currentPage = position;
                      if (position == slides.length - 1) {
                        SharedPreferencesController.sp.setBool("intro", true);
                      }
                      setState(() {});
                    },
                    scrollDirection: Axis.horizontal,
                  )),
            ),
            Container(
              height: 25,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _getIndicator(),
              ),
            )
          ],
        ),
      );
  }

  List<Widget> _getIndicator() {
    List<Widget> indicators = List();
    indicators.add(currentPage == slides.length - 1 ? Spacer() : Container());
    indicators.add(currentPage == slides.length - 1 ? Spacer() : Container());
    for (int i = 0; i < slides.length; i++) {
      Widget indicator = Container(
        margin: EdgeInsets.all(3),
        width: 25,
        height: 2,
        color: currentPage >= i ? Colors.black : Colors.grey,
      );
      indicators.add(indicator);
    }
    indicators.add(currentPage == slides.length - 1 ? Spacer() : Container());
    indicators.add(currentPage == slides.length - 1
        ? Container(
            width: 80,
            child: FlatButton(
              onPressed: _skip,
              child: Text(
                "${AppValues.text.skip} >",
                style: GoogleFonts.raleway(
                    color: AppTheme.greenColor, fontSize: 16),
              ),
            ),
          )
        : Container(
            width: 15,
          ));
    setState(() {});
    return indicators;
  }

  Widget _getSliderItem(AppIntroModel appIntroModels, bool withLogin) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(
              appIntroModels.getAssets,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          withLogin
              ? Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            authState = AuthState.signIn;
                          });
                        },
                        child: Text(
                          AppValues.text.signIn,
                          style: GoogleFonts.raleway(
                              color: AppTheme.greenColor, fontSize: 22),
                        ),
                      ),
                      Container(
                        child: Text("|"),
                      ),
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            authState = AuthState.signUp;
                          });
                        },
                        child: Text(
                          AppValues.text.signUp,
                          style: GoogleFonts.raleway(
                              color: AppTheme.greenColor, fontSize: 22),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  child: Text(
                    "${appIntroModels.getTitle}",
                    style: GoogleFonts.raleway(fontSize: 22),
                  ),
                ),
          Container(
            margin: EdgeInsets.only(top: 32),
            child: Center(
              child: Text(
                appIntroModels.getText,
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _skip() async {
    SharedPreferencesController.sp.setBool("intro", true);
    dynamic result = await authService.signInAnon();
  }
}
