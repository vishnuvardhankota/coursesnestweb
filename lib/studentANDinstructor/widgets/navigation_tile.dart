import 'package:coursesnest/utils/paths.dart';

class NavigationTile extends StatefulWidget {
  final IconData icon;
  final String text;
  final String path;
  final String navigateTo;
  final bool isExpanded;
  const NavigationTile(
      {super.key,
      required this.icon,
      required this.text,
      required this.path,
      required this.navigateTo,
      required this.isExpanded});

  @override
  State<NavigationTile> createState() => _NavigationTileState();
}

class _NavigationTileState extends State<NavigationTile> {
  bool onHover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (widget.path != widget.navigateTo)
          ? () async {
              if (widget.navigateTo == logoutPath) {
                var userType = FirebaseAuth.instance.currentUser!.displayName!
                    .split(",")[1];
                if (userType == dotenv.env['STUDENT_TYPE']!) {
                  Provider.of<UserProvider>(context, listen: false)
                      .deactivateStreams();
                } else if (userType == dotenv.env['INSTRUCTOR_TYPE']!) {
                  Provider.of<UserProvider>(context, listen: false)
                      .deactivateStreams();
                  Provider.of<InstructorCourseProvider>(context, listen: false)
                      .deactivateStreams();
                }
                await Provider.of<AuthServiceProvider>(context, listen: false)
                    .signout();
                // ignore: use_build_context_synchronously
                context.go(homePath);
              } else {
                context.go(widget.navigateTo);
              }
            }
          : null,
      onHover: (value) {
        setState(() {
          onHover = value;
        });
      },
      child: Card(
        color: (widget.path == widget.navigateTo)
            ? const Color(0xFF5022C3)
            : onHover
                ? Colors.blue
                : null,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(widget.icon,
                  size: 30,
                  color: (widget.path == widget.navigateTo)
                      ? Colors.white
                      : onHover
                          ? Colors.white
                          : null),
              if (widget.isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(widget.text,
                      style: GoogleFonts.rubik(
                          fontSize: 20,
                          color: (widget.path == widget.navigateTo)
                              ? Colors.white
                              : onHover
                                  ? Colors.white
                                  : null)),
                )
            ],
          ),
        ),
      ),
    );
  }
}
