import 'package:equatable/equatable.dart';

/// Snapshot of Firebase connectivity and permission checks.
class FirebaseHealthCheckResult extends Equatable {
  /// Creates [FirebaseHealthCheckResult].
  const FirebaseHealthCheckResult({
    required this.isFirebaseInitialized,
    required this.isAuthenticated,
    required this.canReadFirestore,
    required this.canWriteFirestore,
    required this.canAccessStorage,
    required this.isOnline,
    required this.checkedAt,
    this.userId,
    this.userEmail,
    this.firestoreReadError,
    this.firestoreWriteError,
    this.storageError,
    this.bootstrappedCollections = const <String, bool>{},
  });

  /// Whether Firebase Core has been initialized.
  final bool isFirebaseInitialized;

  /// Whether a Firebase Auth user is signed in.
  final bool isAuthenticated;

  /// Signed-in user id, when available.
  final String? userId;

  /// Signed-in user email, when available.
  final String? userEmail;

  /// Whether a Firestore read probe succeeded.
  final bool canReadFirestore;

  /// Whether a Firestore write probe succeeded.
  final bool canWriteFirestore;

  /// Whether a Storage write/delete probe succeeded.
  final bool canAccessStorage;

  /// Whether the device reports network connectivity.
  final bool isOnline;

  /// Firestore read failure message, if any.
  final String? firestoreReadError;

  /// Firestore write failure message, if any.
  final String? firestoreWriteError;

  /// Storage failure message, if any.
  final String? storageError;

  /// Collection bootstrap results keyed by Firestore collection id.
  final Map<String, bool> bootstrappedCollections;

  /// When this health check completed.
  final DateTime checkedAt;

  @override
  List<Object?> get props => <Object?>[
        isFirebaseInitialized,
        isAuthenticated,
        userId,
        userEmail,
        canReadFirestore,
        canWriteFirestore,
        canAccessStorage,
        isOnline,
        firestoreReadError,
        firestoreWriteError,
        storageError,
        bootstrappedCollections,
        checkedAt,
      ];
}
