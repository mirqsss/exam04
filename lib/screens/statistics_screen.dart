import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:exam04/services/task_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late TaskService _taskService;
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _initTaskService();
  }

  Future<void> _initTaskService() async {
    final prefs = await SharedPreferences.getInstance();
    _taskService = TaskService(prefs: prefs);
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _taskService.getTasks();
    setState(() {
      _tasks = tasks.map((task) => task.toJson()).toList();
    });
  }

  int get _totalTasks => _tasks.length;
  int get _completedTasks => _tasks.where((task) => task['completed']).length;
  int get _pendingTasks => _totalTasks - _completedTasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    Text(
                      'Общая статистика',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatCard(
                          title: 'Всего задач',
                          value: _totalTasks.toString(),
                          icon: Icons.task_alt,
                          color: Colors.blue,
                        ),
                        _StatCard(
                          title: 'Выполнено',
                          value: _completedTasks.toString(),
                          icon: Icons.check_circle,
                          color: Colors.green,
                        ),
                        _StatCard(
                          title: 'В процессе',
                          value: _pendingTasks.toString(),
                          icon: Icons.pending,
                          color: Colors.orange,
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
                    Text(
                      'Прогресс выполнения',
                      style: Theme.of(context).textTheme.titleLarge,
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
                              radius: 80,
                            ),
                            PieChartSectionData(
                              value: _pendingTasks.toDouble(),
                              title: '${(_pendingTasks / _totalTasks * 100).toStringAsFixed(1)}%',
                              color: Colors.orange,
                              radius: 80,
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
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
              ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
} 