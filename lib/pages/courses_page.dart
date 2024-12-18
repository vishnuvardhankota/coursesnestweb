import 'package:coursesnest/utils/paths.dart';

class CoursesPage extends StatelessWidget {
  final String? path;
  final String? searchText;
  const CoursesPage({super.key, required this.path, this.searchText});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: UserOptionsDrawer(currentPath: path!),
        appBar: responsiveTopBar(context, path: path),
        body: Center(child: Text(searchText ?? "")),
      ),
    );
  }
}
