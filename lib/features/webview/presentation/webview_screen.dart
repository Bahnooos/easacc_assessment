import 'package:assisment/features/settings/presentation/logic/cubit/settings_cubit.dart';
import 'package:assisment/features/settings/presentation/logic/cubit/settings_state.dart';
import 'package:assisment/features/webview/presentation/custom_web_view.dart';
import 'package:assisment/features/webview/presentation/widgets/webview_appbar_widget.dart';
import 'package:assisment/features/webview/presentation/widgets/webview_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const WebViewAppBarWidget(),
          body:
              state.currentUrl.isNotEmpty && state.currentUrl.startsWith('http')
              ? CustomWebView(url: state.currentUrl)
              : const WebViewEmptyWidget(),
        );
      },
    );
  }
}
