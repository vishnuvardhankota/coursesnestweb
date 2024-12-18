import 'package:coursesnest/utils/paths.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthServiceProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => InstructorCourseProvider()),
      ],
      child: const MyApp(),
    ));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    var courseProvider =
        Provider.of<InstructorCourseProvider>(context, listen: false);
    if (FirebaseAuth.instance.currentUser != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      var userType =
          FirebaseAuth.instance.currentUser!.displayName!.split(",")[1];
      if (userType == dotenv.env['STUDENT_TYPE']!) {
        await userProvider.initialize(userId);
      } else if (userType == dotenv.env['INSTRUCTOR_TYPE']!) {
        await userProvider.initialize(userId);
        await courseProvider.initialize(userId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: homePath,
      routes: <GoRoute>[
        // home
        GoRoute(
          path: homePath,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return NoTransitionPage(child: HomePage(path: state.path));
          },
        ),
        // courses
        GoRoute(
          path: coursesPath,
          pageBuilder: (BuildContext context, GoRouterState state) {
            final query = state.uri.queryParameters['search'];
            return NoTransitionPage(
                child: CoursesPage(path: state.path, searchText: query));
          },
        ),
        // course detail page
        GoRoute(
          path: '/course/details',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final query = state.uri.queryParameters['courseId'];
            return NoTransitionPage(
                child: CourseDetailPage(path: state.path, courseId: query));
          },
        ),
        // user profile path
        GoRoute(
          path: profilePath,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return NoTransitionPage(child: ProfileEditPage(path: state.path));
          },
        ),
        // user wishlist page
        GoRoute(
          path: wishlistPath,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return NoTransitionPage(child: WishListPage(path: state.path));
          },
        ),
        // user purchased courses page
        GoRoute(
          path: myCoursesPath,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return NoTransitionPage(child: MyCoursesPage(path: state.path));
          },
        ),
        // user course checkout page
        GoRoute(
          path: checkoutPath,
          pageBuilder: (BuildContext context, GoRouterState state) {
            final query = state.uri.queryParameters['courseId'];
            return NoTransitionPage(
                child: CheckoutPage(path: state.path, courseId: query!));
          },
        ),
        // instructor dashboard page
        GoRoute(
          path: dashboardPath,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return NoTransitionPage(child: DashboardPage(path: state.path));
          },
        ),
        // instructor courses page or manage course page
        GoRoute(
          path: instructorCoursesPath,
          pageBuilder: (BuildContext context, GoRouterState state) {
            final encodedText = state.uri.queryParameters['manage'];
            if (encodedText != null) {
              String courseId = utf8.decode(base64Decode(encodedText));
              return NoTransitionPage(
                  child: ManageCoursePage(courseId: courseId));
            } else {
              return NoTransitionPage(
                  child: InstructorCoursesPage(path: state.path));
            }
          },
        ),
        // Instructor course create page
        GoRoute(
          path: createCoursesPath,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(child: CreateCoursePage());
          },
        ),
        // Instructor profile path
        GoRoute(
          path: instructorProfilePath,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return NoTransitionPage(child: ProfileEditPage(path: state.path));
          },
        ),
        // login page
        GoRoute(
          path: loginPath,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(child: LoginPage());
          },
        ),
      ],
      errorBuilder: (context, state) => const HomePage(
        path: '',
      ),
      redirect: (context, state) {
        var loginPaths = [loginPath];
        var nonInstructorPaths = [homePath, coursesPath];
        var loggedinPaths = [
          profilePath,
          wishlistPath,
          myCoursesPath,
          checkoutPath
        ];
        var instructorPaths = [
          dashboardPath,
          instructorCoursesPath,
          instructorProfilePath,
          createCoursesPath
        ];
        var isLoggedIn =
            FirebaseAuth.instance.currentUser == null ? false : true;

        if (isLoggedIn) {
          var userType =
              FirebaseAuth.instance.currentUser!.displayName!.split(",")[1];
          if (userType == dotenv.env['STUDENT_TYPE']!) {
            if (loginPaths.contains(state.matchedLocation) ||
                instructorPaths.contains(state.matchedLocation)) {
              return homePath;
            }
          } else if (userType == dotenv.env['INSTRUCTOR_TYPE']!) {
            if (loginPaths.contains(state.matchedLocation) ||
                nonInstructorPaths.contains(state.matchedLocation) ||
                loggedinPaths.contains(state.matchedLocation)) {
              return dashboardPath;
            }
          }
        } else if (!isLoggedIn) {
          if (loggedinPaths.contains(state.matchedLocation) ||
              instructorPaths.contains(state.matchedLocation)) {
            return loginPath;
          }
        }
        return null;
      },
    );
    return MaterialApp.router(
      theme: PAppTheme.lightTheme,
      darkTheme: PAppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      title: dotenv.env['ORGANIZATION_NAME']!,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
