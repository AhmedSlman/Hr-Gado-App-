import 'package:dartz/dartz.dart';

import '../../../../../core/error/result_extensions.dart';
import '../../../../../core/network/api_consumer.dart';
import '../../models/request/create_news_request.dart';
import '../../models/request/news_request.dart';
import '../../models/response/create_news_response.dart';
import '../../models/response/employee_model.dart';
import '../../models/response/news_model.dart';
import '../../repository/endpoints.dart';

abstract class NewsRemoteDataSource {
  Future<Result<List<NewsModel>>> fetchItems(NewsRequest request);
  Future<Result<CreateNewsResponse>> createNews(CreateNewsRequest request);
  Future<Result<EmployeesResponse>> getEmployees();
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  NewsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<List<NewsModel>>> fetchItems(NewsRequest request) async {
    final result = await _apiConsumer.get<List<NewsModel>>(
      path: NewsEndpoints.articles,
      queryParameters: request.toJson(),
      parser: (json) => (json['data'] as List)
          .map((item) => NewsModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<CreateNewsResponse>> createNews(
    CreateNewsRequest request,
  ) async {
    final result = await _apiConsumer.post<CreateNewsResponse>(
      path: NewsEndpoints.createArticle,
      body: request.toJson(),
      isFormData: true,
      parser: (json) => CreateNewsResponse.fromJson(json),
      showLoading: true,
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<EmployeesResponse>> getEmployees() async {
    final result = await _apiConsumer.get<EmployeesResponse>(
      path: NewsEndpoints.employees,
      parser: (json) => EmployeesResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }
}
