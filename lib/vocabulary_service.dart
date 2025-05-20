import 'dart:convert';
import 'database_helper.dart';
import 'gemini_api_helper.dart';
import 'package:sqflite/sqflite.dart';

class VocabularyService {
  Future<bool> fetchAndSaveVocabulary({
    required int vocabularyId,
    required String selectedVocabulary,
    required String level,
    required String selectedNativeLanguage,
    required String languageCode,
  }) async {
    // The level parameter is String to match the database schema and checkIfTopicExists
    bool exists = await DatabaseHelper().checkIfTopicExists(
      selectedVocabulary,
      level,
      languageCode,
    );

    if (!exists) {
      // Pass the level as String to getVocabularyData, assuming it can handle it or
      // that the gemini_api_helper needs to be updated to handle double if necessary.
      // Based on the error message, it seems getVocabularyData expects a String.
      final jsonString = await getVocabularyData(
        level, // Pass the original String level
        selectedVocabulary,
        selectedNativeLanguage,
      );
      try {
        final List<dynamic> words = jsonDecode(jsonString);
        final db = await DatabaseHelper().database;
        final vocabId = vocabularyId;
        for (var wordObj in words) {
          final word = wordObj['word'] as String;
          final translations = wordObj['translations'] as List<dynamic>;
          for (var translation in translations) {
            await db.insert('Translations', {
              'vocabulary': vocabId,
              'original_word': word,
              'word_level': level, // Inserting level as String into the TEXT column
              'origin_lang': 'en', // Assuming origin language is English
              'transl_word': translation,
              'transl_code': languageCode,
              'learned': 0,
            }, conflictAlgorithm: ConflictAlgorithm.ignore);
          }
        }
        return true; // Data fetched and saved successfully
      } catch (e) {
        print('Error decoding or saving vocabulary data: $e');
        return false; // Error occurred
      }
    }
    return true; // Topic already exists
  }

  Future<List<Map<String, String>>> getVocabularyWords({
    required int vocabId,
  }) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Translations',
      where: 'vocabulary = ?',
      whereArgs: [vocabId],
    );

    if (maps.isEmpty) {
      return [];
    }

    // Group translations by original_word
    final Map<String, List<String>> groupedWords = {};
    for (var item in maps) {
      final originalWord = item['original_word'] as String;
      final translatedWord = item['transl_word'] as String;

      if (!groupedWords.containsKey(originalWord)) {
        groupedWords[originalWord] = [];
      }
      groupedWords[originalWord]!.add(translatedWord);
    }

    // Format for display, joining multiple translations if they exist
    final List<Map<String, String>> vocabularyList = [];
    groupedWords.forEach((originalWord, translations) {
      vocabularyList.add({
        'english': originalWord,
        'translation': translations.join(', '), // Join multiple translations
      });
    });

    return vocabularyList;
  }
}