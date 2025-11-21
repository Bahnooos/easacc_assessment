import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String url;

  const CustomWebView({super.key, required this.url});

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  double _progress = 0.0;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  // Senior Logic: If the parent widget passes a new URL (e.g. from Settings),
  // we must detect it and reload.
  @override
  void didUpdateWidget(covariant CustomWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _loadUrl(widget.url);
    }
  }

  void _initializeController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Required for most modern sites
      ..setBackgroundColor(const Color(0x00000000)) // Transparent to avoid white flashes
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            }
          },
          onProgress: (int progress) {
            if (mounted) {
              setState(() => _progress = progress / 100);
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
          onWebResourceError: (WebResourceError error) {
            // Only show error screen for main frame errors, not missing images/css
            if (error.isForMainFrame != null && error.isForMainFrame == true && mounted) {
              setState(() => _hasError = true);
            }
          },
        ),
      );
      
    _loadUrl(widget.url);
  }

  void _loadUrl(String url) {
    if (url.isEmpty) return;
    
    // Basic validation to prevent crash
    final uri = Uri.parse(url);
    if (uri.scheme.isEmpty) {
       // Fallback or handle error if needed
       return;
    }

    _controller.loadRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Empty State
    if (widget.url.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.link_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("No URL Configured"),
          ],
        ),
      );
    }

    // 2. Error State
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text("Failed to load website"),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              onPressed: () => _controller.reload(),
            )
          ],
        ),
      );
    }

    // 3. Success State (Stack handles the loading bar overlay)
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.transparent,
            color: Theme.of(context).primaryColor,
            minHeight: 4,
          ),
      ],
    );
  }
}