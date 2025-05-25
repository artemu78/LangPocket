import 'package:flutter/material.dart';
import 'package:LangPocket/screens/error_logs_screen.dart'; // Assuming project name LangPocket
// Removed import for MyHomePage as it's no longer used directly for navigation here
import 'package:LangPocket/screens/main_screen.dart'; // Added import for MainScreen

class MainAppScaffold extends StatelessWidget {
  final Widget body;
  final String? screenTitle;

  const MainAppScaffold({
    super.key,
    required this.body,
    this.screenTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle ?? 'LangPocket'),
        backgroundColor: Theme.of(context).colorScheme.primary, // Or inversePrimary, let's try primary
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // Important: Remove any padding from the ListView.
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile( // Added "Home" ListTile
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()), // Changed to MainScreen
                  (Route<dynamic> route) => false, // Remove all routes below
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                showDialog<void>(
                  context: context, // This context should be fine as MainAppScaffold is built by screen context
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('About LangPocket'),
                      content: const SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('Version: 1.0.3'),
                            SizedBox(height: 8),
                            Text('LangPocket is a pocket tutor for your language learning cards, helping you build and review vocabulary with ease.'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(dialogContext).pop(); // Close the dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.error_outline),
              title: const Text('Error Logs'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Check if we are already on ErrorLogsScreen to prevent pushing it again
                // One way is to check ModalRoute.of(context)?.settings.name
                // However, for simplicity now, we'll just push.
                // If ErrorLogsScreen itself uses MainAppScaffold, tapping this from ErrorLogsScreen's drawer
                // would push another ErrorLogsScreen on top. This might be acceptable or need refinement later.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ErrorLogsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
