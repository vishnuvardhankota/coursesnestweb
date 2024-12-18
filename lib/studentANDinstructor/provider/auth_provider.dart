import 'package:coursesnest/utils/paths.dart';

enum RequestStatus {
  success,
  userExists,
  invalidCredential,
  networkError,
  unknown
}

// Auth service is Used to build a secure user authentication system for a web.
class AuthServiceProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Create account function with username, email, password
  Future<RequestStatus> createAccount(
      String username, String email, String password) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      var displayName = "$username,${dotenv.env['STUDENT_TYPE']!}";

      // Optionally, you can update the username in Firebase Authentication profile
      await userCredential.user!.updateDisplayName(displayName);
      FirebaseFirestore firestoreCoursesNest = FirebaseFirestore.instanceFor(
          app: Firebase.app(), // Specify the default Firebase app
          databaseId: dotenv.env['DATABASE_ID']!);

      // Create a document in Firestore under the 'Users' collection
      // FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestoreCoursesNest
          .collection(dotenv.env['USERS_DATA_COLLECTION']!)
          .doc(userCredential.user!.uid)
          .set({
        "uid": userCredential.user!.uid,
        'userName': username,
        'email': email,
        "userType": dotenv.env['STUDENT_TYPE']!,
        'createdAt': FieldValue.serverTimestamp(),
        // Add other user details if necessary
      });
      return RequestStatus.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return RequestStatus.userExists;
      }
      return RequestStatus.unknown;
    } catch (e) {
      return RequestStatus.networkError;
    }
  }

  // Sign-in function with email and password
  Future<RequestStatus> signIn(String email, String password) async {
    try {
      // Sign in with email and password
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return RequestStatus.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return RequestStatus.invalidCredential;
      }
      return RequestStatus.unknown;
    } catch (e) {
      return RequestStatus.networkError;
    }
  }

  // Sign-in function with email and password
  Future<RequestStatus> sendPasswordResetLink(String email) async {
    try {
      // Sign in with email and password
      await auth.sendPasswordResetEmail(email: email);
      return RequestStatus.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return RequestStatus.invalidCredential;
      }
      return RequestStatus.unknown;
    } catch (e) {
      return RequestStatus.networkError;
    }
  }

  // Logout the user from the session
  signout() async {
    await FirebaseAuth.instance.signOut();
  }
}
