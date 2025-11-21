import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/cubit/settings_cubit.dart';

class PrinterHeaderWidget extends StatelessWidget {
  const PrinterHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'PRINTER CONNECTION',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        TextButton.icon(
          icon: Icon(cubit.state.isScanning ? Icons.stop : Icons.search),
          label: Text(cubit.state.isScanning ? 'Stop' : 'Scan'),
          onPressed: () => cubit.state.isScanning
              ? cubit.stopScanning()
              : cubit.startScanning(),
        ),
      ],
    );
  }
}
