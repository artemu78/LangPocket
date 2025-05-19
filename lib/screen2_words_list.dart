import 'dart:ffi';

import 'package:flutter/material.dart';

class EmotionWordsScreen extends StatefulWidget {
  // Suggested code may be subject to a license. Learn more: ~LicenseLog:2068070324.
  const EmotionWordsScreen({
    super.key,
    required this.nativeLanguageCode,
    this.vocabId = 0,
    required this.level,
    required this.translCode,
  });

  final String nativeLanguageCode;
  final int vocabId;
  final String level;
  final String translCode;

  @override
  // ignore: library_private_types_in_public_api
  _EmotionWordsScreenState createState() => _EmotionWordsScreenState();
}

class _EmotionWordsScreenState extends State<EmotionWordsScreen> {
  final Map<String, Map<String, String>> translations = const {
    'tr': {
      'Happy': 'Mutlu',
      'Sad': 'Üzgün',
      'Angry': 'Kızgın',
      'Excited': 'Heyecanlı',
      'Scared': 'Korkmuş',
    },
    'zh': {
      'Happy': '高兴 (Gāoxìng)',
      'Sad': '伤心 (Shāngxīn)',
      'Angry': '生气 (Shēngqì)',
      'Excited': '兴奋 (Xīngfèn)',
      'Scared': '害怕 (Hàipà)',
    },
    'es': {
      'Happy': 'Feliz',
      'Sad': 'Triste',
      'Angry': 'Enojado',
      'Excited': 'Emocionado',
      'Scared': 'Asustado',
    },
    'hi': {
      'Happy': 'खुश (Khush)',
      'Sad': 'दुखी (Dukhi)',
      'Angry': 'गुस्सा (Gussa)',
      'Excited': 'उत्साहित (Utsāhit)',
      'Scared': 'डरा हुआ (Darā Huā)',
    },
    'ar': {
      'Happy': 'سعيد (Saʿīd)',
      'Sad': 'حزين (Ḥazīn)',
      'Angry': 'غاضب (Ghāḍib)',
      'Excited': 'متحمس (Mutḥammis)',
      'Scared': 'خائف (Khāʾif)',
    },
    'pt': {
      'Happy': 'Feliz',
      'Sad': 'Triste',
      'Angry': 'Zangado',
      'Excited': 'Animado',
      'Scared': 'Assustado',
    },
    'bn': {
      'Happy': 'খুশি (Khushi)',
      'Sad': 'দুঃখিত (Dukkhito)',
      'Angry': 'রাগান্বিত (Rāgānvita)',
      'Excited': 'উদ্দীপ্ত (Uddīpta)',
      'Scared': 'ভীত (Bhīta)',
    },
    'ru': {
      'Happy': 'Счастливый (Schastlivyy)',
      'Sad': 'Грустный (Grustnyy)',
      'Angry': 'Злой (Zloy)',
      'Excited': 'Взволнованный (Vzvolnovannyy)',
      'Scared': 'Испуганный (Ispugannyy)',
    },
    'ja': {
      'Happy': '嬉しい (Ureshii)',
      'Sad': '悲しい (Kanashii)',
      'Angry': '怒っている (Okotteiru)',
      'Excited': '興奮している (Kōfun shite iru)',
      'Scared': '怖い (Kowai)',
    },
    'pa': {
      'Happy': 'ਖੁਸ਼ (Khush)',
      'Sad': 'ਉਦਾਸ (Udās)',
      'Angry': 'ਗੁੱਸੇ ਵਿਚ (Gusse vich)',
      'Excited': 'ਉਤਸ਼ਾਹਤ (Utshāhit)',
      'Scared': 'ਡਰਿਆ ਹੋਇਆ (Ḍariā hoia)',
    },
  };

  final List<String> emotionWords = const [
    'Happy',
    'Sad',
    'Angry',
    'Excited',
    'Scared',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Words'),
        backgroundColor: Colors.orange[700], // Warm color
      ),
      body: Container(
        color: Colors.orange[100], // Warm color background
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: emotionWords.length,
                itemBuilder: (context, index) {
                  final englishWord = emotionWords[index];
                  final translatedWord =
                      translations[widget.nativeLanguageCode]?[englishWord] ??
                      'Translation not available';
                  final word = {
                    'english': englishWord,
                    'translation': translatedWord,
                  };
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(
                        englishWord,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        word['translation']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement action for learning words
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700], // Warm button color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Learn these words',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
