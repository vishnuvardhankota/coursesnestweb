import 'package:coursesnest/utils/paths.dart';

class MyCoursesPage extends StatelessWidget {
  final String? path;
  const MyCoursesPage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          drawer: UserOptionsDrawer(currentPath: path!),
          appBar: responsiveTopBar(context, path: path),
          body: LayoutBuilder(
            builder: (context, constraints) {
              bool isDesktop = constraints.maxWidth > 1024;
              return Row(
                children: [
                  if (constraints.maxWidth > 600)
                    Sidebar(currentPath: path!, isExpanded: isDesktop),
                  const Expanded(child: SizedBox())
                ],
              );
            },
          )),
    );
  }
}
