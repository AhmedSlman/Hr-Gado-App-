import 'package:dartz/dartz.dart';

import '../../../../../core/network/api_consumer.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/result_extensions.dart';
import '../../models/request/time_sheet_request.dart';
import '../../models/response/time_sheet_model.dart';
import 'endpoints.dart';

abstract class TimeSheetRemoteDataSource {
  Future<Result<List<TimeSheetModel>>> fetchItems(TimeSheetRequest request);
}

class TimeSheetRemoteDataSourceImpl implements TimeSheetRemoteDataSource {
  final ApiConsumer _apiConsumer;
  TimeSheetRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<List<TimeSheetModel>>> fetchItems(
    TimeSheetRequest request,
  ) async {
    final result = await _apiConsumer.get<List<TimeSheetModel>>(
      path: TimeSheetEndpoints.baseUrl,
      queryParameters: request.toJson(),
      parser: (json) => (json['data'] as List)
          .map((item) => TimeSheetModel.fromJson(item))
          .toList(),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }
}
