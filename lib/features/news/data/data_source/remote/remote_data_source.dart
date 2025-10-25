import 'package:dartz/dartz.dart';

import '../../../../../core/network/api_consumer.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/result_extensions.dart';
import '../../models/request/news_request.dart';
import '../../models/response/news_model.dart';
import '../../repository/endpoints.dart';

abstract class NewsRemoteDataSource {
  Future<Result<List<NewsModel>>> fetchItems(NewsRequest request);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  NewsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<List<NewsModel>>> fetchItems(NewsRequest request) async {
    final result = await _apiConsumer.get<List<NewsModel>>(
      path: NewsEndpoints.baseUrl,
      queryParameters: request.toJson(),
      parser: (json) => (json['data'] as List)
          .map((item) => NewsModel.fromJson(item))
          .toList(),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }
}
