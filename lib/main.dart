import 'package:flutter/material.dart';
import 'screen2_words_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
}class _MyHomePageState extends State<MyHomePage> {
  String? _selectedLearnLanguage;
  String? _selectedNativeLanguage;
  double _level = 0.0;

  // Add translations for other languages here
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'learn_language': 'Language you are going to learn',
      'native_language': 'Your native language',
      'level': 'Level',
      'start_tutoring': 'Start Tutoring',
      'app_title': 'LangPocket - pocket language tutor',
    },
    'zh': {
      'learn_language': '您将要学习的语言',
      'native_language': '您的母语',
      'level': '级别',
      'start_tutoring': '开始辅导',
      'app_title': 'LangPocket - 口袋语言导师',
    },
    'es': {
      'learn_language': 'Idioma que vas a aprender',
      'native_language': 'Tu idioma nativo',
      'level': 'Nivel',
      'start_tutoring': 'Empezar a enseñar',
      'app_title': 'LangPocket - tutor de idiomas de bolsillo',
    },
    'hi': {
      'learn_language': 'जिस भाषा को आप सीखने जा रहे हैं',
      'native_language': 'आपकी मातृभाषा',
      'level': 'स्तर',
      'start_tutoring': 'शिक्षण शुरू करें',
      'app_title': 'LangPocket - पॉकेट भाषा ट्यूटर',
    },
    'ar': {
      'learn_language': 'اللغة التي ستتعلمها',
      'native_language': 'لغتك الأم',
      'level': 'المستوى',
      'start_tutoring': 'ابدأ التدريس',
      'app_title': 'LangPocket - مدرس لغة الجيب',
    },
    'ru': {'learn_language': '', 'native_language': '', 'level': '', 'start_tutoring': '', 'app_title': ''}, // Russian
    'ja': {'learn_language': '', 'native_language': '', 'level': '', 'start_tutoring': '', 'app_title': ''}, // Japanese
    'pa': {'learn_language': '', 'native_language': '', 'level': '', 'start_tutoring': '', 'app_title': ''}, // Punjabi
    // Add translations for other languages here
  };

  final List<String> _learnLanguages = ['English'];
  final List<String> _nativeLanguages = [
    'Mandarin Chinese (普通话)',
    'Spanish (Español)',
    'Turkish',
    'Hindi (हिन्दी)',
    'Arabic (العربية)',
    'Portuguese (Português)',
    'Russian (Русский)',
    'Japanese (日本語)',
    'Punjabi (ਪੰਜਾਬੀ)'
  ];

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
    super.initState();
    _selectedLearnLanguage = _learnLanguages.first;
    _selectedNativeLanguage = _nativeLanguages.first;
  }

  void _onLevelChanged(double value) {
    setState(() {
      _level = value;
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
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.title: const Text('LangPocket - pocket language tutor'),
        title: const Text('LangPocket - pocket language tutor'),
      ),
      body: Center(
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
                  items: _learnLanguages
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
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
                  items: _nativeLanguages
                      .map<DropdownMenuItem<String>>((String value) {
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
                  label: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'][_level.round()],
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmotionWordsScreen(nativeLanguageCode: _getLanguageCode(_selectedNativeLanguage!))),
                   );
                  },
                  child: const Text('Start Tutoring'),
                ),
              ],
            ),
        ),
      ),
    );
  }
}
