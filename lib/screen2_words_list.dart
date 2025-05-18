import 'package:flutter/material.dart';
class EmotionWordsScreen extends StatelessWidget {
  const EmotionWordsScreen({super.key});
  
  final List<Map<String, String>> emotionWords = const [
    {'english': 'Happy', 'translation': 'Счастливый (Schastlivyy)'},
    {'english': 'Sad', 'translation': 'Грустный (Grustnyy)'},
    {'english': 'Angry', 'translation': 'Сердитый (Serdityy)'},
    {'english': 'Excited', 'translation': 'Взволнованный (Vzvolnovannyy)'},
    {'english': 'Scared', 'translation': 'Испуганный (Ispugannyy)'},
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
                  final word = emotionWords[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(
                        word['english']!,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        word['translation']!,
                        style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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