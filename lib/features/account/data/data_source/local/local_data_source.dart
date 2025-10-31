import '../../../../../core/cache/hive_service.dart';
import '../../models/response/account_model.dart';

abstract class AccountLocalDataSource {
  Future<void> cacheItems(List<AccountModel> items);
  Future<List<AccountModel>> getCachedItems();
  Future<void> clearCache();
  Future<void> logCache();
}

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  final HiveService _hiveService = HiveService();
  static const String _boxName = 'account_box';
  static const String _dataKey = 'account_data';

  @override
  Future<void> cacheItems(List<AccountModel> items) async {
    try {
      // final data = items.map((item) => item.toJson()).toList();
      await _hiveService.put(_boxName, _dataKey, "");
    } catch (e) {
      print('Error caching account items: $e');
    }
  }

  @override
  Future<List<AccountModel>> getCachedItems() async {
    try {
      final cachedData = await _hiveService.get(_boxName, _dataKey);
      if (cachedData != null) {
        return (cachedData as List)
            .map((item) => AccountModel.fromJson(item))
            .toList();
      }
      return <AccountModel>[];
    } catch (e) {
      print('Error getting cached account items: $e');
      return <AccountModel>[];
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _hiveService.delete(_boxName, _dataKey);
    } catch (e) {
      print('Error clearing account cache: $e');
    }
  }

  @override
  Future<void> logCache() async {
    await _hiveService.logBoxData(_boxName);
  }
}
