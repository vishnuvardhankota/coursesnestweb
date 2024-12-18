import 'package:coursesnest/utils/paths.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget tabView;
  final Widget desktopView;
  const ResponsiveLayout(
      {super.key,
      required this.tabView,
      required this.desktopView});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > 1024 ? desktopView : tabView;
  }
}
