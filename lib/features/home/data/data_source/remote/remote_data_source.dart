import 'package:dartz/dartz.dart';

import '../../../../../core/network/api_consumer.dart';
import '../../../../../core/error/result_extensions.dart';
import '../../models/request/home_request.dart';
import '../../models/response/home_model.dart';
import '../local/endpoints.dart';

abstract class HomeRemoteDataSource {
  Future<Result<List<HomeModel>>> fetchItems(HomeRequest request);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiConsumer _apiConsumer;
  HomeRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<List<HomeModel>>> fetchItems(HomeRequest request) async {
    final result = await _apiConsumer.get<List<HomeModel>>(
      path: HomeEndpoints.baseUrl,
      queryParameters: request.toJson(),
      parser: (json) => (json['data'] as List)
          .map((item) => HomeModel.fromJson(item))
          .toList(),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }
}
