import '../../../../../core/error/result_extensions.dart';
import '../models/request/create_meeting_request.dart';
import '../models/response/create_meeting_response.dart';
import '../models/response/employee_model.dart';
import '../models/response/meeting_model.dart';

abstract class MeetingsRepository {
  Future<Result<MeetingsResponse>> getMyMeetings();
  Future<Result<EmployeesResponse>> getEmployees();
  Future<Result<CreateMeetingResponse>> createMeeting(
    CreateMeetingRequest request,
  );
}
