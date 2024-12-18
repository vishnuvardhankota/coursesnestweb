import 'package:coursesnest/utils/paths.dart';

class CheckoutPage extends StatelessWidget {
  final String? path;
  final String courseId;
  const CheckoutPage({super.key, required this.path, required this.courseId});

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
