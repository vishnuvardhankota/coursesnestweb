import 'package:coursesnest/utils/paths.dart';

class CourseDetailPage extends StatefulWidget {
  final String? path;
  final String? courseId;
  const CourseDetailPage(
      {super.key, required this.path, required this.courseId});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  bool isLoading = true;
  Map<String, dynamic>? course;
  List<Map<String, dynamic>> modules = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((v) {
      getData();
    });
  }

  getData() async {
    setState(() {
      course = ccourse;
      if (course != null) {
        modules = course!['modules'];
      }
      isLoading = false;
    });
  }

  String getCourseSummary(List<Map<String, dynamic>> modules) {
    int sectionCount = modules.length;
    int lectureCount = 0;
    int totalDuration = 0;

    // Iterate through each module
    for (var module in modules) {
      List<Map<String, dynamic>> topics =
          module['lectures'] as List<Map<String, dynamic>>;
      lectureCount += topics.length;

      // Sum up the durations of each topic
      for (var topic in topics) {
        totalDuration += topic['duration'] as int;
      }
    }

    // Convert total duration into hours and minutes
    int hours = totalDuration ~/ 3600; // 1 hour = 3600 seconds
    int minutes =
        (totalDuration % 3600) ~/ 60; // Remaining seconds converted to minutes

    // Return the formatted result
    return "$sectionCount sections, $lectureCount lectures, ${hours}h ${minutes}m length";
  }

  String getCourseDuration(List<Map<String, dynamic>> modules) {
    int totalDuration = 0;

    // Iterate through each module
    for (var module in modules) {
      List<Map<String, dynamic>> topics =
          module['lectures'] as List<Map<String, dynamic>>;

      // Sum up the durations of each topic
      for (var topic in topics) {
        totalDuration += topic['duration'] as int;
      }
    }

    // Convert total duration into hours and minutes
    int hours = totalDuration ~/ 3600; // 1 hour = 3600 seconds
    int minutes =
        (totalDuration % 3600) ~/ 60; // Remaining seconds converted to minutes

    // Return the formatted result
    return "${hours}h ${minutes}m";
  }

  double _calculateAverageRating(List<Map<String, dynamic>> ratings) {
    if (ratings.isEmpty) {
      return 0.0; // Return 0 if there are no ratings
    }
    double totalRating = ratings.fold(
        // ignore: avoid_types_as_parameter_names
        0.0,
        // ignore: avoid_types_as_parameter_names
        (sum, rating) => sum + (rating['rating'] as num).toDouble());
    return totalRating / ratings.length;
  }

  Widget thumbnail({double? width}) {
    return Image.network(
      width: width,
      course!['courseImage'],
      fit: BoxFit.fitWidth,
    );
  }

  Widget titleAndDescription(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          course!['courseTitle'],
          style: GoogleFonts.lilitaOne(
              fontSize: isMobile
                  ? context.courseSmallTitle.fontSize
                  : context.courseLargeTitle.fontSize),
        ),
        SizedBox(height: isMobile ? 5 : 8),
        SelectableText(
          course!['courseDescription'],
          style: GoogleFonts.sourceSans3(
              fontSize: isMobile
                  ? context.courseSmallDescription.fontSize
                  : context.courseLargeDescription.fontSize),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 15 : 20),
            child: (course!['skillset'] as List<String>).length < 5
                ? Wrap(
                    children: (course!['skillset'] as List<String>)
                        .map((skill) => Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 8 : 15,
                                  vertical: isMobile ? 5 : 10),
                              child: Image.asset("$skill.png",
                                  height: isMobile ? 50 : 70),
                            ))
                        .toList(),
                  )
                : instructor(isMobile)),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Wrap(
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Language: ",
                    style: GoogleFonts.sourceSans3(
                        fontSize: context.courseSmallDescription.fontSize)),
                TextSpan(
                    text: course!['language'],
                    style: GoogleFonts.sourceSans3(
                        fontWeight: FontWeight.bold,
                        fontSize: context.courseSmallDescription.fontSize))
              ])),
              const SizedBox(width: 10),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Last Updated: ",
                    style: GoogleFonts.sourceSans3(
                        fontSize: context.courseSmallDescription.fontSize)),
                TextSpan(
                    text: course!['lastUpdated'],
                    style: GoogleFonts.sourceSans3(
                        fontWeight: FontWeight.bold,
                        fontSize: context.courseSmallDescription.fontSize))
              ]))
            ],
          ),
        )
      ],
    );
  }

  Widget instructor(bool isMobile) {
    return Row(
      children: [
        CircleAvatar(radius: isMobile ? 17 : 22, backgroundColor: Colors.green),
        const SizedBox(width: 8),
        InkWell(
            onTap: () {
              //
            },
            child: SelectableText("Vishnu Vardhan",
                style: GoogleFonts.sourceSans3(
                    fontSize: isMobile
                        ? context.courseSmallDescription.fontSize
                        : context.courseLargeDescription.fontSize,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue)))
      ],
    );
  }

  Widget priceAndPurchaseButton(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("₹${course!['selling_price']}",
                style: TextStyle(
                    fontSize: isMobile ? 24 : 30, fontWeight: FontWeight.bold)),
        StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Check if the user is logged in
            final isLoggedIn = snapshot.hasData;
            final currentUserId = snapshot.data?.uid;

            return InkWell(
              onTap: () {
                if (!isLoggedIn) {
                  // If not logged in, route to login page
                  context.go(loginPath);
                } else {
                  // Check if user is in the enrolled list
                  final isEnrolled = course!['enrolled'].any(
                      (enrollment) => enrollment['userId'] == currentUserId);

                  if (isEnrolled) {
                    // If enrolled, route to course page
                    context.go('/courses');
                  } else {
                    // If not enrolled, route to cart page
                    context.go('/cart');
                  }
                }
              },
              child: Container(
                height: 45,
                width: isMobile ? 550 : 400,
                color: !isLoggedIn
                    ? Colors.blue
                    : course!['enrolled'].any((enrollment) =>
                            enrollment['userId'] == currentUserId)
                        ? Colors.green
                        : Colors.blue,
                child: Center(
                  child: Text(
                    !isLoggedIn
                        ? "Buy Now"
                        : course!['enrolled'].any((enrollment) =>
                                enrollment['userId'] == currentUserId)
                            ? "Go to course"
                            : "Buy Now",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget courseDetails(bool isMobile, {double? width}) {
    final List<Map<String, dynamic>> data = [
      {
        "value": course!['enrolled'].length.toString(),
        "label": "Enrolled",
      },
      {
        "value": _calculateAverageRating(
                course!['ratings'] as List<Map<String, dynamic>>)
            .toStringAsFixed(1),
        "label": "Ratings",
      },
      {
        "value": course!['projects'].length.toString(),
        "label": "Projects",
      },
      // {
      //   "value": getCourseDuration(modules),
      //   "label": "Duration",
      // }
    ];
    return isMobile
        ? Container(
            width: width,
            decoration: BoxDecoration(
                color: Colors.blue[400],
                borderRadius: BorderRadius.circular(18)),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columnWidth =
                    constraints.maxWidth / 2 - 16; // Two columns
                return Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: data.map((item) {
                    return SizedBox(
                      width: columnWidth,
                      height: columnWidth * 0.6,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(item['value'],
                                style: GoogleFonts.lilitaOne(
                                    color: Colors.white,
                                    fontSize: constraints.maxWidth < 450
                                        ? context.courseSmallTitle.fontSize
                                        : context.courseLargeTitle.fontSize)),
                            const SizedBox(width: 8),
                            Text(
                              item['label'],
                              style: GoogleFonts.sourceSans3(
                                  color: Colors.white,
                                  fontSize: constraints.maxWidth < 450
                                      ? context.courseSmallDescription.fontSize
                                      : context
                                          .courseLargeDescription.fontSize),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 100, // Adjust height based on layout
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.blue[400],
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: data
                    .map((item) => Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(item['value'],
                                  style: GoogleFonts.lilitaOne(
                                      color: Colors.white,
                                      fontSize: constraints.maxWidth < 650
                                          ? context.courseSmallTitle.fontSize
                                          : context.courseLargeTitle.fontSize)),
                              const SizedBox(width: 8),
                              Text(
                                item['label'],
                                style: GoogleFonts.sourceSans3(
                                    color: Colors.white,
                                    fontSize: constraints.maxWidth < 650
                                        ? context
                                            .courseSmallDescription.fontSize
                                        : context
                                            .courseLargeDescription.fontSize),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              );
            }),
          );
  }

  Widget courseOverview(bool isMobile) {
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        color: Colors.white,
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10 : 20, vertical: isMobile ? 10 : 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("What you will learn!",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: isMobile
                          ? context.courseSmallTopicHeading.fontSize
                          : context.courseLargeTopicHeading.fontSize)),
              SizedBox(height: isMobile ? 12 : 20),
              constraints.maxWidth < 700
                  ? Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children:
                          (course!['overview'] as List<String>).map((overview) {
                        return SizedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check,
                                size: isMobile ? 16 : 25,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  overview,
                                  style: GoogleFonts.openSans(
                                      fontSize: isMobile ? 14 : 18),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList())
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final columnWidth =
                            constraints.maxWidth / 2 - 16; // Two columns
                        return Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children:
                              (course!['overview'] as List<String>).map((item) {
                            return SizedBox(
                              width: columnWidth,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check,
                                    size: isMobile ? 16 : 25,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item,
                                      style: GoogleFonts.openSans(
                                          fontSize: isMobile ? 14 : 18),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
            ],
          ),
        ),
      );
    });
  }

  Widget modulesWidget(bool isMobile) {
    return Center(
      child: SizedBox(
        width: 1024,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Course Content",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: isMobile
                        ? context.courseSmallTopicHeading.fontSize
                        : context.courseLargeTopicHeading.fontSize)),
            SizedBox(height: isMobile ? 10 : 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 20),
              child: Text(getCourseSummary(modules),
                  style: GoogleFonts.robotoCondensed(
                      fontSize: isMobile
                          ? context.courseSmallTopicDetails.fontSize
                          : context.courseLargeTopicDetails.fontSize)),
            ),
            ...modules.map((module) {
              return ContentExpansionTile(
                isMobile: isMobile,
                module: module,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget instructorDetails() {
    return const Card();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 242, 246, 253),
        appBar: responsiveTopBar(context, path: widget.path),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 550;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // Top section on blue container
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 10 : 25),
                        color: Colors.white,
                        child: Center(
                          child: ResponsiveLayout(
                              tabView: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 7 : 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 30),
                                    titleAndDescription(isMobile),
                                    priceAndPurchaseButton(isMobile),
                                    const SizedBox(height: 30),
                                  ],
                                ),
                              ),
                              desktopView: Container(
                                padding:
                                    const EdgeInsets.only(top: 55, bottom: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 6,
                                            child: FractionallySizedBox(
                                              widthFactor: 0.9,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  titleAndDescription(isMobile),
                                                  priceAndPurchaseButton(
                                                      isMobile)
                                                ],
                                              ),
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: FractionallySizedBox(
                                                widthFactor: 0.95,
                                                child: Image.asset(
                                                  "assets/PythonL.png",
                                                  height: 350,
                                                ))),
                                      ],
                                    ),
                                    // enrolledRatingsDetails(isMobile)
                                  ],
                                ),
                              )),
                        ),
                      ),
                      // second sectiion
                      ResponsiveLayout(
                          tabView: Column(
                            children: [
                              if (isMobile) const SizedBox(height: 15),
                              courseDetails(isMobile),
                              if (isMobile) const SizedBox(height: 15),
                              courseOverview(isMobile)
                            ],
                          ),
                          desktopView: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 40, horizontal: 30),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: 400, child: courseDetails(true)),
                                const SizedBox(width: 20),
                                Expanded(child: courseOverview(isMobile))
                              ],
                            ),
                          )),
                      SizedBox(height: isMobile ? 15 : 25),
                      // Course Content Section
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 10 : 20),
                          width: 1120,
                          child: modulesWidget(isMobile)),
                    
                    ],
                  ),
                );
              }),
      ),
    );
  }
}
