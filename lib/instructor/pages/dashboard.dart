import 'package:coursesnest/utils/paths.dart';

class DashboardPage extends StatelessWidget {
  final String? path;
  const DashboardPage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          drawer: InstructorOptionsDrawer(currentPath: path!),
          appBar: responsiveInstructorTopBar(context, path: path),
          body: LayoutBuilder(
            builder: (context, constraints) {
              bool isDesktop = constraints.maxWidth > 1024;
              return Row(
                children: [
                  if (constraints.maxWidth > 600)
                    InstructorSidebar(currentPath: path!, isExpanded: isDesktop),
                  const Expanded(child: SizedBox())
                ],
              );
            },
          )),
    );
  }
}
