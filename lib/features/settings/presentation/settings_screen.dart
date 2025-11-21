import 'package:assisment/features/settings/presentation/widgets/printer_dropdown_widget.dart';
import 'package:assisment/features/settings/presentation/widgets/printer_header_widget.dart';
import 'package:assisment/features/settings/presentation/widgets/url_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/cubit/settings_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          TextButton(
            onPressed: () => settings.saveUrl(settings.state.currentUrl),
            child: const Text(
              'Save',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            UrlInputWidget(),
            SizedBox(height: 32),
            PrinterHeaderWidget(),
            SizedBox(height: 8),
            PrinterDropdownWidget(),
          ],
        ),
      ),
    );
  }
}
