import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // دالة التسبيح مع الاهتزاز
  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    // اهتزاز خفيف عند الضغط (إذا كان الجهاز يدعم ذلك)
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        labelColor: Colors.teal,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.teal,
        tabs: const [
          Tab(text: 'الأذكار اليومية', icon: Icon(Icons.menu_book)),
          Tab(text: 'المسبحة الإلكترونية', icon: Icon(Icons.fiber_manual_record)),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. تبويب الأذكار
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: const [
              _AzkarCategoryCard(
                title: 'أذكار الصباح',
                content: '«أصبحنا وأصبح الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له...»',
              ),
              _AzkarCategoryCard(
                title: 'أذكار المساء',
                content: '«أمسينا وأمسى الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له...»',
              ),
              _AzkarCategoryCard(
                title: 'أذكار النوم',
                content: '«باسمك ربي وضعت جنبي وبك أرفعه، إن أمسكت نفسي فارحمنا وإن أرسلتها فاحفظها...»',
              ),
              _AzkarCategoryCard(
                title: 'أذكار بعد الصلاة المفروضة',
                content: '«أسْتَغْفِرُ اللَّه (ثلاثاً)، اللهم أنت السلام ومنك السلام، تباركت يا ذا الجلال والإكرام.»',
              ),
            ],
          ),

          // 2. تبويب المسبحة الإلكترونية
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'سبحان الله وبحمده، سبحان الله العظيم',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // دائرة العداد
                GestureDetector(
                  onTap: _incrementCounter,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal.shade50,
                      border: Border.all(color: Colors.teal, width: 4),
                    ),
                    child: Center(
                      child: Text(
                        '$_counter',
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _counter = 0;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة ضبط'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100, foregroundColor: Colors.red.shade800),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// عنصر عرض بطاقة الذكر
class _AzkarCategoryCard extends StatelessWidget {
  final String title;
  final String content;

  const _AzkarCategoryCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const Divider(),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }
}