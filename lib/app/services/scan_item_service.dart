import 'package:hive/hive.dart';
import 'package:qr_scanner/app/core/constants/constants.dart';
import 'package:qr_scanner/app/core/model/scan_item.dart';

class ScanItemService {
  static Future<Box<dynamic>> getHiveBox() async {
    final box = await Hive.openBox(Constants.hiveBox);
    return box;
  }

  static void saveScanItem(ScanItem item) async {
    final box = await getHiveBox();
    await box.put(item.id, item);
  }

  static void deleteScanItem(String id) async {
    final box = await getHiveBox();
    await box.delete(id);
  }

  static void updateScanItem(ScanItem item) async {
    final box = await getHiveBox();
    await box.put(item.id, item);
  }

  // Stream<BoxEvent> getScannedItems () async* {
  //   final box = await getHiveBox();
  //   yield* box.watch();
  // }
}
