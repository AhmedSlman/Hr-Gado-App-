import 'home_repository.dart';
import '../data_source/local/local_data_source.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/request/home_request.dart';
import '../models/response/home_model.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/result_extensions.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<HomeModel>>> fetchItems(HomeRequest request) async {
    final result = await remoteDataSource.fetchItems(request);
    return result;
  }
}
