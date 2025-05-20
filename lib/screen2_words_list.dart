import 'package:flutter/material.dart';
import 'database_helper.dart'; // Ensure DatabaseHelper is imported
import 'vocabulary_service.dart'; // Import the new service
import 'package:LangPocket/services/local_log_service.dart'; // Updated import

class EmotionWordsScreen extends StatefulWidget {
  const EmotionWordsScreen({
    super.key,
    required this.nativeLanguageCode,
    this.vocabId = 0,
    required this.level,
    required this.translCode,
    required this.vocabularyName, // Added
  });

  final String nativeLanguageCode;
  final int vocabId;
  final String level;
  final String translCode;
  final String vocabularyName; // Added

  @override
  // ignore: library_private_types_in_public_api
  _EmotionWordsScreenState createState() => _EmotionWordsScreenState();
}

class _EmotionWordsScreenState extends State<EmotionWordsScreen> {
  List<Map<String, dynamic>> _vocabularyWords = [];
  final Set<int> _selectedWordIds = <int>{};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndDisplayVocabulary(); // Fetch vocabulary when the screen initializes
  }

  Future<void> _fetchAndDisplayVocabulary() async {
    // DIAGNOSTIC PRINTS REMOVED
    setState(() {
      _isLoading = true;
    });

    final vocabularyService = VocabularyService();

    try {
      // Assuming 'selectedVocabulary' might be needed by the service,
      // but the current screen doesn't explicitly have one selected besides the implied "Emotion Words".
      // Let's keep the placeholder or derive it if possible.
      // The fetchAndSaveVocabulary method uses vocabId, level, nativeLanguageCode, and languageCode.
      // Let's assume these are sufficient to identify and fetch the correct vocabulary.
      final success = await vocabularyService.fetchAndSaveVocabulary(
        vocabularyId: widget.vocabId,
        selectedVocabulary: widget.vocabularyName, // UPDATED
        level: widget.level,
        selectedNativeLanguage: widget.nativeLanguageCode,
        languageCode: widget.translCode,
      );

      if (success) {
        // After saving, fetch the words to display
        // Assuming VocabularyService has a method getVocabularyWords that takes vocabId
        final fetchedWords = await vocabularyService.getVocabularyWords(vocabId: widget.vocabId); // Assuming method signature

        setState(() {
          _vocabularyWords = fetchedWords;
          _selectedWordIds.clear(); // Clear selections when new words are fetched
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vocabulary fetched and displayed!'))
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch and save vocabulary.')),
        );
      }
    } catch (e, s) {
      setState(() {
        _isLoading = false;
      });
      await LocalLogService().logErrorLocal('An error occurred in _fetchAndDisplayVocabulary', error: e, stackTrace: s); // Updated to LocalLogService
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vocabularyName), // UPDATED
        backgroundColor: Colors.orange[700], // Warm color
      ),
      body: Container(
        color: Colors.orange[100], // Warm color background
        child: _isLoading
            ? const Center(child: CircularProgressIndicator()) // Show loading indicator
            : _vocabularyWords.isEmpty
                ? const Center(child: Text('No vocabulary words found.')) // Show message if list is empty
                : Column( // Use Column to include the button below the list
                    children: [
                      Expanded( // Wrap ListView.builder with Expanded
                        child: ListView.builder(
                          itemCount: _vocabularyWords.length,
                          itemBuilder: (context, index) {
                            final word = _vocabularyWords[index];
                            final wordId = word['id'] as int;
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              elevation: 2.0,
                              child: CheckboxListTile(
                                title: Text(
                                  word['english']?.toString() ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  word['translation']?.toString() ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                value: _selectedWordIds.contains(wordId),
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    if (newValue == true) {
                                      _selectedWordIds.add(wordId);
                                    } else {
                                      _selectedWordIds.remove(wordId);
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column( // Use a Column for multiple buttons
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (_selectedWordIds.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('No words selected.')),
                                  );
                                  return;
                                }
                                final dbHelper = DatabaseHelper();
                                await dbHelper.updateLearnedStatus(_selectedWordIds.toList(), 2);
                                setState(() {
                                  _selectedWordIds.clear();
                                });
                                await _fetchAndDisplayVocabulary(); // Refresh the list
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Selected words marked as learned!')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // Or Theme.of(context).primaryColor
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Learn selected words',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 8), // Spacing between buttons
                            ElevatedButton(
                              onPressed: _fetchAndDisplayVocabulary, // Button to refetch/refresh
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[700], // Warm button color
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Refresh Vocabulary', // Button text changed
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
