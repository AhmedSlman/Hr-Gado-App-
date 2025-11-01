import 'package:dartz/dartz.dart';

import '../../../../../core/network/api_consumer.dart';
import '../../../../../core/error/result_extensions.dart';
import '../../models/request/time_sheet_request.dart';
import '../../models/request/permission_request.dart';
import '../../models/response/time_sheet_model.dart';
import 'endpoints.dart';

abstract class TimeSheetRemoteDataSource {
  Future<Result<List<TimeSheetModel>>> fetchItems(TimeSheetRequest request);
  Future<Result<String>> submitPermissionRequest(PermissionRequest request);
}

class TimeSheetRemoteDataSourceImpl implements TimeSheetRemoteDataSource {
  final ApiConsumer _apiConsumer;
  TimeSheetRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<List<TimeSheetModel>>> fetchItems(
    TimeSheetRequest request,
  ) async {
    final result = await _apiConsumer.get<List<TimeSheetModel>>(
      path: TimeSheetEndpoints.attendances,
      queryParameters: request.toJson().isNotEmpty ? request.toJson() : null,
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) {
        final data = (json['data'] ?? []) as List;
        return data
            .map(
              (item) => TimeSheetModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      },
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<String>> submitPermissionRequest(
    PermissionRequest request,
  ) async {
    final result = await _apiConsumer.post<String>(
      path: TimeSheetEndpoints.attendanceRequests,
      body: request.toFormMap(),
      headers: const {
        'Accept': 'application/vnd.api+json',
        'Content-Type': 'application/vnd.api+json',
      },
      isFormData: true,
      parser: (json) {
        return (json['msg'] ?? 'تم إرسال الطلب بنجاح') as String;
      },
    );

    return result.fold(
      onSuccess: (message) => Right(message),
      onFailure: (failure) => Left(failure),
    );
  }
}
