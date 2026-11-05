import 'package:flutter/material.dart';
import 'notification_service.dart'; // استيراد ملف الإشعارات
import 'quran_screen.dart';
import 'prayer_screen.dart';
import 'azkar_screen.dart';
import 'tasks_screen.dart';

void main() async {
  // هذه الخطوة ضرورية جداً لضمان تهيئة المحرك قبل تشغيل التطبيق أو الإشعارات
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة خدمة الإشعارات عند إقلاع التطبيق
  await NotificationService.init(); 

  runApp(const SukoonApp());
}

class SukoonApp extends StatelessWidget {
  const SukoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق سكون - Sukoon',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const QuranScreen(),  // شاشة القرآن الكريم
    const PrayerScreen(), // شاشة مواقيت الصلاة
    const AzkarScreen(),  // شاشة الأذكار والمسبحة
    const TasksScreen(),  // شاشة مهام المسلم والتعليم
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سكون - Sukoon'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'القرآن',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'المواقيت',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'الأذكار',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'المهام',
          ),
        ],
      ),
    );
  }
}