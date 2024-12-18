import 'package:coursesnest/utils/paths.dart';

class CreateCoursePage extends StatefulWidget {
  const CreateCoursePage({super.key});

  @override
  State<CreateCoursePage> createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  Map<String, dynamic> course = {};
  final tdformKey = GlobalKey<FormState>();
  final priceformKey = GlobalKey<FormState>();
  final overviewformKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController overviewController = TextEditingController();

  List<String> overviews = [];

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
        Form(
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
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 15 : 20),
            child: instructor(isMobile)),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text("Language: ",
                      style: GoogleFonts.sourceSans3(
                          fontSize: context.courseSmallDescription.fontSize)),
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: DropdownButtonFormField<String>(
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      hint: Text(
                        "Select",
                        style: GoogleFonts.sourceSans3(
                          fontSize: context.courseSmallDescription.fontSize,
                        ),
                      ),
                      value: course['language'],
                      items: courseLanguages.map((lang) {
                        return DropdownMenuItem<String>(
                          value: lang,
                          child: Text(
                            lang,
                            style: GoogleFonts.sourceSans3(
                              fontSize: context.courseSmallDescription.fontSize,
                            ),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          course['language'] = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Last Updated: ",
                    style: GoogleFonts.sourceSans3(
                        fontSize: context.courseSmallDescription.fontSize)),
                TextSpan(
                    text: "Update automatically",
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
        SizedBox(
          width: 200,
          child: Form(
            key: priceformKey,
            child: TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Allow only integers
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
        ),
        InkWell(
          onTap: () {},
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

                SizedBox(height: isMobile ? 12 : 20),
                // Make ListView draggable
                ListView(
                  shrinkWrap: true,
                  children: overviews.map((item) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              overviews.remove(item);
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
                Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Form(
                            key: overviewformKey,
                            child: TextFormField(
                              controller: overviewController,
                              maxLength: 120,
                              style: GoogleFonts.openSans(
                                  fontSize: isMobile ? 14 : 18),
                              decoration: InputDecoration(
                                hintText: 'Enter course description',
                                hintStyle: GoogleFonts.openSans(
                                    color: Colors.grey.shade500,
                                    fontSize: isMobile ? 14 : 18),
                                counterText:
                                    '', // Removes character counter display
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a description';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                if (overviewformKey.currentState!.validate()) {
                                  setState(() {
                                    overviews
                                        .add(overviewController.text.trim());
                                    overviewController.clear();
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        if (!isMobile)
                          InkWell(
                              onTap: () {
                                if (overviewformKey.currentState!.validate()) {
                                  setState(() {
                                    overviews
                                        .add(overviewController.text.trim());
                                    overviewController.clear();
                                  });
                                }
                              },
                              child: Container(
                                  color: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 15),
                                  child: const Text("Add",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))))
                      ],
                    ),
                    if (isMobile)
                      InkWell(
                          onTap: () {
                            if (overviewformKey.currentState!.validate()) {
                              setState(() {
                                overviews.add(overviewController.text.trim());
                                overviewController.clear();
                              });
                            }
                          },
                          child: Container(
                              color: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 15),
                              child: const Text("Add",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))))
                  ],
                )
              ],
            ),
          ),
        );
      }),
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
                              if (course['language'] == null) {
                                showErrorToast(context, isMobile,
                                    "Please select content language");
                                return;
                              }
                              setState(() {
                                course['courseTitle'] =
                                    titleController.text.trim();
                                course['courseDescription'] =
                                    descriptionController.text.trim();
                                course['selling_price'] =
                                    int.parse(priceController.text.trim());
                                course['overview'] = overviews;
                                course['instructorId'] =
                                    FirebaseAuth.instance.currentUser!.uid;
                              });
                              await Provider.of<InstructorCourseProvider>(
                                      context,
                                      listen: false)
                                  .createCourse(course)
                                  .then((status) {
                                if (status == RequestStatus.success) {
                                  context.replace(instructorCoursesPath);
                                } else {
                                  showErrorToast(context, isMobile,
                                      "Something went wrong. Please try again");
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
                              isMobile ? "Create" : "Create Course",
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
                                titleAndDescription(isMobile),
                                priceAndPurchaseButton(isMobile),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                          desktopView: Container(
                            padding: const EdgeInsets.only(top: 55, bottom: 30),
                            child: FractionallySizedBox(
                              widthFactor: 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  titleAndDescription(isMobile),
                                  priceAndPurchaseButton(isMobile)
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                  addCourseOverviews(isMobile)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
