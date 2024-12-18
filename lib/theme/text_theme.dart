import 'package:coursesnest/utils/paths.dart';

// Define a class to manage the application's text themes
class PTextTheme {
  // Private constructor to prevent instantiation of this class
  PTextTheme._();

  // Define a static field to hold the light text theme
  static TextTheme lightTextTheme = const TextTheme(
    displayLarge: TextStyle(fontSize: 34,color: Colors.black),
    displayMedium: TextStyle(fontSize: 27,color: Colors.black),
    // displaySmall: TextStyle(fontSize: 27,color: Colors.black),

    headlineLarge: TextStyle(fontSize: 25,color: Colors.black),
    headlineMedium: TextStyle(fontSize: 20,color: Colors.black),
    headlineSmall: TextStyle(fontSize: 18,color: Colors.black),

    titleLarge: TextStyle(fontSize: 25,color: Colors.black),
    titleMedium: TextStyle(fontSize: 20,color: Colors.black),
    // titleSmall: TextStyle(fontSize: 21,color: Colors.black),

    bodyLarge: TextStyle(fontSize: 18,color: Colors.black),
    bodyMedium: TextStyle(fontSize: 15,color: Colors.black),
    bodySmall: TextStyle(fontSize: 12,color: Colors.black)
  );
  
  // Define a static field to hold the dark text theme
  static TextTheme darkTextTheme = const TextTheme(
    displayLarge: TextStyle(fontSize: 34,color: Colors.white),
    displayMedium: TextStyle(fontSize: 27,color: Colors.white),
    // displaySmall: TextStyle(fontSize: 31,color: Colors.white),

    headlineLarge: TextStyle(fontSize: 25,color: Colors.white),
    headlineMedium: TextStyle(fontSize: 20,color: Colors.white),
    headlineSmall: TextStyle(fontSize: 18,color: Colors.white),

    titleLarge: TextStyle(fontSize: 20,color: Colors.white),
    titleMedium: TextStyle(fontSize: 28,color: Colors.white),
    // titleSmall: TextStyle(fontSize: 21,color: Colors.white),

    bodyLarge: TextStyle(fontSize: 18,color: Colors.white),
    bodyMedium: TextStyle(fontSize: 15,color: Colors.white),
    bodySmall: TextStyle(fontSize: 12,color: Colors.white)
  );
}