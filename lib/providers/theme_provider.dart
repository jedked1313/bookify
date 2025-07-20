import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData = _themeData.brightness == Brightness.dark
        ? ThemeData.light()
        
        : ThemeData.dark();
    notifyListeners();
  }

  var darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
  );
}
