import 'package:coursesnest/utils/paths.dart';
import 'package:flutter/foundation.dart';

class ProfileEditPage extends StatefulWidget {
  final String? path;
  const ProfileEditPage({super.key, required this.path});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController headlineTextController = TextEditingController();
  Uint8List? uploadedImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    final headline = userProvider.currentUser?['headline'];
    headlineTextController.text = headline ?? ''; // Set to empty if null
  }


  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var userType =
        FirebaseAuth.instance.currentUser?.displayName?.split(",")[1] ?? "";
    return SafeArea(
      child: Scaffold(
          drawer: userType == dotenv.env['INSTRUCTOR_TYPE']!
              ? InstructorOptionsDrawer(currentPath: widget.path!)
              : UserOptionsDrawer(currentPath: widget.path!),
          appBar: userType == dotenv.env['INSTRUCTOR_TYPE']!
              ? responsiveInstructorTopBar(context, path: widget.path)
              : responsiveTopBar(context, path: widget.path),
          body: LayoutBuilder(
            builder: (context, constraints) {
              bool isDesktop = constraints.maxWidth > 1024;
              bool isTablet = constraints.maxWidth > 600;

              return Row(
                children: [
                  if (constraints.maxWidth > 600)
                    userType == dotenv.env['STUDENT_TYPE']!
                        ? Sidebar(
                            currentPath: widget.path!, isExpanded: isDesktop)
                        : InstructorSidebar(
                            currentPath: widget.path!, isExpanded: isDesktop),
                  Expanded(
                      child: userProvider.currentUser == null
                          ? const Center(child: CircularProgressIndicator())
                          : Padding(
                              padding: EdgeInsets.all(isTablet ? 20 : 10),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text("Your Information",
                                          style: GoogleFonts.lilitaOne(
                                              fontSize: isTablet
                                                  ? 50
                                                  : context
                                                      .courseSmallDescription
                                                      .fontSize)),
                                    ),
                                    Container(
                                        width: 500,
                                        height: 200,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                          child: Container(
                                              width: 200,
                                              height: 200,
                                              color: Colors.grey[300],
                                              child: userProvider.currentUser![
                                                          'photoURL'] ==
                                                      null
                                                  ? const Icon(
                                                      Icons.person,
                                                      size: 80,
                                                    )
                                                  : Image.network(
                                                      userProvider.currentUser![
                                                          'photoURL'])),
                                        )),
                                    InkWell(
                                      onDoubleTap: () async {
                                        await Provider.of<UserProvider>(context,
                                                listen: false)
                                            .becomeInstructor();
                                      },
                                      onTap: () {
                                        if (kIsWeb) {
                                          showWarningToast(
                                              context,
                                              constraints.maxWidth <= 600,
                                              "Use Mobile App to update");
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        width: 500,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: const Center(
                                            child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.photo),
                                            SizedBox(width: 10),
                                            Text(
                                              "Upload Image",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                      ),
                                    ),
                                    // User Name Field
                                    Container(
                                      width: 500,
                                      padding: EdgeInsets.only(
                                          bottom: isTablet ? 20 : 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Text(
                                              "User Name",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          TextFormField(
                                            readOnly: true,
                                            initialValue: userProvider
                                                .currentUser!['userName'],
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Email Field
                                    Container(
                                      width: 500,
                                      padding: EdgeInsets.only(
                                          bottom: isTablet ? 20 : 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                RichText(
                                                    text: TextSpan(children: [
                                                  const TextSpan(
                                                    text: "Email ",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                      text: FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .emailVerified
                                                          ? "(Verified)"
                                                          : "(Not Verified)",
                                                      style: TextStyle(
                                                          color: FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .emailVerified
                                                              ? Colors.blue
                                                              : Colors.red))
                                                ])),
                                                if (!FirebaseAuth.instance
                                                    .currentUser!.emailVerified)
                                                  InkWell(
                                                      onTap: () {
                                                        FirebaseAuth.instance
                                                            .currentUser!
                                                            .sendEmailVerification();
                                                      },
                                                      child: const Text(
                                                        "Verify",
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ))
                                              ],
                                            ),
                                          ),
                                          TextFormField(
                                            readOnly: true,
                                            initialValue: userProvider
                                                .currentUser!['email'],
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Headline Field
                                    Container(
                                      width: 500,
                                      padding: EdgeInsets.only(
                                          bottom: isTablet ? 20 : 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Text(
                                              "Headline",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: headlineTextController,
                                            decoration: const InputDecoration(
                                              hintText:
                                                  "Data Analyst @ CoursesNest",
                                              hintStyle:
                                                  TextStyle(fontSize: 18),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await Provider.of<UserProvider>(context,
                                                listen: false)
                                            .updateData({
                                          "headline": headlineTextController
                                              .text
                                              .trim(),
                                          "uid": FirebaseAuth
                                              .instance.currentUser!.uid
                                        }).then((status) {
                                          if (status == RequestStatus.success) {
                                            showSuccessToast(
                                                context,
                                                constraints.maxWidth <= 600,
                                                "Data Updated Successfully");
                                          } else if (status ==
                                                  RequestStatus.networkError ||
                                              status == RequestStatus.unknown) {
                                            showErrorToast(
                                                context,
                                                constraints.maxWidth <= 600,
                                                "Something went wrong. Try again");
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 150,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: const Center(
                                          child: Text(
                                            'Save',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                ],
              );
            },
          )),
    );
  }
}
