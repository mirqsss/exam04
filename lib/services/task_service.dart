import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam04/models/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const String _tasksKey = 'tasks';
  final SharedPreferences _prefs;

  TaskService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    required SharedPreferences prefs,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _prefs = prefs;

  String get _userId => _auth.currentUser?.uid ?? '';
  String get userId => _userId;

  // Получение всех задач пользователя
  Stream<List<TaskModel>> getTasksStream() {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: _userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data()))
          .toList();
    });
  }

  // Получение списка задач как Future
  Future<List<TaskModel>> getTasks() async {
    final snapshot = await _firestore
        .collection('tasks')
        .where('userId', isEqualTo: _userId)
        .get();
    return snapshot.docs
        .map((doc) => TaskModel.fromJson(doc.data()))
        .toList();
  }

  // Получение задач по статусу
  Stream<List<TaskModel>> getTasksByStatusStream(bool isCompleted) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: _userId)
        .where('isCompleted', isEqualTo: isCompleted)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data()))
          .toList();
    });
  }

  // Получение задач по статусу как Future
  Future<List<TaskModel>> getTasksByStatus(bool isCompleted) async {
    final snapshot = await _firestore
        .collection('tasks')
        .where('userId', isEqualTo: _userId)
        .where('isCompleted', isEqualTo: isCompleted)
        .get();
    return snapshot.docs
        .map((doc) => TaskModel.fromJson(doc.data()))
        .toList();
  }

  // Создание новой задачи
  Future<void> addTask(TaskModel task) async {
    await _firestore.collection('tasks').add(task.toJson());
  }

  // Обновление задачи
  Future<void> updateTask(TaskModel task) async {
    await _firestore.collection('tasks').doc(task.id).update(task.toJson());
  }

  // Удаление задачи
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

  // Отметка задачи как выполненной
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    final taskRef = _firestore.collection('tasks').doc(taskId);
    await taskRef.update({
      'isCompleted': isCompleted,
      'completedAt': isCompleted ? FieldValue.serverTimestamp() : null,
    });
  }

  // Получение задач по приоритету
  Stream<List<TaskModel>> getTasksByPriorityStream(int priority) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: _userId)
        .where('priority', isEqualTo: priority)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data()))
          .toList();
    });
  }

  // Получение задач по приоритету как Future
  Future<List<TaskModel>> getTasksByPriority(int priority) async {
    final snapshot = await _firestore
        .collection('tasks')
        .where('userId', isEqualTo: _userId)
        .where('priority', isEqualTo: priority)
        .get();
    return snapshot.docs
        .map((doc) => TaskModel.fromJson(doc.data()))
        .toList();
  }

  // Получение задач по тегу
  Stream<List<TaskModel>> getTasksByTagStream(String tag) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: _userId)
        .where('tags', arrayContains: tag)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data()))
          .toList();
    });
  }

  // Получение задач по тегу как Future
  Future<List<TaskModel>> getTasksByTag(String tag) async {
    final snapshot = await _firestore
        .collection('tasks')
        .where('userId', isEqualTo: _userId)
        .where('tags', arrayContains: tag)
        .get();
    return snapshot.docs
        .map((doc) => TaskModel.fromJson(doc.data()))
        .toList();
  }

  List<Map<String, dynamic>> getTasksJson() {
    final tasksJson = _prefs.getStringList(_tasksKey) ?? [];
    return tasksJson
        .map((task) => Map<String, dynamic>.from(json.decode(task)))
        .toList();
  }

  Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
    final tasksJson = tasks
        .map((task) => json.encode(task))
        .toList();
    await _prefs.setStringList(_tasksKey, tasksJson);
  }

  Future<void> addTaskJson(Map<String, dynamic> task) async {
    final tasks = getTasksJson();
    tasks.add(task);
    await saveTasks(tasks);
  }

  Future<void> updateTaskJson(int index, Map<String, dynamic> task) async {
    final tasks = getTasksJson();
    tasks[index] = task;
    await saveTasks(tasks);
  }

  Future<void> deleteTaskJson(int index) async {
    final tasks = getTasksJson();
    tasks.removeAt(index);
    await saveTasks(tasks);
  }
} 