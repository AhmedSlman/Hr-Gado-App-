import 'package:dartz/dartz.dart';

import '../../../../../core/network/api_consumer.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/result_extensions.dart';
import '../../models/request/salary_request.dart';
import '../../models/response/salary_model.dart';
import '../../repository/endpoints.dart';

abstract class SalaryRemoteDataSource {
  Future<Result<List<SalaryModel>>> fetchItems(SalaryRequest request);
}

class SalaryRemoteDataSourceImpl implements SalaryRemoteDataSource {
  final ApiConsumer _apiConsumer;
  SalaryRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<List<SalaryModel>>> fetchItems(SalaryRequest request) async {
    final result = await _apiConsumer.get<List<SalaryModel>>(
      path: SalaryEndpoints.baseUrl,
      queryParameters: request.toJson(),
      parser: (json) => (json['data'] as List)
          .map((item) => SalaryModel.fromJson(item))
          .toList(),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }
}
