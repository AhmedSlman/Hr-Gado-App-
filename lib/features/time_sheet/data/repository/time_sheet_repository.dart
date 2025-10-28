import '../models/request/time_sheet_request.dart';
import '../models/response/time_sheet_model.dart';
import '../../../../../core/error/result_extensions.dart';

abstract class TimeSheetRepository {
  Future<Result<List<TimeSheetModel>>> fetchItems(TimeSheetRequest request);
}


