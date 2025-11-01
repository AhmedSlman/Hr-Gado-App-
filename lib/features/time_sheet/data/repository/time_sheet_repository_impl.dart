import 'time_sheet_repository.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/request/time_sheet_request.dart';
import '../models/request/permission_request.dart';
import '../models/response/time_sheet_model.dart';
import '../../../../../core/error/result_extensions.dart';

class TimeSheetRepositoryImpl implements TimeSheetRepository {
  final TimeSheetRemoteDataSource remoteDataSource;

  TimeSheetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<TimeSheetModel>>> fetchItems(
    TimeSheetRequest request,
  ) async {
    final result = await remoteDataSource.fetchItems(request);
    return result;
  }

  @override
  Future<Result<String>> submitPermissionRequest(
    PermissionRequest request,
  ) async {
    final result = await remoteDataSource.submitPermissionRequest(request);
    return result;
  }
}
