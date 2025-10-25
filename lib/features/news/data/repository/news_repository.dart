import '../models/request/news_request.dart';
import '../models/response/news_model.dart';
import '../../../../../core/error/result_extensions.dart';

abstract class NewsRepository {
  Future<Result<List<NewsModel>>> fetchItems(NewsRequest request);
}


