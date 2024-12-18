import 'package:coursesnest/utils/paths.dart';

class Sidebar extends StatelessWidget {
  final String currentPath;
  final bool isExpanded;
  const Sidebar(
      {super.key, required this.currentPath, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isExpanded ? 250 : null,
      height: double.maxFinite,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: isExpanded
                ? Text("Profile", style: GoogleFonts.lilitaOne(fontSize: 30))
                : const Icon(Icons.person, size: 35),
          ),
          NavigationTile(
              icon: Icons.contact_page_outlined,
              text: "Basic Details",
              path: currentPath,
              navigateTo: profilePath,
              isExpanded: isExpanded),
          NavigationTile(
              icon: Icons.favorite_outline,
              text: "Wishlist",
              path: currentPath,
              navigateTo: wishlistPath,
              isExpanded: isExpanded),
          NavigationTile(
              icon: Icons.ondemand_video,
              text: "My Courses",
              path: currentPath,
              navigateTo: myCoursesPath,
              isExpanded: isExpanded),
          NavigationTile(
              icon: Icons.logout,
              text: "Logout",
              path: currentPath,
              navigateTo: logoutPath,
              isExpanded: isExpanded),
        ],
      ),
    );
  }
}

class UserOptionsDrawer extends StatelessWidget {
  final String currentPath;
  const UserOptionsDrawer({super.key, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, snapshot) {
      var currentUser = userProvider.currentUser;
      final isLoggedIn = userProvider.currentUser != null;
      return Drawer(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: isLoggedIn
                  ? Column(
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
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          currentUser?['email'] ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ],
                    )
                  : Center(
                      child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go(loginPath);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 7),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Text("Login"),
                      ),
                    )),
            ),
            if (currentPath != homePath)
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  context.go(homePath);
                },
                title: const Text("Home"),
              ),
            if (isLoggedIn)
              ListTile(
                onTap: () {
                  if (currentPath == profilePath) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    context.go(profilePath);
                  }
                },
                title: const Text("Profile"),
              ),
            if (isLoggedIn)
              ListTile(
                onTap: () async {
                  if (currentPath == wishlistPath) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    context.go(wishlistPath);
                  }
                },
                title: const Text("Wishlist"),
              ),
            if (isLoggedIn)
              ListTile(
                onTap: () async {
                  if (currentPath == myCoursesPath) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    context.go(myCoursesPath);
                  }
                },
                title: const Text("My Courses"),
              ),
            ExpansionTile(
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              title: const Text("Search for"),
              shape: Border.all(color: Colors.transparent),
              children: courseCategories
                  .map((subOption) => ListTile(
                        title: Text(subOption,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        onTap: () {
                          var search = Uri.encodeQueryComponent(subOption);
                          var path = "$coursesPath?search=$search";
                          if (currentPath == path) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            context.go(path);
                          }
                        },
                      ))
                  .toList(),
            ),

            if (isLoggedIn)
              ListTile(
                onTap: () async {
                  Navigator.pop(context);
                  Provider.of<UserProvider>(context, listen: false)
                      .deactivateStreams();
                  await Provider.of<AuthServiceProvider>(context, listen: false)
                      .signout();
                  // ignore: use_build_context_synchronously
                  context.go(homePath);
                },
                title: const Text("Logout"),
                trailing: const Icon(Icons.logout),
              )
          ],
        ),
      );
    });
  }
}
