import 'dart:async';

import 'package:assisment/core/device_discovery_service.dart';
import 'package:assisment/core/printer_device.dart';
import 'package:assisment/features/settings/presentation/logic/cubit/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final DeviceDiscoveryService _discoveryService = DeviceDiscoveryService();
  StreamSubscription? _scanSubscription;

  SettingsCubit() : super(SettingsState()) {
    _loadUrl();
  }

  Future<void> _loadUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('saved_url') ?? '';
    emit(state.copyWith(currentUrl: url));
  }

  Future<void> saveUrl(String url) async {
    if (!url.startsWith('http')) {
      emit(state.copyWith(error: "URL must start with http:// or https://"));
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_url', url);
      emit(state.copyWith(currentUrl: url, error: null));
    } catch (e) {
      emit(state.copyWith(error: "Failed to save URL"));
    }
  }

  void selectDevice(PrinterDevice? device) {
    emit(state.copyWith(selectedDevice: device));
  }

  Future<void> startScanning() async {
    if (state.isScanning) return;
    
    emit(state.copyWith(isScanning: true, foundDevices: []));
    
    try {
      await _discoveryService.startScan();
      
      // Listen to the stream from the service
      _scanSubscription?.cancel();
      _scanSubscription = _discoveryService.scannedDevices.listen((devices) {
        emit(state.copyWith(foundDevices: devices));
      });
    } catch (e) {
      emit(state.copyWith(isScanning: false, error: "Scan failed: $e"));
    }
  }

  Future<void> stopScanning() async {
    await _discoveryService.stopScan();
    _scanSubscription?.cancel();
    emit(state.copyWith(isScanning: false));
  }

  @override
  Future<void> close() {
    stopScanning();
    return super.close();
  }
}