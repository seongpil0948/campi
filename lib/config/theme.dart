part of './index.dart';

const buttonRadius = 18.0;
const ovalRadius = 40.0;
const ovalBorderWidth = 3.0;

abstract class PiThemeInterface with ChangeNotifier {
  ThemeData get lightTheme;
  ThemeData get darkTheme;

  static bool _isDarkTheme = false; // default Theme is Light
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;
  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
}

class PiTheme extends PiThemeInterface {
  @override
  ThemeData get lightTheme {
    final primaryColor = Colors.blue.shade900; //1
    const primaryVarColor = Colors.deepPurple;
    const secondColor = Colors.grey; //1
    const bodyTxt2 = TextStyle(color: Colors.black);
    final origin = ThemeData.light();
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      hintColor: Colors.black,
      cardColor: Colors.grey[100],
      colorScheme: const ColorScheme.light()
          .copyWith(secondary: secondColor, primary: primaryColor),
      scaffoldBackgroundColor: Colors.white,
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      textTheme: TextTheme(
          bodyText1: const TextStyle(color: Colors.white),
          bodyText2: bodyTxt2,
          subtitle2: bodyTxt2.copyWith(color: primaryColor),
          overline: origin.textTheme.overline!.copyWith(color: Colors.white)),
      primaryTextTheme: TextTheme(
          bodyText1: TextStyle(
            color: primaryColor,
          ),
          bodyText2: const TextStyle(color: primaryVarColor)),
      appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          toolbarTextStyle: TextStyle(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0),
      // visualDensity: VisualDensity(vertical: 0.5, horizontal: 0.5),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: primaryColor, width: 1),
              borderRadius: BorderRadius.circular(buttonRadius)),
        ),
      ),
      dividerColor: Colors.black,
      iconTheme: IconThemeData(color: primaryColor),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: ThemeData.light().textTheme.caption,
        border: OutlineInputBorder(
            borderSide: BorderSide(width: ovalBorderWidth, color: primaryColor),
            borderRadius: const BorderRadius.all(Radius.circular(ovalRadius))),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ovalRadius),
          borderSide: BorderSide(width: ovalBorderWidth, color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ovalRadius),
          borderSide: BorderSide(width: ovalBorderWidth, color: primaryColor),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor, foregroundColor: Colors.white),
      buttonTheme: ButtonThemeData(
        // 4
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius)),
        buttonColor: primaryColor,
      ),
    );
  }

  @override
  ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
    );
  }
}
