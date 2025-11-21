import 'dart:async';

import 'package:assisment/core/printer_device.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:nsd/nsd.dart';
import 'package:rxdart/rxdart.dart';
// Ensure this path matches your project structure

class DeviceDiscoveryService {
  // We use BehaviorSubject so the UI instantly gets the latest list
  // even if it rebuilds (e.g. screen rotation).
  final _devicesController = BehaviorSubject<List<PrinterDevice>>.seeded([]);

  // Internal list to accumulate results from both Bluetooth and WiFi
  final List<PrinterDevice> _foundDevices = [];

  // Handle controls
  Discovery? _mdnsDiscovery;
  StreamSubscription? _bleSubscription;

  // Public Stream for the UI to listen to
  Stream<List<PrinterDevice>> get scannedDevices => _devicesController.stream;

  /// Starts the Hybrid Scan (BLE + mDNS)
  Future<void> startScan() async {
    // 1. Reset state
    _foundDevices.clear();
    _devicesController.add([]); // Clear UI list

    // 2. Start Bluetooth Low Energy Scan
    // We don't await this because we want it to run in parallel
    _startBleScan();

    // 3. Start Network (mDNS) Scan
    // Only works if the device is connected to WiFi
    _startMdnsScan();
  }

  /// Stops all scanning to save battery
  Future<void> stopScan() async {
    // Stop BLE
    try {
      await FlutterBluePlus.stopScan();
      await _bleSubscription?.cancel();
    } catch (e) {
      print("Error stopping BLE: $e");
    }

    // Stop mDNS
    try {
      if (_mdnsDiscovery != null) {
        await stopDiscovery(_mdnsDiscovery!);
        _mdnsDiscovery = null;
      }
    } catch (e) {
      print("Error stopping mDNS: $e");
    }
  }

  // --- Bluetooth Logic ---
  void _startBleScan() {
    // Listen to the scan results stream
    _bleSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        // Filter: Printers usually have a name. Ignore unnamed raw devices.
        if (r.device.platformName.isNotEmpty) {
          final device = PrinterDevice(
            id: r.device.remoteId.str, // Mac Address
            name: r.device.platformName,
            type: DeviceType.bluetooth,
          );
          _addDevice(device);
        }
      }
    }, onError: (e) => print("BLE Scan Error: $e"));

    // Start scanning (timeout 15s to save battery)
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
  }

  // --- Network (mDNS) Logic ---
  Future<void> _startMdnsScan() async {
    try {
      // '_ipp._tcp' is the Internet Printing Protocol (Standard for modern printers)
      const String serviceType = '_ipp._tcp';

      // Start discovery
      _mdnsDiscovery = await startDiscovery(
        serviceType,
        ipLookupType: IpLookupType.v4,
      );

      _mdnsDiscovery!.addListener(() {
        for (var service in _mdnsDiscovery!.services) {
          // Android sometimes returns null name initially, fallback to host or "Unknown"
          final String name = service.name ?? service.host ?? "Network Printer";
          final String? ip = service.host; // Use IP as the ID

          if (ip != null) {
            final device = PrinterDevice(
              id: ip,
              name: name,
              type: DeviceType.network,
            );
            _addDevice(device);
          }
        }
      });
    } catch (e) {
      print("mDNS Error: $e");
      // On Android, this might fail if Multicast lock isn't acquired,
      // but the plugin usually handles this.
    }
  }

  // --- Helper to Merge Lists ---
  void _addDevice(PrinterDevice device) {
    // Deduplication logic:
    // We override == in PrinterDevice, so .contains() works automatically.
    if (!_foundDevices.contains(device)) {
      _foundDevices.add(device);
      _devicesController.add(List.from(_foundDevices)); // Update Stream
    }
  }
}
