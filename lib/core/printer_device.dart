enum DeviceType { bluetooth, network }

class PrinterDevice {
  final String id;
  final String name;
  final DeviceType type;

  PrinterDevice({
    required this.id,
    required this.name,
    required this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrinterDevice &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}