import "package:coursesnest/utils/paths.dart";

class InstructorSidebar extends StatelessWidget {
  final String currentPath;
  final bool isExpanded;
  const InstructorSidebar(
      {super.key, required this.currentPath, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    // var userProvider = Provider.of<UserProvider>(context);
    return Container(
      width: isExpanded ? 250 : null,
      height: double.maxFinite,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: isExpanded
                ? Text("Instructor", style: GoogleFonts.lilitaOne(fontSize: 30))
                : const Icon(Icons.person, size: 35),
          ),
          NavigationTile(
              icon: Icons.dashboard,
              text: "Dashboard",
              path: currentPath,
              navigateTo: dashboardPath,
              isExpanded: isExpanded),
          NavigationTile(
              icon: Icons.ondemand_video,
              text: "My Courses",
              path: currentPath,
              navigateTo: instructorCoursesPath,
              isExpanded: isExpanded),
          NavigationTile(
              icon: Icons.contact_page_outlined,
              text: "Basic Details",
              path: currentPath,
              navigateTo: instructorProfilePath,
              isExpanded: isExpanded),
          NavigationTile(
              icon: Icons.logout,
              text: "Logout",
              path: currentPath,
              navigateTo: logoutPath,
              isExpanded: isExpanded)
        ],
      ),
    );
  }
}

class InstructorOptionsDrawer extends StatelessWidget {
  final String currentPath;
  const InstructorOptionsDrawer({super.key, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          Consumer<UserProvider>(builder: (context, userprovider, snapshot) {
            var currentUser = userprovider.currentUser;
            return DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (currentUser == null || currentUser['photoURL'] == null)
                        ? const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.person, size: 40),
                          )
                        : CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              currentUser['photoURL'],
                            ),
                            child: const Icon(Icons.person,
                                size: 40, color: Colors.transparent),
                          ),
                    const SizedBox(height: 10),
                    Text(
                      currentUser?['userName']?.split(",")[0] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      currentUser?['email'] ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ));
          }),
          ListTile(
            onTap: () {
              if (currentPath == dashboardPath) {
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                context.go(dashboardPath);
              }
            },
            title: const Text("Dashboard"),
          ),
          ListTile(
            onTap: () async {
              if (currentPath == instructorCoursesPath) {
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                context.go(instructorCoursesPath);
              }
            },
            title: const Text("My Courses"),
          ),
          ListTile(
            onTap: () {
              if (currentPath == instructorProfilePath) {
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                context.go(instructorProfilePath);
              }
            },
            title: const Text("Profile"),
          ),
          ListTile(
            onTap: () async {
              Navigator.pop(context);
              Provider.of<UserProvider>(context, listen: false)
                  .deactivateStreams();
              Provider.of<InstructorCourseProvider>(context, listen: false)
                  .deactivateStreams();
              await Provider.of<AuthServiceProvider>(context, listen: false)
                  .signout();
              // ignore: use_build_context_synchronously
              context.replace(homePath);
            },
            title: const Text("Logout"),
            trailing: const Icon(Icons.logout),
          )
        ],
      ),
    );
  }
}
