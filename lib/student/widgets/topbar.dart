import "package:coursesnest/utils/paths.dart";

var profilePaths = [profilePath, wishlistPath, myCoursesPath];
// As appbar
PreferredSizeWidget responsiveTopBar(BuildContext context, {String? path}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(80),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isDesktop = screenWidth > 1024;
        final isTablet = screenWidth > 600;

        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: isDesktop
                  ? 32
                  : isTablet
                      ? 22
                      : 15),
          height: isDesktop
              ? 80
              : isTablet
                  ? 70
                  : 56,
          color: const Color(0xFF5022C3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Section
              Row(
                children: [
                  if (!isTablet) // Display menu button for smaller screens
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  if (isTablet)
                    Container(
                      width: isDesktop ? 60 : 50,
                      height: isDesktop ? 60 : 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(dotenv.env['ORGANIZATION_LOGO']!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: isTablet
                        ? () {
                            if (path != '/') context.go('/');
                          }
                        : null,
                    child: Text(
                      dotenv.env['ORGANIZATION_NAME']!,
                      style: GoogleFonts.montserratSubrayada(
                        color: Colors.white,
                        fontSize: isDesktop
                            ? 36
                            : isTablet
                                ? 30
                                : 24,
                      ),
                    ),
                  ),
                ],
              ),
              // Right Section
              if (isTablet)
                if (!profilePaths.contains(path))
                  StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      final isLoggedIn = snapshot.data != null;
                      final name = isLoggedIn
                          ? snapshot.data!.displayName!.split(",")[0]
                          : "";
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      }
                      return isLoggedIn
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isDesktop)
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                    ),
                                  ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    context.go(profilePath);
                                  },
                                  child: snapshot.data!.photoURL == null
                                      ? const CircleAvatar(
                                          radius: 20,
                                          child: Icon(Icons.person),
                                        )
                                      : CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                            snapshot.data!.photoURL!,
                                          ),
                                          child: const Icon(Icons.person,
                                              color: Colors.transparent),
                                        ),
                                ),
                              ],
                            )
                          : ElevatedButton(
                              onPressed: () {
                                context.go(loginPath);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                    },
                  ),
            ],
          ),
        );
      },
    ),
  );
}
