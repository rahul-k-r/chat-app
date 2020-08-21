import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './colors/color.dart';

import './screens/auth_screen.dart';
import './screens/chat_selector_screen.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).primaryColor);
    return MaterialApp(
      title: 'FlutterChat',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        // brightness: Brightness.light,
        primarySwatch: primarySwatchLight,
        backgroundColor: Color.fromRGBO(240, 240, 240, 1),
        scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 1),
        accentColor: Colors.deepOrange,
        accentColorBrightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          color: primarySwatchLight[500],
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText2: TextStyle(
                color: Colors.grey[800],
              ),
              bodyText1: TextStyle(
                color: Colors.grey[100],
              ),
              headline6: TextStyle(
                color: Colors.grey[600],
              ),
            ),
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: primarySwatchLight[500],
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: primarySwatchDark,
        backgroundColor: Color.fromRGBO(26, 26, 26, 1),
        scaffoldBackgroundColor: Color.fromRGBO(0, 0, 0, 1),
        accentColor: Color.fromRGBO(140, 20, 40, 1),
        accentColorBrightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          color: primarySwatchDark[500],
        ),
        textTheme: ThemeData.dark().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Colors.grey[100],
              ),
              bodyText2: TextStyle(
                color: Colors.grey[100],
              ),
              headline6: TextStyle(
                color: Colors.grey[400],
              ),
            ),
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Theme.of(context).primaryColorDark,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            if (userSnapshot.hasData) {
              return MainChatScreen();
            }
            return AuthScreen();
          }),
    );
  }
}
