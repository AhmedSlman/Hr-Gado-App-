import '../models/response/vacation_model.dart';
import '../../../../../core/error/result_extensions.dart';
import '../models/request/vacation_submit_request.dart';
import '../models/response/api_message_response.dart';
import '../models/response/vacation_list_response.dart';
import '../models/response/advance_list_response.dart';

abstract class VacationRepository {
  Future<Result<ApiMessageResponse>> submit(VacationSubmitRequest request);
  Future<Result<ApiMessageResponse>> submitAdvance(
    AdvanceSubmitRequest request,
  );
  Future<Result<VacationListResponse>> fetchVacations();
  Future<Result<AdvanceListResponse>> fetchAdvances();
}
