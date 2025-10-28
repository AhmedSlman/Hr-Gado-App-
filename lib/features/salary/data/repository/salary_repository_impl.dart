import 'salary_repository.dart';
import '../data_source/local/local_data_source.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/request/salary_request.dart';
import '../models/response/salary_model.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/result_extensions.dart';

class SalaryRepositoryImpl implements SalaryRepository {
  final SalaryRemoteDataSource remoteDataSource;

  SalaryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<SalaryModel>>> fetchItems(SalaryRequest request) async {
    final result = await remoteDataSource.fetchItems(request);
    return result;
  }
}
