import 'package:flutter/material.dart';
import '../screen2_words_list.dart';
import '../widgets/main_app_scaffold.dart';
import '../database_helper.dart';
import '../vocabulary_service.dart';

class VocabularyAddScreen extends StatefulWidget {
  const VocabularyAddScreen({super.key, required this.title});

  final String title;

  @override
  State<VocabularyAddScreen> createState() => _VocabularyAddScreenState();
}

class _VocabularyAddScreenState extends State<VocabularyAddScreen> {
  String? _selectedLearnLanguage;
  String? _selectedNativeLanguage;
  double _level = 0.0;
  String _levelString = 'A1';
  int _selectedVocabularyId = 0;

  final List<String> _learnLanguages = ['English'];
  final List<String> _nativeLanguages = [
    'Turkish (Türkçe)',
    'Mandarin Chinese (普通话)',
    'Spanish (Español)',
    'Hindi (हिन्दी)',
    'Arabic (العربية)',
    'Portuguese (Português)',
    'Russian (Русский)',
    'Japanese (日本語)',
    'Punjabi (ਪੰਜਾਬੀ)',
  ];

  List<Map<String, dynamic>> _vocabularies = [];
  String _getLanguageCode(String languageName) {
    switch (languageName) {
      case 'Mandarin Chinese (普通话)':
        return 'zh';
      case 'Spanish (Español)':
        return 'es';
      case 'Turkish':
        return 'tr';
      case 'Hindi (हिन्दी)':
        return 'hi';
      case 'Arabic (العربية)':
        return 'ar';
      case 'Portuguese (Português)':
        return 'pt';
      // Add cases for other languages
      case 'Russian (Русский)':
        return 'ru';
      case 'Japanese (日本語)':
        return 'ja';
      case 'Punjabi (ਪੰਜਾਬੀ)':
        return 'pa';
      default:
        return 'en'; // Default to English
    }
  }

  @override
  void initState() {
    _loadVocabularies();
    _selectedLearnLanguage =
        _learnLanguages.isNotEmpty ? _learnLanguages.first : null;
    _selectedNativeLanguage =
        _nativeLanguages.isNotEmpty ? _nativeLanguages.first : null;
    super.initState();
  }

  Future<void> _loadVocabularies() async {
    final vocabularies = await DatabaseHelper().getVocabularies();
    setState(() {
      _vocabularies = vocabularies;
      if (_vocabularies.isNotEmpty) {
        _selectedVocabularyId = _vocabularies.first['id'];
      }
    });
  }

  void _onLevelChanged(double value) {
    setState(() {
      _level = value;
      _levelString = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'][_level.round()];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      screenTitle: 'LangPocket', 
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Language you are going to learn',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                DropdownButton<String>(
                  value: _selectedLearnLanguage,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLearnLanguage = newValue;
                    });
                  },
                  items:
                      _learnLanguages.map<DropdownMenuItem<String>>((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Select Vocabulary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                DropdownButton<int>(
                  value: _selectedVocabularyId,
                  onChanged: (int? newValue) {
                    setState(() {
                      if (newValue != null) {
                        _selectedVocabularyId = newValue;
                      }
                    });
                  },
                  items:
                      _vocabularies.map<DropdownMenuItem<int>>((
                        Map<String, dynamic> vocabulary,
                      ) {
                        return DropdownMenuItem<int>(
                          value: vocabulary['id'],
                          child: Text(vocabulary['Name'] ?? 'empty'),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Your native language',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                DropdownButton<String>(
                  value: _selectedNativeLanguage,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedNativeLanguage = newValue;
                    });
                  },
                  items:
                      _nativeLanguages.map<DropdownMenuItem<String>>((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Level',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Slider(
                  value: _level,
                  min: 0.0,
                  max: 5.0,
                  divisions: 5,
                  label: _levelString,
                  onChanged: _onLevelChanged,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('A1'),
                    Text('A2'),
                    Text('B1'),
                    Text('B2'),
                    Text('C1'),
                    Text('C2'),
                  ],
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () async {
                    final selectedVocabulary =
                        _vocabularies.firstWhere(
                          (v) => v['id'] == _selectedVocabularyId,
                        )['Name'];
                    final level = _levelString;
                    final languageCode = _getLanguageCode(
                      _selectedNativeLanguage!,
                    );

                    final vocabularyService = VocabularyService();
                    final success = await vocabularyService
                        .fetchAndSaveVocabulary(
                          vocabularyId: _selectedVocabularyId,
                          selectedVocabulary: selectedVocabulary,
                          level: level,
                          selectedNativeLanguage: _selectedNativeLanguage!,
                          languageCode: languageCode,
                        );

                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Failed to load vocabulary data. Please try again.',
                          ),
                        ),
                      );
                      return;
                    }

                    final String selectedVocabularyName =
                        _vocabularies.firstWhere(
                          (v) => v['id'] == _selectedVocabularyId,
                        )['Name'];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EmotionWordsScreen(
                              nativeLanguageCode: _getLanguageCode(
                                _selectedNativeLanguage!,
                              ),
                              level: level,
                              vocabId: _selectedVocabularyId,
                              translCode: languageCode,
                              vocabularyName:
                                  selectedVocabularyName, 
                            ),
                      ),
                    );
                  },
                  child: const Text('Start Learning'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
