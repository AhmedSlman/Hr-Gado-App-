import '../../../../../core/error/result_extensions.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/request/create_news_request.dart';
import '../models/request/news_request.dart';
import '../models/response/create_news_response.dart';
import '../models/response/employee_model.dart';
import '../models/response/news_model.dart';
import 'news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<NewsModel>>> fetchItems(NewsRequest request) async {
    final result = await remoteDataSource.fetchItems(request);
    return result;
  }

  @override
  Future<Result<CreateNewsResponse>> createNews(
    CreateNewsRequest request,
  ) async {
    return await remoteDataSource.createNews(request);
  }

  @override
  Future<Result<EmployeesResponse>> getEmployees() async {
    return await remoteDataSource.getEmployees();
  }
}
