import '../models/request/home_request.dart';
import '../models/response/home_model.dart';
import '../../../../../core/error/result_extensions.dart';

abstract class HomeRepository {
  Future<Result<List<HomeModel>>> fetchItems(HomeRequest request);
}


