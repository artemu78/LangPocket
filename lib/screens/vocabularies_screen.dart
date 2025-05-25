import 'package:flutter/material.dart';
import '../widgets/main_app_scaffold.dart';
import '../database_helper.dart';

class VocabulariesScreen extends StatefulWidget {
  const VocabulariesScreen({super.key});

  @override
  State<VocabulariesScreen> createState() => _VocabulariesScreenState();
}

class _VocabulariesScreenState extends State<VocabulariesScreen> {
  List<Map<String, dynamic>> _vocabularies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVocabularies();
  }

  Future<void> _loadVocabularies() async {
    // Ensure the widget is still mounted before calling setState
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final vocabulariesData = await DatabaseHelper().getVocabularies();
      // Ensure the widget is still mounted before calling setState
      if (!mounted) return;
      setState(() {
        _vocabularies = vocabulariesData;
        _isLoading = false;
      });
    } catch (e) {
      // Handle any errors, e.g., show a snackbar or log the error
      // Ensure the widget is still mounted before calling setState
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      // For example, print the error to console
      print('Error loading vocabularies: $e');
      // Optionally, show a user-friendly error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load vocabularies.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      screenTitle: 'Vocabularies',
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _vocabularies.isEmpty
              ? const Center(child: Text('No vocabularies found.'))
              : ListView.builder(
                  itemCount: _vocabularies.length,
                  itemBuilder: (context, index) {
                    final vocabulary = _vocabularies[index];
                    return ListTile(
                      title: Text(vocabulary['Name'] ?? 'Unnamed Vocabulary'),
                      // Optionally, add more details or actions here
                      // For example, onTap to navigate to a detail screen
                      // onTap: () {
                      //   // Navigate to vocabulary detail screen
                      // },
                    );
                  },
                ),
    );
  }
}
