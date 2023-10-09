import 'package:firebase_auth/firebase_auth.dart';
import 'package:velix/velix.dart';

Future firebaseErrorHandler(dynamic error) {
  if (error is FirebaseAuthException) {
    FirebaseAuthException authError = error;

    switch (authError.code) {
      case 'INVALID_LOGIN_CREDENTIALS':
        throw AppException('Invalid User, Please try again');
      default:
        throw AppException('Firebase authentication error: ${authError.code}');
    }
  } else if (error is FirebaseException) {
    FirebaseException firebaseError = error;

    switch (firebaseError.code) {
      default:
        throw AppException('Firebase error: ${firebaseError.code}');
    }
  } else {
    throw AppException('Something is wrong');
  }
}
