import 'vacation_repository.dart';
import '../data_source/local/local_data_source.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/response/vacation_model.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/result_extensions.dart';
import '../models/request/vacation_submit_request.dart';
import '../models/response/api_message_response.dart';
import '../models/response/vacation_list_response.dart';
import '../models/response/advance_list_response.dart';

class VacationRepositoryImpl implements VacationRepository {
  final VacationRemoteDataSource remoteDataSource;

  VacationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<ApiMessageResponse>> submit(
    VacationSubmitRequest request,
  ) async {
    final result = await remoteDataSource.submit(request);
    return result;
  }

  @override
  Future<Result<ApiMessageResponse>> submitAdvance(
    AdvanceSubmitRequest request,
  ) async {
    final result = await remoteDataSource.submitAdvance(request);
    return result;
  }

  @override
  Future<Result<VacationListResponse>> fetchVacations() async {
    final result = await remoteDataSource.fetchVacations();
    return result;
  }

  @override
  Future<Result<AdvanceListResponse>> fetchAdvances() async {
    final result = await remoteDataSource.fetchAdvances();
    return result;
  }
}
