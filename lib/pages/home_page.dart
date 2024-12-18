import 'package:coursesnest/utils/paths.dart';

class HomePage extends StatelessWidget {
  final String? path;
  const HomePage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: UserOptionsDrawer(currentPath: path!),
        appBar: responsiveTopBar(context, path: path),
      ),
    );
  }
}
