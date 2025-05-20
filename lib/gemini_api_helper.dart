import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:LangPocket/services/local_log_service.dart'; // Updated import

const String GEMINI_API_KEY = String.fromEnvironment('GEMINI_API_KYE', defaultValue: 'AIzaSyATFZfhzaC9kBJcLqRk1WGA4PNxtWEsE5Y');
const String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  // JSON schema for the expected response
  final String jsonSchema = '''
  {
   "type": "array",
   "items": {
     "type": "object",
     "properties": {
       "word": {
         "type": "string"
       },
       "translations": {
         "type": "array",
         "items": {
           "type": "string"
         }
       }
     },
     "required": ["word", "translations"]
   }
 }
 ''';

Future<String> getVocabularyData(String languageLevel, String topic, String language) async {
  // function for fetching vocabulary data from Gemini API

  final String prompt = '''
  Generate exactly 30 $languageLevel English words related to $topic.
  Provide the translation for each word in $language.
  The response must be a JSON array of objects, strictly conforming to the following schema:
  $jsonSchema
  Ensure the JSON is valid and not wrapped in markdown code blocks.
  ''';

  print(prompt);
  try {
    final response = await http.post(
      Uri.parse('$apiUrl?key=$GEMINI_API_KEY'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
           'responseMimeType': 'application/json', // Explicitly request JSON
        },
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      // Navigate the response structure to find the text
      if (responseBody != null && responseBody['candidates'] != null && responseBody['candidates'].isNotEmpty) {
        final candidate = responseBody['candidates'][0];
        if (candidate['content'] != null && candidate['content']['parts'] != null && candidate['content']['parts'].isNotEmpty) {
          final part = candidate['content']['parts'][0];
          if (part['text'] != null) {
            String jsonString = part['text'];

            // Attempt to clean potential markdown wrapping
            if (jsonString.startsWith('```json')) {
               jsonString = jsonString.substring(7);
               if (jsonString.endsWith('```')) {
                  jsonString = jsonString.substring(0, jsonString.length - 3);
               }
            }
            jsonString = jsonString.trim();

            return jsonString; // Return the raw JSON string

          }
        }
      }
      // If we reach here, the expected structure was not found
      print('Error: Unexpected response structure from Gemini API.');
      print('Response body: ${response.body}');
      return 'Error: Unexpected API response format.';

    } else {
      // Handle HTTP error
      print('Error calling Gemini API: ${response.statusCode}');
      print('Response body: ${response.body}');
      await LocalLogService().logErrorLocal('Error calling Gemini API: ${response.statusCode}', error: response.body); // Updated to LocalLogService
      return 'Error: Failed to fetch vocabulary data. Status code: ${response.statusCode}';
    }
  } catch (e, s) {
    // Handle any exceptions during the process (e.g., network errors)
    print('Exception during Gemini API call: $e');
    await LocalLogService().logErrorLocal('Exception during Gemini API call', error: e, stackTrace: s); // Updated to LocalLogService
    return 'Error: An exception occurred while calling the API: ${e.toString()}';
  }
}
