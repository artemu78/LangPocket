import 'package:flutter/material.dart';
import '../widgets/main_app_scaffold.dart';
import './vocabulary_add_screen.dart';
import './vocabularies_screen.dart';
import 'package:LangPocket/database_helper.dart'; // Import DatabaseHelper

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<String> _languages = [
    'English',
    'Turkish (Türkçe)',
    'Mandarin Chinese (普通话)',
    'Spanish (Español)',
    'Hindi (हिन्दी)',
    'Arabic (العربية)',
    'Portuguese (Português)',
    'Russian (Русский)',
    'Japanese (日本語)',
    'Punjabi (ਪੰਜਾਬੀ)',
    // Add other languages as needed
  ];

  String? _selectedLearnLanguage;
  String? _selectedKnownLanguage;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    String? learnLang = await _dbHelper.getSetting("learn_language");
    String? knownLang = await _dbHelper.getSetting("known_language");

    // Ensure the widget is still in the tree before calling setState
    if (!mounted) return;

    setState(() {
      _selectedLearnLanguage = learnLang ?? (_languages.isNotEmpty ? _languages.first : null);
      _selectedKnownLanguage = knownLang ?? (_languages.isNotEmpty ? _languages.first : null);
    });
  }

  void _saveLanguageSetting(String key, String? value) {
    if (value != null) {
      _dbHelper.saveSetting(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      screenTitle: 'LangPocket',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'I want to learn',
                  border: OutlineInputBorder(),
                ),
                value: _selectedLearnLanguage,
                items: _languages.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLearnLanguage = newValue;
                  });
                  _saveLanguageSetting("learn_language", newValue);
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'I know',
                  border: OutlineInputBorder(),
                ),
                value: _selectedKnownLanguage,
                items: _languages.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedKnownLanguage = newValue;
                  });
                  _saveLanguageSetting("known_language", newValue);
                },
              ),
              const SizedBox(height: 40), // Spacing before buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VocabulariesScreen()),
                  );
                },
                child: const Text('Vocabularies'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
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
      ),
    );
  }
}
