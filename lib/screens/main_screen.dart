import 'package:flutter/material.dart';
import '../widgets/main_app_scaffold.dart';
import './vocabulary_add_screen.dart';
import './vocabularies_screen.dart'; // Assuming this screen will be created

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      screenTitle: 'LangPocket',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to VocabulariesScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VocabulariesScreen()), // Placeholder
                );
              },
              child: const Text('Vocabularies'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to VocabularyAddScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VocabularyAddScreen(title: 'Add Vocabulary')),
                );
              },
              child: const Text('Continue learning'),
            ),
          ],
        ),
      ),
    );
  }
}
