import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMethodsUsers {
  final FirebaseFirestore _firestore;

  FirestoreMethodsUsers(this._firestore);

  // Create User
  Future<void> createUser(String uid, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(uid).set(userData);
  }

  // Read User
  Future<DocumentSnapshot> getUser(String uid) async {
    return _firestore.collection('users').doc(uid).get();
  }

  // Update User
  Future<void> updateUser(String uid, Map<String, dynamic> updatedData) async {
    await _firestore.collection('users').doc(uid).update(updatedData);
  }

  // Delete User
  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  // Search User by ID (essentially the same as 'Read')
  Future<DocumentSnapshot> searchUserById(String uid) async {
    return _firestore.collection('users').doc(uid).get();
  }

  // Search User by Name
  Future<List<DocumentSnapshot>> searchUserByName(String pattern) async {
    return _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: pattern)
        .get()
        .then((snapshot) => snapshot.docs);
  }

  // Fetch All Users
  Future<QuerySnapshot> getAllUsers() async {
    return _firestore.collection('users').get();
  }

  // Fetch Users by Role
  Future<QuerySnapshot> getUsersByRole(String role) async {
    return _firestore.collection('users').where('role', isEqualTo: role).get();
  }

  // Fetch Users by Gender
  Future<QuerySnapshot> getUsersByGender(String gender) async {
    return _firestore.collection('users').where('gender', isEqualTo: gender).get();
  }

  // Fetch Users by Age
  Future<QuerySnapshot> getUsersByAge(int age) async {
    return _firestore.collection('users').where('age', isEqualTo: age).get();
  }

  // Update Last Login Date
  Future<void> updateLastLoginDate(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'lastLoginDate': FieldValue.serverTimestamp(),
    });
  }
}
