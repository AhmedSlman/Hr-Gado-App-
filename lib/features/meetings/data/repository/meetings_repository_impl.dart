import '../../../../../core/error/result_extensions.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/request/create_meeting_request.dart';
import '../models/response/create_meeting_response.dart';
import '../models/response/employee_model.dart';
import '../models/response/meeting_model.dart';
import 'meetings_repository.dart';

class MeetingsRepositoryImpl implements MeetingsRepository {
  final MeetingsRemoteDataSource remoteDataSource;

  MeetingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<MeetingsResponse>> getMyMeetings() async {
    final result = await remoteDataSource.getMyMeetings();
    return result;
  }

  @override
  Future<Result<EmployeesResponse>> getEmployees() async {
    return await remoteDataSource.getEmployees();
  }

  @override
  Future<Result<CreateMeetingResponse>> createMeeting(
    CreateMeetingRequest request,
  ) async {
    return await remoteDataSource.createMeeting(request);
  }
}
