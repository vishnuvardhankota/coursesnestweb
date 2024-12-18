import 'package:coursesnest/utils/paths.dart';

extension UIThemeExtension on BuildContext {
  Color get canvasColor => Theme.of(this).canvasColor;
  Color get hoverColor => Theme.of(this).hoverColor;
  Color get inverseColor => Theme.of(this).primaryColor;
  Color get inverseBackgroundColor => Theme.of(this).secondaryHeaderColor;
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;

  TextStyle get courseLargeTitle => Theme.of(this).textTheme.displayLarge!;
  TextStyle get courseSmallTitle => Theme.of(this).textTheme.displayMedium!;

  TextStyle get courseLargeDescription => Theme.of(this).textTheme.headlineLarge!;
  TextStyle get courseSmallDescription => Theme.of(this).textTheme.headlineSmall!;

  TextStyle get courseLargeRating => Theme.of(this).textTheme.headlineLarge!;
  TextStyle get courseSmallRating => Theme.of(this).textTheme.headlineSmall!;

  TextStyle get courseLargeTopicHeading => Theme.of(this).textTheme.headlineLarge!;
  TextStyle get courseSmallTopicHeading => Theme.of(this).textTheme.headlineSmall!;

  TextStyle get courseLargeTopicDetails => Theme.of(this).textTheme.bodyLarge!;
  TextStyle get courseSmallTopicDetails => Theme.of(this).textTheme.bodyMedium!;

  TextStyle get titleLarge => Theme.of(this).textTheme.titleLarge!;
  TextStyle get titleMedium => Theme.of(this).textTheme.titleMedium!;
  TextStyle get titleSmall => Theme.of(this).textTheme.titleSmall!;

  TextStyle get bodyLarge => Theme.of(this).textTheme.bodyLarge!;
  TextStyle get bodyMedium => Theme.of(this).textTheme.bodyMedium!;
  TextStyle get bodySmall => Theme.of(this).textTheme.bodySmall!;

}
