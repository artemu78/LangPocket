// lib/services/logging_service.dart

import 'package:google_cloud_logging/google_cloud_logging.dart';
import 'package:LangPocket/config/constants.dart'; // Corrected import path

// It's good practice to use a specific logger name
final _logger = GoogleCloudLogging(projectId: googleCloudProjectId).logger('LangPocketApp');

Future<void> logError(
  String message, {
  Object? error,
  StackTrace? stackTrace,
}) async {
  try {
    print('Logging error: $message, Error: $error'); // For local debugging
    
    final entry = LogEntry(
      severity: Severity.error,
      message: message,
      // Add more structured data if needed, for example, the error object and stack trace
      // For just a simple message, this is fine.
      // For more complex scenarios, you might want to include 'error.toString()' and 'stackTrace.toString()'
      // in the jsonPayload if the backend supports it or if you structure your logs that way.
      jsonPayload: {
        'message': message,
        if (error != null) 'error': error.toString(),
        if (stackTrace != null) 'stackTrace': stackTrace.toString(),
      },
    );
    
    await _logger.writeEntries([entry]);
    print('Successfully logged to Google Cloud Logging.'); // For local debugging
  } catch (e, s) {
    // If logging to Google Cloud fails, print to console as a fallback.
    // Avoid trying to log this error using logError again, to prevent infinite loops.
    print('Failed to send log to Google Cloud Logging: $e');
    print('Original error: $message, Error: $error, StackTrace: $stackTrace');
    print('Logging service stacktrace: $s');
  }
}
