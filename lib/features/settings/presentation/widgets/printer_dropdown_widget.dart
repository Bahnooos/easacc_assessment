import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/printer_device.dart';
import '../logic/cubit/settings_cubit.dart';

class PrinterDropdownWidget extends StatelessWidget {
  const PrinterDropdownWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();
    final devices = cubit.state.foundDevices;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton<PrinterDevice>(
            isExpanded: true,
            hint: const Text('Select a Printer'),
            value: cubit.state.selectedDevice,
            items: devices
                .map(
                  (device) =>
                      DropdownMenuItem(value: device, child: Text(device.name)),
                )
                .toList(),
            onChanged: cubit.selectDevice,
          ),
        ),
        if (cubit.state.isScanning)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}
