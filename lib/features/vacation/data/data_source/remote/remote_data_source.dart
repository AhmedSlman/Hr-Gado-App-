import 'package:dartz/dartz.dart';

import '../../../../../core/network/api_consumer.dart';
import '../../../../../core/error/result_extensions.dart';
import '../../models/request/vacation_request.dart';
import '../../models/response/vacation_model.dart';
import 'endpoints.dart';

abstract class VacationRemoteDataSource {
  Future<Result<List<VacationModel>>> fetchItems(VacationRequest request);
}

class VacationRemoteDataSourceImpl implements VacationRemoteDataSource {
  final ApiConsumer _apiConsumer;
  VacationRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<List<VacationModel>>> fetchItems(
    VacationRequest request,
  ) async {
    final result = await _apiConsumer.get<List<VacationModel>>(
      path: VacationEndpoints.baseUrl,
      queryParameters: request.toJson(),
      parser: (json) => (json['data'] as List)
          .map((item) => VacationModel.fromJson(item))
          .toList(),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }
}
