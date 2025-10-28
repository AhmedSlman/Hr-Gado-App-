import '../models/request/salary_request.dart';
import '../models/response/salary_model.dart';
import '../../../../../core/error/result_extensions.dart';

abstract class SalaryRepository {
  Future<Result<List<SalaryModel>>> fetchItems(SalaryRequest request);
}


