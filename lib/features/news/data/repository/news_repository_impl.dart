import 'news_repository.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/request/news_request.dart';
import '../models/response/news_model.dart';
import '../../../../../core/error/result_extensions.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<NewsModel>>> fetchItems(NewsRequest request) async {
    final result = await remoteDataSource.fetchItems(request);
    return result;
  }
}
