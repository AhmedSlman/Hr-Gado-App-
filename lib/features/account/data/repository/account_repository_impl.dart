import 'account_repository.dart';
import '../data_source/local/local_data_source.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/request/account_request.dart';
import '../models/response/account_model.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/result_extensions.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;

  AccountRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<AccountModel>>> fetchItems(AccountRequest request) async {
    final result = await remoteDataSource.fetchItems(request);
    return result;
  }
}
