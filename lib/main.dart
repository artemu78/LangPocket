import 'package:flutter/material.dart';
import 'screen2_words_list.dart';
import 'package:LangPocket/widgets/main_app_scaffold.dart'; // Added import for MainAppScaffold
import 'database_helper.dart';
import 'vocabulary_service.dart'; // Import the new service

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LangPocket',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const MyHomePage(
        title: 'Language pocket - pocket for your language learning cards',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MainAppScaffold(
      // Replaced Scaffold with MainAppScaffold
      screenTitle: 'LangPocket', // Passed screenTitle
      body: Container(
        // Wrapped existing body with Container
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
                      // Suggested code may be subject to a license. Learn more: ~LicenseLog:3426361174.
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
                    // Get topic name from selected vocabulary
                    final selectedVocabulary =
                        _vocabularies.firstWhere(
                          (v) => v['id'] == _selectedVocabularyId,
                        )['Name'];
                    final level = _levelString;
                    final languageCode = _getLanguageCode(
                      _selectedNativeLanguage!,
                    );

                    // Use the VocabularyService to fetch and save data
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
                      // Show an error message if fetching/saving failed
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Failed to load vocabulary data. Please try again.',
                          ),
                        ),
                      );
                      return;
                    }

                    // Navigate to the next screen after successful data handling
                    // Navigate to the next screen after successful data handling
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
                                  selectedVocabularyName, // Pass the name
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
