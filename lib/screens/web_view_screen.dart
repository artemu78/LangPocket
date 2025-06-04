import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:LangPocket/services/local_log_service.dart'; // Assuming this path is correct

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final _urlController = TextEditingController(text: 'https://flutter.dev');
  final _headers = <Map<String, dynamic>>[
    {'key': 'User-Agent', 'value': 'LangPocketWebView/1.0', 'enabled': true},
  ];
  InAppWebViewController? _webViewController;
  final LocalLogService _logService = LocalLogService();
  final _cookieController = TextEditingController(); // Added cookie controller
  PullToRefreshController? _pullToRefreshController;
  double _progress = 0;

  @override
  void initState() {
    super.initState();

    _pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (TargetPlatform.android == Theme.of(context).platform) {
          _webViewController?.reload();
        } else if (TargetPlatform.iOS == Theme.of(context).platform) {
          _webViewController?.loadUrl(
              urlRequest: URLRequest(url: await _webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _cookieController.dispose(); // Dispose cookie controller
    super.dispose();
  }

  void _addHeader() {
    setState(() {
      _headers.add({'key': '', 'value': '', 'enabled': false});
    });
  }

  void _removeHeader(int index) {
    setState(() {
      _headers.removeAt(index);
    });
  }

  Future<void> _go() async { // Made method async
    final urlString = _urlController.text.trim();
    if (urlString.isEmpty) {
      if (mounted) { // Check if widget is still mounted before showing SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a URL')),
        );
      }
      return;
    }

    // Cookie handling logic
    final cookieManager = CookieManager.instance();
    String rawCookieString = _cookieController.text.trim();

    if (rawCookieString.isNotEmpty) {
      final webUri = WebUri(urlString); // urlString must be valid here
      if (webUri.host.isNotEmpty) {
        List<String> cookiePairs = rawCookieString.split(';');
        for (String cookiePair in cookiePairs) {
          List<String> parts = cookiePair.trim().split('=');
          if (parts.length == 2) {
            String cookieName = parts[0].trim();
            String cookieValue = parts[1].trim();
            if (cookieName.isNotEmpty) {
              try {
                await cookieManager.setCookie(
                  url: webUri,
                  name: cookieName,
                  value: cookieValue,
                  domain: webUri.host, // Using webUri.host directly
                  path: "/",
                  isSecure: webUri.scheme == "https",
                );
                print('VERBOSE: Setting cookie: $cookieName=$cookieValue for domain ${webUri.host}');
              } catch (e, s) {
                _logService.logErrorLocal('Failed to set cookie $cookieName', error: e, stackTrace: s);
                 if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error setting cookie: $cookieName')),
                  );
                }
              }
            }
          } else if (cookiePair.trim().isNotEmpty) { // Log if not empty and not a valid pair
            print('WARN: Malformed cookie part: "${cookiePair.trim()}"');
          }
        }
      } else {
        print('WARN: URL has no host, cannot set cookies: $urlString');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('URL has no host, cannot set cookies.')),
          );
        }
      }
    }

    if (_webViewController != null) {
      final activeHeaders = <String, String>{};
      for (var header in _headers) {
        if (header['enabled'] == true &&
            header['key'] != null &&
            header['key']!.isNotEmpty) {
          activeHeaders[header['key']!] = header['value'] ?? '';
        }
      }
      print('INFO: Navigating to: $urlString with headers: $activeHeaders');
      _webViewController!.loadUrl(
        urlRequest: URLRequest(
          url: WebUri(urlString),
          headers: activeHeaders,
        ),
      );
    } else {
       _logService.logErrorLocal('WebViewController is null. Cannot load URL.');
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('WebView is not ready. Please try again.')),
         );
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web view'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      hintText: 'Enter URL',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _go(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _go,
                  child: const Text('Go'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Request Headers:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: _addHeader,
                  child: const Text('Add Header'),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1, // Give less space to headers compared to webview
            child: ListView.builder(
              itemCount: _headers.length,
              itemBuilder: (context, index) {
                final header = _headers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: header['enabled'],
                        onChanged: (bool? value) {
                          setState(() {
                            header['enabled'] = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        flex: 2, // Assigned flex factor
                        child: TextFormField(
                          initialValue: header['key'],
                          decoration: const InputDecoration(labelText: 'Header Name'),
                          onChanged: (value) => header['key'] = value,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3, // Assigned flex factor
                        child: TextFormField(
                          initialValue: header['value'],
                          decoration: const InputDecoration(labelText: 'Header Value'),
                          onChanged: (value) => header['value'] = value,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeHeader(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Cookie Input Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cookies:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _cookieController,
                  decoration: const InputDecoration(
                    hintText: 'Enter cookie values (e.g., name1=value1; name2=value2)',
                    border: OutlineInputBorder(),
                  ),
                  minLines: 1,
                  maxLines: 4, // Allows for multi-line input and internal scrolling
                ),
              ],
            ),
          ),
          if (_progress < 1.0) LinearProgressIndicator(value: _progress),
          Expanded(
            flex: 3, // Give more space to webview
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri('about:blank')), // Changed Uri.parse to WebUri
              pullToRefreshController: _pullToRefreshController,
              onWebViewCreated: (controller) {
                _webViewController = controller;
                print('INFO: WebView created.');
              },
              onLoadStart: (controller, url) {
                print('INFO: Loading started: ${url.toString()}');
                setState(() {
                  _urlController.text = url.toString();
                  _progress = 0; // Reset progress
                });
              },
              onLoadStop: (controller, url) async {
                _pullToRefreshController?.endRefreshing();
                print('INFO: Loading finished: ${url.toString()}');
                setState(() {
                  if (url != null) { // Ensure url is not null before using
                    _urlController.text = url.toString();
                  }
                   _progress = 1.0; // Ensure progress is full
                });
              },
              onReceivedError: (controller, request, error) {
                _pullToRefreshController?.endRefreshing();
                _logService.logErrorLocal('WebView error: ${error.description} for ${request.url}', error: error);
                 setState(() {
                    _progress = 1.0; // Stop progress on error
                  });
              },
              onReceivedHttpError: (controller, request, errorResponse) {
                _pullToRefreshController?.endRefreshing();
                _logService.logErrorLocal('HTTP error: ${errorResponse.statusCode} ${errorResponse.reasonPhrase} for ${request.url}', error: errorResponse);
                 setState(() {
                    _progress = 1.0; // Stop progress on error
                  });
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
               onConsoleMessage: (controller, consoleMessage) {
                print('CONSOLE: ${consoleMessage.messageLevel.toString()}: ${consoleMessage.message}');
              },
              onAjaxReadyStateChange: (controller, ajaxRequest) async {
                if (ajaxRequest.readyState == AjaxRequestReadyState.DONE) {
                  var requestBody = 'N/A';
                  if (ajaxRequest.data != null && ajaxRequest.data!.isNotEmpty) {
                    requestBody = ajaxRequest.data!;
                  }
                  print('AJAX_REQUEST: URL: ${ajaxRequest.url}, Method: ${ajaxRequest.method}, Headers: ${ajaxRequest.headers}, Body: $requestBody');

                  // It's tricky to get response body directly here for all cases.
                  // The InAppWebView documentation should be consulted for best practices on capturing AJAX responses.
                  // For now, we log what's available in ajaxRequest.responseText or similar if it exists.
                  print('AJAX_RESPONSE: URL: ${ajaxRequest.url}, Status: ${ajaxRequest.status}, StatusText: ${ajaxRequest.statusText}, ResponseType: ${ajaxRequest.responseType}, Response: ${ajaxRequest.responseText?.substring(0, (ajaxRequest.responseText?.length ?? 0) > 500 ? 500 : (ajaxRequest.responseText?.length ?? 0)) ?? "N/A"}');
                }
                return AjaxRequestAction.PROCEED;
              },
            ),
          ),
        ],
      ),
    );
  }
}
