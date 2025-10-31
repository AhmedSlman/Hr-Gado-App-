import '../../../../../core/cache/hive_service.dart';
import '../../models/response/vacation_model.dart';

abstract class VacationLocalDataSource {
  Future<void> cacheItems(List<VacationModel> items);
  Future<List<VacationModel>> getCachedItems();
  Future<void> clearCache();
  Future<void> logCache();
}

class VacationLocalDataSourceImpl implements VacationLocalDataSource {
  final HiveService _hiveService = HiveService();
  static const String _boxName = 'vacation_box';
  static const String _dataKey = 'vacation_data';

  @override
  Future<void> cacheItems(List<VacationModel> items) async {
    try {
      // final data = items.map((item) => item.toJson()).toList();
      await _hiveService.put(_boxName, _dataKey, "data");
    } catch (e) {
      print('Error caching vacation items: $e');
    }
  }

  @override
  Future<List<VacationModel>> getCachedItems() async {
    try {
      final cachedData = await _hiveService.get(_boxName, _dataKey);
      if (cachedData != null) {
        return (cachedData as List)
            .map((item) => VacationModel.fromJson(item))
            .toList();
      }
      return <VacationModel>[];
    } catch (e) {
      print('Error getting cached vacation items: $e');
      return <VacationModel>[];
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _hiveService.delete(_boxName, _dataKey);
    } catch (e) {
      print('Error clearing vacation cache: $e');
    }
  }

  @override
  Future<void> logCache() async {
    await _hiveService.logBoxData(_boxName);
  }
}
