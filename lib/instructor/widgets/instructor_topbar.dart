import "package:coursesnest/utils/paths.dart";

// As appbar
PreferredSizeWidget responsiveInstructorTopBar(BuildContext context,
    {String? path}) {
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
            ],
          ),
        );
      },
    ),
  );
}
