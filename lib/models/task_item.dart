import 'package:cloud_firestore/cloud_firestore.dart';

class TaskItem {
  final String? id; // Firestore document ID
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final int unfinishedTasks;
  final String date;
  final int? circle;
  final String? status; // Added status field for "Pending Approval", etc.
  final List<String>? assignedUserIds; // IDs of users assigned to this task

  TaskItem({
    this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.unfinishedTasks,
    required this.date,
    required this.circle,
    this.status = 'Pending Approval',
    this.assignedUserIds,
  });

  // Create a TaskItem from Firestore data
  factory TaskItem.fromFirestore(String documentId, Map<String, dynamic> data) {
    return TaskItem(
      id: documentId,
      title: data['title'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      unfinishedTasks: data['unfinishedTasks'] ?? 0,
      date: data['date'] ?? '',
      circle: data['circle'] ?? 0,
      status: data['status'] ?? 'Pending Approval',
      assignedUserIds: data['assignedUserIds'] != null
          ? List<String>.from(data['assignedUserIds'])
          : [],
    );
  }

  // Convert TaskItem to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'unfinishedTasks': unfinishedTasks,
      'date': date,
      'circle': circle,
      'status': status,
      'assignedUserIds': assignedUserIds ?? [],
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Create a copy of this TaskItem with updated fields
  TaskItem copyWith({
    String? id,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    int? unfinishedTasks,
    String? date,
    int? circle,
    String? status,
    List<String>? assignedUserIds,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      unfinishedTasks: unfinishedTasks ?? this.unfinishedTasks,
      date: date ?? this.date,
      circle: circle ?? this.circle,
      status: status ?? this.status,
      assignedUserIds: assignedUserIds ?? this.assignedUserIds,
    );
  }
}
