import 'package:flutter/material.dart';

class WebViewEmptyWidget extends StatelessWidget {
  const WebViewEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.web_asset_off, size: 100, color: Colors.grey),
          const SizedBox(height: 16),
          const Text("No URL Configured"),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            child: const Text("Go to Settings"),
          ),
        ],
      ),
    );
  }
}
