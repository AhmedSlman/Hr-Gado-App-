import 'vacation_repository.dart';
import '../data_source/local/local_data_source.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/request/vacation_request.dart';
import '../models/response/vacation_model.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/result_extensions.dart';

class VacationRepositoryImpl implements VacationRepository {
  final VacationRemoteDataSource remoteDataSource;

  VacationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<VacationModel>>> fetchItems(
    VacationRequest request,
  ) async {
    final result = await remoteDataSource.fetchItems(request);
    return result;
  }
}
