import 'package:flutter/material.dart';
import 'package:LangPocket/services/local_log_service.dart'; // Assuming project name LangPocket
import 'package:LangPocket/widgets/main_app_scaffold.dart'; // Added import

class ErrorLogsScreen extends StatefulWidget {
  const ErrorLogsScreen({super.key});

  @override
  State<ErrorLogsScreen> createState() => _ErrorLogsScreenState();
}

class _ErrorLogsScreenState extends State<ErrorLogsScreen> {
  final LocalLogService _logService = LocalLogService();
  List<Map<String, dynamic>> _logs = [];
  bool _isLoading = false;
  bool _canLoadMore = true;
  int _currentOffset = 0;
  int _totalLogCount = 0;
  final int _limit = 15;

  @override
  void initState() {
    super.initState();
    _refreshLogs();
  }

  Future<void> _fetchLogs({bool append = false}) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final newLogs = await _logService.getLogs(
        limit: _limit,
        offset: _currentOffset,
      );
      if (!mounted) return;

      setState(() {
        if (append) {
          _logs.addAll(newLogs);
        } else {
          _logs = newLogs;
        }
        _currentOffset = _logs.length;
        _canLoadMore =
            newLogs.length == _limit && _logs.length < _totalLogCount;
      });
    } catch (e) {
      // Handle error, maybe show a snackbar
      print("Error fetching logs: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch logs: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _getTotalLogCount() async {
    if (!mounted) return;
    try {
      _totalLogCount = await _logService.getLogCount();
      // After getting total count, we might need to re-evaluate _canLoadMore
      setState(() {
        _canLoadMore = _logs.length < _totalLogCount;
      });
    } catch (e) {
      print("Error fetching total log count: $e");
    }
  }

  Future<void> _refreshLogs() async {
    if (!mounted) return;
    _currentOffset = 0;
    _logs.clear(); // Clear existing logs before refreshing
    await _getTotalLogCount(); // Get total count first
    await _fetchLogs(append: false); // Then fetch the first page
  }

  Future<void> _purgeLogs() async {
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Purge'),
          content: const Text(
            'Are you sure you want to delete all logs? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Purge'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await _logService.purgeLogs();
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('All logs purged.')));
        await _refreshLogs(); // Refresh the log list
      } catch (e) {
        print("Error purging logs: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to purge logs: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // The IconButton for purging logs that was in the AppBar is removed with the old AppBar.
    // The _purgeLogs function is still part of the state, but not directly callable from the AppBar anymore.
    // We might add a button for it in the body later if needed.
    return MainAppScaffold(
      // Replaced Scaffold
      screenTitle: 'Error Logs', // Passed screenTitle
      body: Container(
        // Wrapped existing body with Container
        color: Theme.of(context).colorScheme.surface,
        width: double.infinity,
        height: double.infinity,
        child: RefreshIndicator(
          onRefresh: _refreshLogs,
          child: Column(
            children: [
              Expanded(
                child:
                    _isLoading && _logs.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : _logs.isEmpty
                        ? Center(
                          child: Text(
                            'No logs found.',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                        : ListView.builder(
                          itemCount: _logs.length,
                          itemBuilder: (context, index) {
                            final log = _logs[index];
                            final timestamp =
                                log['timestamp'] != null
                                    ? DateTime.parse(log['timestamp'] as String)
                                    : null;
                            final message = log['message'] as String?;
                            final error = log['error'] as String?;
                            final stackTrace = log['stackTrace'] as String?;

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              child: ExpansionTile(
                                title: Text(
                                  message ?? 'No message',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  timestamp?.toLocal().toString() ??
                                      'No timestamp',
                                ),
                                children: <Widget>[
                                  if (_canLoadMore && !_isLoading)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            child: const Text('Load More'),
                                            onPressed:
                                                () => _fetchLogs(append: true),
                                          ),
                                          const SizedBox(width: 16),
                                          ElevatedButton(
                                            child: const Text('Purge Logs'),
                                            onPressed: _purgeLogs,
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (stackTrace != null &&
                                      stackTrace.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Stack Trace:',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SelectableText(
                                            stackTrace,
                                            style: const TextStyle(
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if ((error == null || error.isEmpty) &&
                                      (stackTrace == null ||
                                          stackTrace.isEmpty))
                                    const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(
                                        'No further details available.',
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
              if (_isLoading && _logs.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              if (_canLoadMore && !_isLoading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text('Load More'),
                    onPressed: () => _fetchLogs(append: true),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
