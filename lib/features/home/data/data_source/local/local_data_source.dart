import '../../../../../core/cache/hive_service.dart';
import '../../models/response/home_model.dart';

abstract class HomeLocalDataSource {
  Future<void> cacheItems(List<HomeModel> items);
  Future<List<HomeModel>> getCachedItems();
  Future<void> clearCache();
  Future<void> logCache();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final HiveService _hiveService = HiveService();
  static const String _boxName = 'home_box';
  static const String _dataKey = 'home_data';

  @override
  Future<void> cacheItems(List<HomeModel> items) async {
    try {
      // final data = items.map((item) => item.toJson()).toList();
      await _hiveService.put(_boxName, _dataKey, "");
    } catch (e) {
      print('Error caching home items: $e');
    }
  }

  @override
  Future<List<HomeModel>> getCachedItems() async {
    try {
      final cachedData = await _hiveService.get(_boxName, _dataKey);
      if (cachedData != null) {
        return (cachedData as List)
            .map((item) => HomeModel.fromJson(item))
            .toList();
      }
      return <HomeModel>[];
    } catch (e) {
      print('Error getting cached home items: $e');
      return <HomeModel>[];
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _hiveService.delete(_boxName, _dataKey);
    } catch (e) {
      print('Error clearing home cache: $e');
    }
  }

  @override
  Future<void> logCache() async {
    await _hiveService.logBoxData(_boxName);
  }
}
