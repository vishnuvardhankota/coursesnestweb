import 'package:coursesnest/utils/paths.dart';

class InstructorCoursesPage extends StatefulWidget {
  final String? path;
  const InstructorCoursesPage({super.key, required this.path});

  @override
  State<InstructorCoursesPage> createState() => _InstructorCoursesPageState();
}

class _InstructorCoursesPageState extends State<InstructorCoursesPage> {
  Widget thumbnailWidget(bool isMobile, {String? url}) {
    return AspectRatio(
        aspectRatio: isMobile ? 16 / 10 : 16 / 9,
        child: url == null
            ? Container(
                color: Colors.grey,
                child: const Center(child: Icon(Icons.photo, size: 100)))
            : Image.network(url));
  }

  Widget titleTextWidget(String text, bool isMobile) {
    return Text(
      overflow: TextOverflow.ellipsis,
      text,
      style: GoogleFonts.lilitaOne(
          fontSize: isMobile
              ? context.courseSmallDescription.fontSize
              : context.courseLargeDescription.fontSize),
    );
  }

  Widget descriptionTextWidget(String text, bool isMobile) {
    return Text(
      overflow: TextOverflow.ellipsis,
      text,
      style: GoogleFonts.sourceSans3(
          fontSize: isMobile
              ? context.courseSmallTopicDetails.fontSize
              : context.courseLargeTopicDetails.fontSize),
    );
  }

  Widget editButton(String courseId) {
    return InkWell(
      onTap: () {
        String encodedText = base64Encode(utf8.encode(courseId));
        var path = "$instructorCoursesPath?manage=$encodedText";
        context.go(path);
      },
      child: Container(
        color: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: const Center(
          child: Text(
            "Edit course",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget courseWidget(bool isMobile, Map<String, dynamic> course) {
    return isMobile
        ? Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  thumbnailWidget(isMobile, url: course['courseThumbnail']),
                  const SizedBox(height: 10),
                  titleTextWidget(course['courseTitle'], isMobile),
                  descriptionTextWidget(course['courseDescription'], isMobile),
                  const SizedBox(height: 10),
                  editButton(course['id'])
                ],
              ),
            ),
          )
        : SizedBox(
            height: 150,
            width: double.infinity,
            child: Card(
              child: Row(
                children: [
                  thumbnailWidget(isMobile, url: course['courseThumbnail']),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titleTextWidget(course['courseTitle'], isMobile),
                            descriptionTextWidget(
                                course['courseDescription'], isMobile),
                          ],
                        ),
                        editButton(course['id'])
                      ],
                    ),
                  ))
                ],
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          drawer: InstructorOptionsDrawer(currentPath: widget.path!),
          appBar: responsiveInstructorTopBar(context, path: widget.path),
          body: LayoutBuilder(
            builder: (context, constraints) {
              bool isDesktop = constraints.maxWidth > 1024;
              bool isMobile = constraints.maxWidth <= 600;
              return Row(
                children: [
                  if (constraints.maxWidth > 600)
                    InstructorSidebar(
                        currentPath: widget.path!, isExpanded: isDesktop),
                  Expanded(
                      child: SizedBox(
                    child: Column(
                      children: [
                        InkWell(
                            onTap: () {
                              context.go(createCoursesPath);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              color: Colors.blue,
                              child: const Center(
                                child: Text(
                                  "Create New Course",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("My courses"),
                              const Divider(),
                              Consumer<InstructorCourseProvider>(
                                  builder: (contect, courseProvider, child) {
                                if (courseProvider.courses.isEmpty) {
                                  return const SizedBox(
                                      height: 100,
                                      child: Center(
                                          child: Text("No courses available")));
                                } else {
                                  return Column(
                                    children:
                                        courseProvider.courses.map((course) {
                                      return courseWidget(isMobile, course);
                                    }).toList(),
                                  );
                                }
                              })
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
                ],
              );
            },
          )),
    );
  }
}
