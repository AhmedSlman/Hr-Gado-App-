import '../models/request/vacation_request.dart';
import '../models/response/vacation_model.dart';
import '../../../../../core/error/result_extensions.dart';

abstract class VacationRepository {
  Future<Result<List<VacationModel>>> fetchItems(VacationRequest request);
}


