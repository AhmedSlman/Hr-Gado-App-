import 'package:dartz/dartz.dart';

import '../../../../../core/network/api_consumer.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/result_extensions.dart';
import '../../models/request/account_request.dart';
import '../../models/response/account_model.dart';
import '../../repository/endpoints.dart';

abstract class AccountRemoteDataSource {
  Future<Result<List<AccountModel>>> fetchItems(AccountRequest request);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final ApiConsumer _apiConsumer;
  AccountRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<List<AccountModel>>> fetchItems(AccountRequest request) async {
    final result = await _apiConsumer.get<List<AccountModel>>(
      path: AccountEndpoints.baseUrl,
      queryParameters: request.toJson(),
      parser: (json) => (json['data'] as List)
          .map((item) => AccountModel.fromJson(item))
          .toList(),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }
}
