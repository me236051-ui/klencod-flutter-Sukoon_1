import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

// نموذج بيانات القارئ
class Reciter {
  final String name;
  final String serverUrl;

  Reciter({required this.name, required this.serverUrl});
}

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  String _currentSurahName = "";
  int? _playingSurahIndex;

  // قائمة أشهر الشيوخ وروابط سيرفرات التلاوة المباشرة (mp3quran)
  final List<Reciter> reciters = [
    Reciter(name: 'ماهر المعيقلي', serverUrl: 'https://server12.mp3quran.net/maher/'),
    Reciter(name: 'مشاري العفاسي', serverUrl: 'https://server8.mp3quran.net/afs/'),
    Reciter(name: 'عبد الباسط عبد الصمد (المجوّد)', serverUrl: 'https://server13.mp3quran.net/basit/'),
    Reciter(name: 'سعود الشريم', serverUrl: 'https://server7.mp3quran.net/shur/'),
    Reciter(name: 'أحمد العجمي', serverUrl: 'https://server10.mp3quran.net/ajm/'),
    Reciter(name: 'سعد الغامدي', serverUrl: 'https://server7.mp3quran.net/s_gmd/'),
    Reciter(name: 'ياسر الدوسري', serverUrl: 'https://server11.mp3quran.net/yasser/'),
  ];

  // أسماء سور القرآن الكريم (أول 10 سور كمثال، ويمكنك إكمال القائمة لـ 114 سورة)
  final List<String> surahs = [
    "الفاتحة", "البقرة", "آل عمران", "النساء", "المائدة",
    "الأنعام", "الأعراف", "الأنفال", "التوبة", "يونس"
  ];

  late Reciter _selectedReciter;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _selectedReciter = reciters[0]; // القارئ الافتراضي: ماهر المعيقلي
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // دالة تشغيل السورة
  Future<void> _playAudio(int surahIndex, String surahName) async {
    try {
      // تحويل رقم السورة إلى صيغة 3 أرقام (مثلاً: سورة 1 تكون 001)
      String formattedIndex = (surahIndex + 1).toString().padLeft(3, '0');
      String audioUrl = "${_selectedReciter.serverUrl}$formattedIndex.mp3";

      setState(() {
        _currentSurahName = surahName;
        _playingSurahIndex = surahIndex;
      });

      await _audioPlayer.setUrl(audioUrl);
      _audioPlayer.play();

      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ في تشغيل الصوت: $e')),
      );
    }
  }

  // دالة إيقاف / استئناف الصوت
  Future<void> _toggleAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. قائمة اختيار القارئ
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.teal.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('اختر القارئ:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              
             DropdownButton<Reciter>(
                value: _selectedReciter,
                onChanged: (Reciter? newReciter) {
                  if (newReciter != null) {
                    setState(() {
                      _selectedReciter = newReciter;
                    });
                  }
                },
                items: reciters.map((Reciter reciter) {
                  return DropdownMenuItem<Reciter>(
                    value: reciter,
                    child: Text(reciter.name),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // 2. قائمة سور القرآن
        Expanded(
          child: ListView.builder(
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              final isCurrent = _playingSurahIndex == index;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  child: Text('${index + 1}'),
                ),
                title: Text('سورة ${surahs[index]}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(_selectedReciter.name),
                trailing: Icon(
                  isCurrent && _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  color: Colors.teal,
                  size: 36,
                ),
                onTap: () {
                  if (isCurrent) {
                    _toggleAudio();
                  } else {
                    _playAudio(index, surahs[index]);
                  }
                },
              );
            },
          ),
        ),

        // 3. شريط المشغل الصوتي الممتد بأسفل الشاشة عند التشغيل
        if (_playingSurahIndex != null)
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.teal.shade700,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سورة $_currentSurahName',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      _selectedReciter.name,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 32),
                  onPressed: _toggleAudio,
                )
              ],
            ),
          )
      ],
    );
  }
}