import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velix/velix.dart';

Future firebaseErrorHandler(dynamic error) {
  if (error is FirebaseException) {
    FirebaseException firebaseError = error;

    switch (firebaseError.code) {
      default:
        throw AppException('Firebase error: ${firebaseError.code}');
    }
  } else {
    throw AppException('Something is wrong');
  }
}
