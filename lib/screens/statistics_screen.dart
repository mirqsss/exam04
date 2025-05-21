import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:exam04/services/task_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:exam04/screens/auth_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late TaskService _taskService;
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initTaskService();
    
    // Проверка аутентификации
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Перенаправление на экран входа
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AuthScreen()),
          );
        }
      });
    }
  }

  Future<void> _initTaskService() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _taskService = TaskService(prefs: prefs);
      await _loadTasks();
    } catch (e) {
      setState(() {
        _error = 'Ошибка при инициализации: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _taskService.getTasks();
      setState(() {
        _tasks = tasks.map((task) => task.toJson()).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка при загрузке задач: $e';
        _isLoading = false;
      });
    }
  }

  int get _totalTasks => _tasks.length;
  int get _completedTasks => _tasks.where((task) => task['isCompleted'] ?? false).length;
  int get _pendingTasks => _totalTasks - _completedTasks;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTasks,
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: _tasks.isEmpty
          ? const Center(child: Text('Нет данных для отображения'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Общая статистика',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatCard(
                                'Всего задач',
                                _totalTasks.toString(),
                                Icons.task,
                              ),
                              _buildStatCard(
                                'Выполнено',
                                _completedTasks.toString(),
                                Icons.check_circle,
                              ),
                              _buildStatCard(
                                'В процессе',
                                _pendingTasks.toString(),
                                Icons.pending,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Прогресс выполнения',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: _completedTasks.toDouble(),
                                    title: '${(_completedTasks / _totalTasks * 100).toStringAsFixed(1)}%',
                                    color: Colors.green,
                                  ),
                                  PieChartSectionData(
                                    value: _pendingTasks.toDouble(),
                                    title: '${(_pendingTasks / _totalTasks * 100).toStringAsFixed(1)}%',
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
} 