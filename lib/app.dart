import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/theme_config.dart';
import 'package:social_app_ui/views/screens/auth/login.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/services.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(

      statusBarColor: Colors.orange,

    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,

      theme: themeData(ThemeConfig.lightTheme),

      // darkTheme: themeData(ThemeConfig.darkTheme),
        home: AnimatedSplashScreen(

            duration: 1000,
            splash: "assets/images/splash22.png",
            nextScreen:  new Login(),
            splashTransition: SplashTransition.fadeTransition,
            // pageTransitionType: PageTransitionType.scale,
            backgroundColor: Colors.black54
        )

    );
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
    );
  }
}
