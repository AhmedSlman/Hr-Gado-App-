import '../../../../../core/cache/hive_service.dart';
import '../../models/response/time_sheet_model.dart';

abstract class TimeSheetLocalDataSource {
  Future<void> cacheItems(List<TimeSheetModel> items);
  Future<List<TimeSheetModel>> getCachedItems();
  Future<void> clearCache();
  Future<void> logCache();
}

class TimeSheetLocalDataSourceImpl implements TimeSheetLocalDataSource {
  final HiveService _hiveService = HiveService();
  static const String _boxName = 'time_sheet_box';
  static const String _dataKey = 'time_sheet_data';

  @override
  Future<void> cacheItems(List<TimeSheetModel> items) async {
    try {
      // final data = items.map((item) => item.toJson()).toList();
      await _hiveService.put(_boxName, _dataKey, "");
    } catch (e) {
      print('Error caching time_sheet items: $e');
    }
  }

  @override
  Future<List<TimeSheetModel>> getCachedItems() async {
    try {
      final cachedData = await _hiveService.get(_boxName, _dataKey);
      if (cachedData != null) {
        return (cachedData as List)
            .map((item) => TimeSheetModel.fromJson(item))
            .toList();
      }
      return <TimeSheetModel>[];
    } catch (e) {
      print('Error getting cached time_sheet items: $e');
      return <TimeSheetModel>[];
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _hiveService.delete(_boxName, _dataKey);
    } catch (e) {
      print('Error clearing time_sheet cache: $e');
    }
  }

  @override
  Future<void> logCache() async {
    await _hiveService.logBoxData(_boxName);
  }
}
