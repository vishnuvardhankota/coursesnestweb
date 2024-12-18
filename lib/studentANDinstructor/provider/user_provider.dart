import 'package:coursesnest/utils/paths.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? currentUser;
  StreamSubscription<DocumentSnapshot>? currentUserListener;

  @override
  void dispose() {
    currentUserListener?.cancel();
    super.dispose();
  }

  Future<void> initialize(String userId) async {
    listenToCurrentUser(userId);
  }

  void deactivateStreams() {
    currentUserListener?.cancel();
    currentUser = null;
  }

  void listenToCurrentUser(String userId) {
    FirebaseFirestore firestoreCoursesNest = FirebaseFirestore.instanceFor(
        app: Firebase.app(), // Specify the default Firebase app
        databaseId: dotenv.env['DATABASE_ID']!);
    currentUserListener = firestoreCoursesNest
        .collection(dotenv.env['USERS_DATA_COLLECTION']!)
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        currentUser = snapshot.data()!;
        notifyListeners();
      }
    });
  }

  Future<RequestStatus> updateData(Map<String, dynamic> data) async {
    try {
      FirebaseFirestore firestoreCoursesNest = FirebaseFirestore.instanceFor(
          app: Firebase.app(), // Specify the default Firebase app
          databaseId: dotenv.env['DATABASE_ID']!);

      firestoreCoursesNest
          .collection(dotenv.env['USERS_DATA_COLLECTION']!)
          .doc(data['uid'])
          .update(data);
      return RequestStatus.success;
    } on FirebaseAuthException catch (_) {
      return RequestStatus.unknown;
    } catch (e) {
      return RequestStatus.networkError;
    }
  }

  Future<RequestStatus> becomeInstructor() async {
    try {
      FirebaseFirestore firestoreCoursesNest = FirebaseFirestore.instanceFor(
          app: Firebase.app(), // Specify the default Firebase app
          databaseId: dotenv.env['DATABASE_ID']!);
      var userName =
          FirebaseAuth.instance.currentUser!.displayName!.split(",")[0];
      var displayName = "$userName,${dotenv.env['INSTRUCTOR_TYPE']!}";

      FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);

      firestoreCoursesNest
          .collection(dotenv.env['USERS_DATA_COLLECTION']!)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"userType": dotenv.env['INSTRUCTOR_TYPE']!});
      return RequestStatus.success;
    } on FirebaseAuthException catch (_) {
      return RequestStatus.unknown;
    } catch (e) {
      return RequestStatus.networkError;
    }
  }
}
