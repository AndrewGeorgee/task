import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/task_item.dart';

class FirebaseService {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Auth methods
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      return userCredential.user;
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // User methods
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Firestore methods for tasks
  Future<List<TaskItem>> getUserTasks() async {
    try {
      final User? user = getCurrentUser();
      if (user == null) return [];

      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .orderBy('startDate', descending: false)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TaskItem.fromFirestore(doc.id, data);
      }).toList();
    } catch (e) {
      print('Error getting tasks: $e');
      return [];
    }
  }

  Future<String?> addTask(TaskItem task) async {
    try {
      final User? user = getCurrentUser();
      if (user == null) return null;

      final DocumentReference docRef = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .add(task.toFirestore());

      return docRef.id;
    } catch (e) {
      print('Error adding task: $e');
      return null;
    }
  }

  Future<bool> updateTask(String taskId, TaskItem task) async {
    try {
      final User? user = getCurrentUser();
      if (user == null) return false;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc(taskId)
          .update(task.toFirestore());

      return true;
    } catch (e) {
      print('Error updating task: $e');
      return false;
    }
  }

  Future<bool> deleteTask(String taskId) async {
    try {
      final User? user = getCurrentUser();
      if (user == null) return false;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc(taskId)
          .delete();

      return true;
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }
  
  // Storage methods for task attachments and user avatars
  
  // Upload a file to Firebase Storage
  Future<String?> uploadFile(String filePath, String destination) async {
    try {
      final User? user = getCurrentUser();
      if (user == null) return null;
      
      final File file = File(filePath);
      final Reference ref = _storage.ref().child('users/${user.uid}/$destination');
      
      final UploadTask uploadTask = ref.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;
      
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }
  
  // Upload a user avatar
  Future<String?> uploadUserAvatar(String filePath) async {
    return uploadFile(filePath, 'avatar.jpg');
  }
  
  // Upload a task attachment
  Future<String?> uploadTaskAttachment(String taskId, String filePath, String fileName) async {
    return uploadFile(filePath, 'tasks/$taskId/$fileName');
  }
  
  // Get a list of task attachments
  Future<List<String>> getTaskAttachments(String taskId) async {
    try {
      final User? user = getCurrentUser();
      if (user == null) return [];
      
      final Reference ref = _storage.ref().child('users/${user.uid}/tasks/$taskId');
      final ListResult result = await ref.listAll();
      
      final List<String> urls = [];
      for (final Reference itemRef in result.items) {
        final String url = await itemRef.getDownloadURL();
        urls.add(url);
      }
      
      return urls;
    } catch (e) {
      print('Error getting task attachments: $e');
      return [];
    }
  }
}
