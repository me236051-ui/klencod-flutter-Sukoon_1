import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List> _tasks = [
    {'title': 'أداء صلاة الفجر في جماعة', 'isCompleted': false},
    {'title': 'قراءة ورد القرآن الكريم (صفحة على الأقل)', 'isCompleted': false},
    {'title': 'أذكار الصباح والمساء', 'isCompleted': false},
    {'title': 'أداء صلاة الظهر في وقتها', 'isCompleted': false},
    {'title': 'أداء صلاة العصر في وقتها', 'isCompleted': false},
    {'title': 'أداء صلاة المغرب في وقتها', 'isCompleted': false},
    {'title': 'أداء صلاة العشاء في وقتها', 'isCompleted': false},
    {'title': 'السنن الراتبة والنوافل', 'isCompleted': false},
  ];

  @override
  void initState() {
    super.initState();
    _loadTasksState();
  }

  // تحميل حالة المهام المحفوظة مسبقاً
  Future<void> _loadTasksState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < _tasks.length; i++) {
        _tasks[i]['isCompleted'] = prefs.getBool('task_$i') ?? false;
      }
    });
  }

  // حفظ حالة المهمة عند تغييرها
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
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: CheckboxListTile(
                    title: Text(
                      _tasks[index]['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: _tasks[index]['isCompleted']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: _tasks[index]['isCompleted'] ? Colors.grey : Colors.black,
                      ),
                    ),
                    value: _tasks[index]['isCompleted'],
                    activeColor: Colors.teal,
                    onChanged: (bool? value) {
                      setState(() {
                        _tasks[index]['isCompleted'] = value ?? false;
                      });
                      _saveTaskState(index, _tasks[index]['isCompleted']);
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
