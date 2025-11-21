import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/cubit/settings_cubit.dart';

class UrlInputWidget extends StatelessWidget {
  const UrlInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();
    final controller = TextEditingController(text: cubit.state.currentUrl);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WEBVIEW CONFIGURATION',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,

          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.language),
            hintText: 'https://easacc.com',
            border: OutlineInputBorder(),
          ),
          onChanged: cubit.saveUrl,
        ),
        const SizedBox(height: 4),
        const Text(
          '* Must start with http:// or https://',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
