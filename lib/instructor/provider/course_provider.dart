import 'package:coursesnest/utils/paths.dart';

class InstructorCourseProvider extends ChangeNotifier {
  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> submittedCourses = [];
  StreamSubscription<QuerySnapshot>? coursesListener;
  StreamSubscription<QuerySnapshot>? publishRequestedCoursesListener;

  @override
  void dispose() {
    coursesListener?.cancel();
    publishRequestedCoursesListener?.cancel();
    super.dispose();
  }

  Future<void> initialize(String userId) async {
    listenToMyCourses(userId);
    listenToPublishRequestedCourses(userId);
  }

  void deactivateStreams() {
    coursesListener?.cancel();
    publishRequestedCoursesListener?.cancel();
    courses.clear();
  }

  void listenToMyCourses(String userId) {
    FirebaseFirestore firestoreCoursesNest = FirebaseFirestore.instanceFor(
        app: Firebase.app(), // Specify the default Firebase app
        databaseId: dotenv.env['DATABASE_ID']!);

    coursesListener = firestoreCoursesNest
        .collection(dotenv.env['INSTRUCTOR_COURSES_DATA_COLLECTION']!)
        .doc(userId)
        .collection(dotenv.env['COURSES_DATA_COLLECTION']!)
        .snapshots()
        .listen((snapshot) {
      courses = snapshot.docs.map((doc) => doc.data()).toList();
      notifyListeners();
    });
  }

  void listenToPublishRequestedCourses(String userId) {
    FirebaseFirestore firestoreCoursesNest = FirebaseFirestore.instanceFor(
        app: Firebase.app(), // Specify the default Firebase app
        databaseId: dotenv.env['DATABASE_ID']!);

    publishRequestedCoursesListener = firestoreCoursesNest
        .collection(dotenv.env['COURSES_PUBLISH_REQUESTS_DATA_COLLECTION']!)
        .where("instructorId", isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      submittedCourses = snapshot.docs.map((doc) => doc.data()).toList();
      notifyListeners();
    });
  }

  Future<RequestStatus> createCourse(Map<String, dynamic> course) async {
    try {
      FirebaseFirestore firestoreCoursesNest = FirebaseFirestore.instanceFor(
          app: Firebase.app(), // Specify the default Firebase app
          databaseId: dotenv.env['DATABASE_ID']!);

      final docRef = firestoreCoursesNest
          .collection(dotenv.env['INSTRUCTOR_COURSES_DATA_COLLECTION']!)
          .doc(course['instructorId'])
          .collection(dotenv.env['COURSES_DATA_COLLECTION']!)
          .doc();
      course['id'] = docRef.id;
      course['lastUpdated'] = FieldValue.serverTimestamp();
      course['version'] = 1;

      await docRef.set(course);
      return RequestStatus.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'unavailable') {
        return RequestStatus.networkError;
      }
      return RequestStatus.unknown;
    } catch (e) {
      // Catch any other exceptions
      return RequestStatus.unknown;
    }
  }

  Future<RequestStatus> updateCourse(Map<String, dynamic> course) async {
    try {
      FirebaseFirestore firestoreCoursesNest = FirebaseFirestore.instanceFor(
          app: Firebase.app(), // Specify the default Firebase app
          databaseId: dotenv.env['DATABASE_ID']!);

      final docRef = firestoreCoursesNest
          .collection(dotenv.env['INSTRUCTOR_COURSES_DATA_COLLECTION']!)
          .doc(course['instructorId'])
          .collection(dotenv.env['COURSES_DATA_COLLECTION']!)
          .doc(course['id']);
      
      // Directly use FieldValue.serverTimestamp() in the update method
    await docRef.update({
      ...course, // Spread the existing course data
      'lastUpdated': FieldValue.serverTimestamp(), // Add the timestamp field
    });
      return RequestStatus.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'unavailable') {
        return RequestStatus.networkError;
      }
      return RequestStatus.unknown;
    } catch (e) {
      // Catch any other exceptions
      return RequestStatus.unknown;
    }
  }
}
