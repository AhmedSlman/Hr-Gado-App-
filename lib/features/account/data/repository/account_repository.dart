import '../models/request/account_request.dart';
import '../models/response/account_model.dart';
import '../../../../../core/error/result_extensions.dart';

abstract class AccountRepository {
  Future<Result<List<AccountModel>>> fetchItems(AccountRequest request);
}


