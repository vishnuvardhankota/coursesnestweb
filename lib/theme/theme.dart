import 'package:coursesnest/utils/paths.dart';

// Define a class to manage the application themes
class PAppTheme {
  // Private constructor to prevent instantiation of this class
  PAppTheme._();

  // Define a static method to provide the light theme data
  static ThemeData lightTheme = ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF5022C3)),
      scaffoldBackgroundColor: const Color(0xFFF2F5FA),
      cardColor: Colors.white,
      expansionTileTheme:
          const ExpansionTileThemeData(backgroundColor: Color(0xFFEDEDED)),
      drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFFF8F8F8)),
      popupMenuTheme: const PopupMenuThemeData(color: Color(0xFFF8F8F8)),
      useMaterial3: true,
      brightness: Brightness.light,
      hoverColor: Colors.transparent,
      textTheme: PTextTheme.lightTextTheme);

  // Define a static method to provide the dark theme data
  static ThemeData darkTheme = ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1F1F1F)),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF242424),
      expansionTileTheme:
          const ExpansionTileThemeData(backgroundColor: Color(0xFF2C2C2C)),
      drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF1E1E1E)),
      popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF1E1E1E)),
      useMaterial3: true,
      brightness: Brightness.dark,
      hoverColor: Colors.transparent,
      textTheme: PTextTheme.darkTextTheme);
}
