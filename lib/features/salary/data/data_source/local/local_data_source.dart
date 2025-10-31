import '../../../../../core/cache/hive_service.dart';
import '../../models/response/salary_model.dart';

abstract class SalaryLocalDataSource {
  Future<void> cacheItems(List<SalarySummaryResponse> items);
  Future<List<SalarySummaryResponse>> getCachedItems();
  Future<void> clearCache();
  Future<void> logCache();
}

class SalaryLocalDataSourceImpl implements SalaryLocalDataSource {
  final HiveService _hiveService = HiveService();
  static const String _boxName = 'salary_box';
  static const String _dataKey = 'salary_data';

  @override
  Future<void> cacheItems(List<SalarySummaryResponse> items) async {
    try {
      // final data = items.map((item) => item.toJson()).toList();
      await _hiveService.put(_boxName, _dataKey, "");
    } catch (e) {
      print('Error caching salary items: $e');
    }
  }

  @override
  Future<List<SalarySummaryResponse>> getCachedItems() async {
    try {
      final cachedData = await _hiveService.get(_boxName, _dataKey);
      if (cachedData != null) {
        return (cachedData as List)
            .map((item) => SalarySummaryResponse.fromJson(item))
            .toList();
      }
      return <SalarySummaryResponse>[];
    } catch (e) {
      print('Error getting cached salary items: $e');
      return <SalarySummaryResponse>[];
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _hiveService.delete(_boxName, _dataKey);
    } catch (e) {
      print('Error clearing salary cache: $e');
    }
  }

  @override
  Future<void> logCache() async {
    await _hiveService.logBoxData(_boxName);
  }
}
