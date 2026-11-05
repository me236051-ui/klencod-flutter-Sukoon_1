import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // تخزين حالات المهام عبر مصفوفة بوليان بسيطة لتجنب أخطاء الأنظمة
  final List<String> _taskTitles = [
    'أداء صلاة الفجر في جماعة',
    'قراءة ورد القرآن الكريم (صفحة على الأقل)',
    'أذكار الصباح والمساء',
    'أداء صلاة الظهر في وقتها',
    'أداء صلاة العصر في وقتها',
    'أداء صلاة المغرب في وقتها',
    'أداء صلاة العشاء في وقتها',
    'السنن الراتبة والنوافل',
  ];

  final List<bool> _taskStatus = [false, false, false, false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    _loadTasksState();
  }

  Future<void> _loadTasksState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < _taskStatus.length; i++) {
        _taskStatus[i] = prefs.getBool('task_$i') ?? false;
      }
    });
  }

  Future<void> _saveTaskState(int index, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('task_$index', value);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const TabBar(
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.teal,
          tabs: [
            Tab(text: 'مهامي اليومية', icon: Icon(Icons.check_circle_outline)),
            Tab(text: 'تعليم الوضوء والصلاة', icon: Icon(Icons.school)),
          ],
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _taskTitles.length,
              itemBuilder: (context, index) {
                final bool isCompleted = _taskStatus[index];
                
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: CheckboxListTile(
                    title: Text(
                      _taskTitles[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: isCompleted ? Colors.grey : Colors.black,
                      ),
                    ),
                    value: isCompleted,
                    activeColor: Colors.teal,
                    onChanged: (bool? value) {
                      setState(() {
                        _taskStatus[index] = value ?? false;
                      });
                      _saveTaskState(index, value ?? false);
                    },
                  ),
                );
              },
            ),
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: const [
                _EducationCard(
                  title: 'طريقة الوضوء الصحيحة',
                  steps: [
                    '1. النية والتسمية (قول بسم الله).',
                    '2. غسل الكفين ثلاثاً.',
                    '3. المضمضة والاستنشاق ثلاثاً.',
                    '4. غسل الوجه كاملاً ثلاثاً.',
                    '5. غسل اليدين إلى المرفقين ثلاثاً.',
                    '6. مسح الرأس والأذنين مرة واحدة.',
                    '7. غسل الرجلين إلى الكعبين ثلاثاً.'
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  final String title;
  final List<String> steps;
  const _EducationCard({required this.title, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const Divider(),
            ...steps.map((step) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(step, style: const TextStyle(fontSize: 15, height: 1.4)),
                )),
          ],
        ),
      ),
    );
  }
}