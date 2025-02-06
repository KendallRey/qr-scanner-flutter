import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

@HiveType(typeId: 1)
class ScanItem {
  @HiveField(0)
  String id;

  @HiveField(1)
  String createdAt;

  @HiveField(2)
  String lastScanAt;

  @HiveField(3)
  bool isError;

  ScanItem(
      {required this.id,
      required this.createdAt,
      required this.lastScanAt,
      this.isError = false});

  @override
  String toString() {
    return id;
  }

  factory ScanItem.create(String id) {
    final now = DateTime.now();
    String createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String lastScanAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return ScanItem(id: id, createdAt: createdAt, lastScanAt: lastScanAt);
  }

  void updateLastScan() {
    final now = DateTime.now();
    String lastScanAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    this.lastScanAt = lastScanAt;
  }
}
