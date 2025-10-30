import '../../models/response/meeting_model.dart';

abstract class MeetingsLocalDataSource {
  Future<List<MeetingData>> getCachedMeetings();
  Future<void> cacheMeetings(List<MeetingData> meetings);
}

class MeetingsLocalDataSourceImpl implements MeetingsLocalDataSource {
  @override
  Future<List<MeetingData>> getCachedMeetings() async {
    // TODO: Implement local caching logic
    return [];
  }

  @override
  Future<void> cacheMeetings(List<MeetingData> meetings) async {
    // TODO: Implement local caching logic
  }
}
