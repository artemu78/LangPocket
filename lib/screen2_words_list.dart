import 'package:flutter/material.dart';
import 'vocabulary_service.dart'; // Import the new service

class EmotionWordsScreen extends StatefulWidget {
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
  List<Map<String, String>> _vocabularyWords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndDisplayVocabulary(); // Fetch vocabulary when the screen initializes
  }

  Future<void> _fetchAndDisplayVocabulary() async {
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
        selectedVocabulary: 'Emotion Words', // This might need refinement depending on actual usage
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
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Words'), // Title might become dynamic based on vocabulary
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
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              elevation: 2.0,
                              child: ListTile(
                                title: Text(
                                  word['english'] ?? 'N/A', // Assuming 'english' key
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  word['translation'] ?? 'N/A', // Assuming 'translation' key
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
                      ),
                    ],
                  ),
      ),
    );
  }
}
