import 'package:assisment/core/printer_device.dart';

class SettingsState {
  final String currentUrl;
  final List<PrinterDevice> foundDevices;
  final PrinterDevice? selectedDevice;
  final bool isScanning;
  final String? error;

  SettingsState({
    this.currentUrl = '',
    this.foundDevices = const [],
    this.selectedDevice,
    this.isScanning = false,
    this.error,
  });

  SettingsState copyWith({
    String? currentUrl,
    List<PrinterDevice>? foundDevices,
    PrinterDevice? selectedDevice,
    bool? isScanning,
    String? error,
  }) {
    return SettingsState(
      currentUrl: currentUrl ?? this.currentUrl,
      foundDevices: foundDevices ?? this.foundDevices,
      selectedDevice: selectedDevice ?? this.selectedDevice,
      isScanning: isScanning ?? this.isScanning,
      error: error, // Error is not persisted, passing null clears it
    );
  }
}
