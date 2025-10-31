import '../../../../../core/error/result_extensions.dart';
import '../models/request/create_news_request.dart';
import '../models/request/news_request.dart';
import '../models/response/create_news_response.dart';
import '../models/response/employee_model.dart';
import '../models/response/news_model.dart';

abstract class NewsRepository {
  Future<Result<List<NewsModel>>> fetchItems(NewsRequest request);
  Future<Result<CreateNewsResponse>> createNews(CreateNewsRequest request);
  Future<Result<EmployeesResponse>> getEmployees();
}
