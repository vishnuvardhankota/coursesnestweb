import 'package:coursesnest/utils/paths.dart';
import 'package:intl/intl.dart';

class ManageCoursePage extends StatefulWidget {
  final String courseId;
  const ManageCoursePage({super.key, required this.courseId});

  @override
  State<ManageCoursePage> createState() => _ManageCoursePageState();
}

class _ManageCoursePageState extends State<ManageCoursePage> {
  Map<String, dynamic>? course;
  bool editMode = true;
  bool overviewReorder = false;
  final overviewFocusNode = FocusNode();
  final tdformKey = GlobalKey<FormState>();
  final priceformKey = GlobalKey<FormState>();
  final overviewformKey = GlobalKey<FormState>();
  final moduleformKey = GlobalKey<FormState>();
  TextEditingController moduleController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController overviewController = TextEditingController();

  List<dynamic> overview = [];
  List<dynamic> skillset = [];
  List<Map<String, dynamic>> modules = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    readCourseFromProvider();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    overviewController.dispose();
    overviewFocusNode.dispose();
    super.dispose();
  }

  void readCourseFromProvider() {
    final provider = Provider.of<InstructorCourseProvider>(context);
    // Check if the course with courseId exists in the list
    final isCoursePresent =
        provider.courses.any((c) => c['id'] == widget.courseId);
    if (isCoursePresent) {
      setState(() {
        course = provider.courses
            .firstWhere((course) => course['id'] == widget.courseId);
        titleController.text = course?['courseTitle'];
        descriptionController.text = course?['courseDescription'];
        priceController.text = course!['selling_price'].toString();

        overview = course?['overview'] ?? <dynamic>[];
        skillset = course?['skillset'] ?? <dynamic>[];
        // Safely access the modules field and ensure it is a list of maps
        modules = (course?['modules'] as List<dynamic>?)
                ?.map((module) => module as Map<String, dynamic>)
                .toList() ??
            <Map<String, dynamic>>[];
      });
    }
  }

  String getCourseSummary(List<Map<String, dynamic>> modules) {
    int sectionCount = modules.length;
    int lectureCount = 0;
    int totalDuration = 0;

    // Iterate through each module
    for (var module in modules) {
      List<Map<String, dynamic>> topics =
          (module['lectures'] as List<dynamic>).isEmpty
              ? <Map<String, dynamic>>[]
              : module['lectures'] as List<Map<String, dynamic>>;
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

  Widget instructor(bool isMobile) {
    var currentUser = FirebaseAuth.instance.currentUser;
    return Row(
      children: [
        currentUser!.photoURL == null
            ? CircleAvatar(
                radius: isMobile ? 17 : 22,
                child: const Icon(Icons.person),
              )
            : CircleAvatar(
                radius: isMobile ? 17 : 22,
                backgroundImage: NetworkImage(currentUser.photoURL!),
              ),
        const SizedBox(width: 8),
        InkWell(
            onTap: () {},
            child: Text(currentUser.displayName!.split(",")[0],
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

  Widget titleAndDescription(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        editMode
            ? Form(
                key: tdformKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: titleController,
                      maxLength: 60,
                      style: GoogleFonts.lilitaOne(
                        fontSize: isMobile
                            ? context.courseSmallTitle.fontSize
                            : context.courseLargeTitle.fontSize,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter course title',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: isMobile
                              ? context.courseSmallTitle.fontSize
                              : context.courseLargeTitle.fontSize,
                        ),
                        counterText: '',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: isMobile ? 5 : 8),
                    TextFormField(
                      controller: descriptionController,
                      maxLength: 130,
                      style: GoogleFonts.sourceSans3(
                        fontSize: isMobile
                            ? context.courseSmallDescription.fontSize
                            : context.courseLargeDescription.fontSize,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter course description',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: isMobile
                              ? context.courseSmallDescription.fontSize
                              : context.courseLargeDescription.fontSize,
                        ),
                        counterText: '', // Removes character counter display
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    )
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    course?['courseTitle'],
                    style: GoogleFonts.lilitaOne(
                      fontSize: isMobile
                          ? context.courseSmallTitle.fontSize
                          : context.courseLargeTitle.fontSize,
                    ),
                  ),
                  SizedBox(height: isMobile ? 5 : 8),
                  SelectableText(
                    course?['courseDescription'],
                    style: GoogleFonts.sourceSans3(
                      fontSize: isMobile
                          ? context.courseSmallDescription.fontSize
                          : context.courseLargeDescription.fontSize,
                    ),
                  ),
                ],
              ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 15 : 20),
            child: (skillset.isNotEmpty && skillset.length < 5)
                ? Wrap(
                    children: skillset
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
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              editMode
                  ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text("Language: ",
                            style: GoogleFonts.sourceSans3(
                                fontSize:
                                    context.courseSmallDescription.fontSize)),
                        SizedBox(
                          width: 200,
                          height: 40,
                          child: DropdownButtonFormField<String>(
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            hint: Text(
                              "Select",
                              style: GoogleFonts.sourceSans3(
                                fontSize:
                                    context.courseSmallDescription.fontSize,
                              ),
                            ),
                            value: course?['language'],
                            items: courseLanguages.map((lang) {
                              return DropdownMenuItem<String>(
                                value: lang,
                                child: Text(
                                  lang,
                                  style: GoogleFonts.sourceSans3(
                                    fontSize:
                                        context.courseSmallDescription.fontSize,
                                  ),
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                course?['language'] = value;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Language: ",
                            style: GoogleFonts.sourceSans3(
                                fontSize:
                                    context.courseSmallDescription.fontSize)),
                        TextSpan(
                            text: course?['language'],
                            style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    context.courseSmallDescription.fontSize))
                      ]),
                    ),
              const SizedBox(width: 10),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Last Updated: ",
                    style: GoogleFonts.sourceSans3(
                        fontSize: context.courseSmallDescription.fontSize)),
                TextSpan(
                    text: DateFormat('dd-MM-yyyy').format(
                        (course?['lastUpdated'] as Timestamp?)?.toDate() ??
                            DateTime.now()),
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

  Widget priceAndPurchaseButton(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        editMode
            ? SizedBox(
                width: 200,
                child: Form(
                  key: priceformKey,
                  child: TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Allow only integers
                    ],
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 30,
                    ),
                    decoration: InputDecoration(
                      prefixText: '₹', // Rupee symbol as prefix
                      prefixStyle: TextStyle(
                        fontSize: isMobile ? 24 : 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Enter price',
                      hintStyle: TextStyle(
                        fontSize: isMobile ? 24 : 30,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      return null;
                    },
                  ),
                ),
              )
            : Text("₹${course?['selling_price']}",
                style: TextStyle(
                    fontSize: isMobile ? 20 : 30, fontWeight: FontWeight.bold)),
        InkWell(
          onTap: () {
            if (editMode == false) {
              setState(() {
                editMode = true;
              });
            } else {
              if (tdformKey.currentState!.validate() &&
                  priceformKey.currentState!.validate()) {
                if (course?['language'] == null) {
                  showErrorToast(
                      context, isMobile, "Please select content language");
                  return;
                }
                setState(() {
                  course?['courseTitle'] = titleController.text.trim();
                  course?['courseDescription'] =
                      descriptionController.text.trim();
                  course?['selling_price'] =
                      int.parse(priceController.text.trim());
                  course?['overview'] = overview;
                  course?['modules'] = modules;
                  editMode = false;
                });
              }
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 3),
            height: 45,
            width: isMobile ? 550 : 400,
            color: Colors.blue,
            child: const Center(
              child: Text(
                "Buy Now",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget courseDetails(bool isMobile, {double? width}) {
    final List<Map<String, dynamic>> data = [
      {
        "value": "X",
        "label": "Enrolled",
      },
      {
        "value": "Y",
        "label": "Ratings",
      },
      {
        "value": "Z",
        "label": "Projects",
      },
      {
        "value": "Xh Ym",
        "label": "Duration",
      }
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
              if (course?['overview'] != null)
                constraints.maxWidth < 700
                    ? Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: (course?['overview'] as List<dynamic>)
                            .map((overview) {
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
                            children: (course?['overview'] as List<dynamic>)
                                .map((item) {
                              return SizedBox(
                                width: columnWidth,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    editMode
                                        ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                List<String> list =
                                                    course?['overview'];
                                                list.remove(item);
                                                course?['overview'] = list;
                                              });
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              size: isMobile ? 16 : 25,
                                              color: Colors.red,
                                            ),
                                          )
                                        : Icon(
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

  Widget addCourseOverviews(bool isMobile) {
    return SizedBox(
      width: 800,
      child: LayoutBuilder(builder: (context, constraints) {
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
                if (overview.isNotEmpty && overview.length > 1)
                  Row(
                    children: [
                      Text("Enable Re-ordering",
                          style: GoogleFonts.poppins(
                              fontSize: isMobile ? 15 : 20)),
                      Switch(
                          value: overviewReorder,
                          onChanged: (onChanged) {
                            setState(() {
                              overviewReorder = !overviewReorder;
                            });
                          })
                    ],
                  ),
                SizedBox(height: isMobile ? 12 : 20),
                // Make ListView draggable
                overviewReorder
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: overview.length,
                        itemBuilder: (context, index) {
                          String currentOverview = overview[index];
                          return Draggable<String>(
                            data: currentOverview,
                            feedback: Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                width: constraints.maxWidth,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.arrow_forward,
                                      size: isMobile ? 16 : 25,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        currentOverview,
                                        style: GoogleFonts.openSans(
                                            fontSize: isMobile ? 14 : 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            childWhenDragging: SizedBox(
                              width: constraints.maxWidth,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.arrow_forward,
                                    size: isMobile ? 16 : 25,
                                    color: Colors.transparent,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      currentOverview,
                                      style: GoogleFonts.openSans(
                                          color: Colors.transparent,
                                          fontSize: isMobile ? 14 : 18),
                                    ),
                                  ),
                                ],
                              ),
                            ), // Hides item while dragging
                            child: DragTarget<String>(
                              onAcceptWithDetails: (draggedItem) {
                                setState(() {
                                  // Reorder items
                                  overview.remove(draggedItem.data);
                                  overview.insert(index, draggedItem.data);
                                });
                              },
                              builder: (context, candidateData, rejectedData) {
                                return SizedBox(
                                  width: constraints.maxWidth,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.arrow_forward,
                                        size: isMobile ? 16 : 25,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          currentOverview,
                                          style: GoogleFonts.openSans(
                                              fontSize: isMobile ? 14 : 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: overview.map((item) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    overview.remove(item);
                                  });
                                },
                                child: Icon(
                                  Icons.delete,
                                  size: isMobile ? 16 : 25,
                                  color: Colors.red,
                                ),
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
                          );
                        }).toList(),
                      ),
                if (!overviewReorder)
                  Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: isMobile ? 35 : 45,
                              child: Form(
                                key: overviewformKey,
                                child: TextFormField(
                                  controller: overviewController,
                                  maxLength: 120,
                                  focusNode: overviewFocusNode,
                                  style: GoogleFonts.openSans(
                                      fontSize: isMobile ? 14 : 18),
                                  decoration: InputDecoration(
                                    hintText: 'Enter course description',
                                    hintStyle: GoogleFonts.openSans(
                                        color: Colors.grey.shade500,
                                        fontSize: isMobile ? 14 : 18),
                                    counterText:
                                        '', // Removes character counter display
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius
                                          .zero, // No rounded corners
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius
                                          .zero, // No rounded corners
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius
                                          .zero, // No rounded corners
                                    ),
                                  ),
                                  onFieldSubmitted: (value) {
                                    if (value.trim().isNotEmpty) {
                                      setState(() {
                                        overview.add(value.trim());
                                        overviewController.clear();
                                      });
                                      overviewFocusNode.requestFocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                if (overviewController.text.trim().isNotEmpty) {
                                  setState(() {
                                    overview
                                        .add(overviewController.text.trim());
                                    overviewController.clear();
                                  });
                                  overviewFocusNode.requestFocus();
                                }
                              },
                              child: Container(
                                  height: isMobile ? 35 : 45,
                                  color: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: const Center(
                                    child: Text("Add",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  )))
                        ],
                      ),
                    ],
                  )
              ],
            ),
          ),
        );
      }),
    );
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
            if (modules.isNotEmpty)
              ...modules.map((module) {
                return ContentExpansionTile(
                  isMobile: isMobile,
                  module: module,
                );
              }),
            if (modules.isEmpty)
              const Card(
                  color: Colors.white,
                  child: SizedBox(
                    height: 100,
                    width: double.maxFinite,
                    child: Center(
                      child: Text("No Content Available"),
                    ),
                  ))
          ],
        ),
      ),
    );
  }

  void editSectionNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 600, // Custom width
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Add New Section',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Form(
                  key: moduleformKey,
                  child: TextFormField(
                    controller: moduleController,
                    decoration: const InputDecoration(
                      labelText: 'Section Name',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter Section name";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                    onTap: () {
                      if (moduleformKey.currentState!.validate()) {
                        setState(() {
                          modules.add({
                            "title": moduleController.text.trim(),
                            "lectures": []
                          });
                          moduleController.clear();
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                        color: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        child: const Center(
                            child: Text(
                          "Create",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ))))
              ],
            ),
          ),
        );
      },
    );
  }

  Widget editModules(bool isMobile) {
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
            if (modules.isNotEmpty)
              ...modules.map((module) {
                return EditContentExpansionTile(
                  isMobile: isMobile,
                  module: module,
                  onDeleteRequest: () {
                    int sectionIndex = modules.indexOf(module);
                    setState(() {
                      modules.removeAt(sectionIndex);
                    });
                  },
                  onUpdate: (updatedModule) {
                    int sectionIndex = modules.indexOf(module);
                    setState(() {
                      modules[sectionIndex] = updatedModule;
                    });
                  },
                );
              }),
            if (modules.isEmpty)
              const Card(
                  color: Colors.white,
                  child: SizedBox(
                    height: 100,
                    width: double.maxFinite,
                    child: Center(
                      child: Text("No Content Available"),
                    ),
                  )),
            InkWell(
              onTap: editSectionNameDialog,
              child: Card(
                color: Colors.white,
                child: SizedBox(
                  child: Center(
                    child: Text(
                      "Add new section",
                      style: GoogleFonts.robotoCondensed(
                          fontSize: isMobile
                              ? context.courseLargeTopicDetails.fontSize
                              : context.courseLargeDescription.fontSize),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth <= 600;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.brown[300],
                    height: isMobile ? 56 : 70,
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (tdformKey.currentState!.validate() &&
                                priceformKey.currentState!.validate()) {
                              // if (modules.isNotEmpty) {
                              //   for (var module in modules) {
                              //     if (module['lectures'].isEmpty) {
                              //       showWarningToast(context, isMobile,
                              //           "${module['title']} has no Lectures");
                              //       return;
                              //     }
                              //   }
                              // }
                              setState(() {
                                course?['courseTitle'] =
                                    titleController.text.trim();
                                course?['courseDescription'] =
                                    descriptionController.text.trim();
                                course?['selling_price'] =
                                    int.parse(priceController.text.trim());
                                course?['overview'] = overview;
                                course?['modules'] = modules;
                              });
                              await Provider.of<InstructorCourseProvider>(
                                      context,
                                      listen: false)
                                  .updateCourse(course!)
                                  .then((status) {
                                if (status == RequestStatus.success) {
                                  context.replace(instructorCoursesPath);

                                  showSuccessToast(
                                      context, isMobile, "Course Updated");
                                } else {
                                  showErrorToast(context, isMobile,
                                      "Something went wrong. try again");
                                }
                              });
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            color: const Color(0xFF5022C3),
                            child: Text(
                              isMobile ? "Update" : "Update Course",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: isMobile ? 17 : 22),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: isMobile ? 10 : 25),
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
                                if (constraints.maxWidth <= 1024)
                                  SizedBox(
                                      width: 400,
                                      child: Image.asset(
                                        "assets/image.png",
                                      )),
                                titleAndDescription(isMobile),
                                priceAndPurchaseButton(isMobile),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                          desktopView: Container(
                            padding: const EdgeInsets.only(top: 55, bottom: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              priceAndPurchaseButton(isMobile)
                                            ],
                                          ),
                                        )),
                                    Expanded(
                                        flex: 4,
                                        child: FractionallySizedBox(
                                            widthFactor: 0.95,
                                            child: Image.asset(
                                              "assets/image.png",
                                              height: 350,
                                            ))),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                  editMode
                      ? addCourseOverviews(isMobile)
                      : ResponsiveLayout(
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
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: isMobile ? 10 : 20),
                      width: 1120,
                      child: editMode
                          ? editModules(isMobile)
                          : modulesWidget(isMobile)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
