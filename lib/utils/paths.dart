export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'dart:async';
export 'dart:convert';
export 'package:flutter/gestures.dart';
export 'package:coursesnest/firebase_options.dart';

// data
export "package:coursesnest/data/courses.dart";

// instructor providers
export 'package:coursesnest/instructor/provider/course_provider.dart';
// instructor widgets
export 'package:coursesnest/instructor/widgets/edit_content_expansion_tile.dart';
export 'package:coursesnest/instructor/widgets/lecture_form.dart';
export 'package:coursesnest/instructor/widgets/instructor_sidebar.dart';
export 'package:coursesnest/instructor/widgets/instructor_topbar.dart';
// instructor pages
export 'package:coursesnest/instructor/pages/create_course.dart';
export 'package:coursesnest/instructor/pages/dashboard.dart';
export 'package:coursesnest/instructor/pages/instructor_courses.dart';
export 'package:coursesnest/instructor/pages/manage_course.dart';

// student providers
// export 'package:coursesnest/instructor/provider/course_provider.dart';
// student widgets
export 'package:coursesnest/student/widgets/sidebar.dart';
export 'package:coursesnest/student/widgets/topbar.dart';
// student pages
export 'package:coursesnest/student/pages/checkout_page.dart';
export 'package:coursesnest/student/pages/my_courses_page.dart';
export 'package:coursesnest/student/pages/wishlist_page.dart';

// Combined packages

// theme
export 'package:coursesnest/theme/theme.dart';
export 'package:coursesnest/theme/text_theme.dart';
export 'package:coursesnest/theme/theme_extension.dart';

//utils
export 'package:coursesnest/studentANDinstructor/utils/toast.dart';
//widgets
export 'package:coursesnest/studentANDinstructor/widgets/content_expansion_tile.dart';
export 'package:coursesnest/studentANDinstructor/widgets/navigation_tile.dart';
export 'package:coursesnest/widgets/responsive_layout.dart';
// provider
export 'package:coursesnest/studentANDinstructor/provider/user_provider.dart';
export 'package:coursesnest/studentANDinstructor/provider/auth_provider.dart';
//pages
export 'package:coursesnest/pages/course_detail_page.dart';
export 'package:coursesnest/pages/courses_page.dart';
export 'package:coursesnest/pages/home_page.dart';
export 'package:coursesnest/studentANDinstructor/pages/login_page.dart';
export 'package:coursesnest/studentANDinstructor/pages/profile_page.dart';

export 'package:coursesnest/utils/constants.dart';
export 'package:coursesnest/utils/enums.dart';

// imported libraries
export "package:firebase_auth/firebase_auth.dart";
export "package:firebase_core/firebase_core.dart";
export "package:cloud_firestore/cloud_firestore.dart";
export "package:google_sign_in/google_sign_in.dart";
export 'package:go_router/go_router.dart';
export 'package:provider/provider.dart';
export 'package:url_strategy/url_strategy.dart';
export 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:flutter_dotenv/flutter_dotenv.dart';
export 'package:toastification/toastification.dart';
export 'package:image_picker/image_picker.dart';
export 'package:image_cropper/image_cropper.dart';


// import 'package:dropdown_button2/dropdown_button2.dart';