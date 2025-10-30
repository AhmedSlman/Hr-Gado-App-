import 'package:dartz/dartz.dart';

import '../../../../../core/network/api_consumer.dart';
import '../../../../../core/error/result_extensions.dart';
import '../../models/response/vacation_model.dart';
import '../../models/request/vacation_submit_request.dart';
import 'endpoints.dart';
import '../../models/response/api_message_response.dart';
import '../../models/response/vacation_list_response.dart';
import '../../models/response/advance_list_response.dart';

abstract class VacationRemoteDataSource {
  Future<Result<ApiMessageResponse>> submit(VacationSubmitRequest request);
  Future<Result<ApiMessageResponse>> submitAdvance(
    AdvanceSubmitRequest request,
  );
  Future<Result<VacationListResponse>> fetchVacations();
  Future<Result<AdvanceListResponse>> fetchAdvances();
}

class VacationRemoteDataSourceImpl implements VacationRemoteDataSource {
  final ApiConsumer _apiConsumer;
  VacationRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<ApiMessageResponse>> submit(
    VacationSubmitRequest request,
  ) async {
    final result = await _apiConsumer.post<ApiMessageResponse>(
      path: VacationEndpoints.submit,
      body: request.toFormMap(),
      isFormData: true,
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) => ApiMessageResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<ApiMessageResponse>> submitAdvance(
    AdvanceSubmitRequest request,
  ) async {
    final result = await _apiConsumer.post<ApiMessageResponse>(
      path: AdvanceEndpoints.submit,
      body: request.toFormMap(),
      isFormData: true,
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) => ApiMessageResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<VacationListResponse>> fetchVacations() async {
    final result = await _apiConsumer.get<VacationListResponse>(
      path: VacationEndpoints.submit,
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) => VacationListResponse.fromRoot(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<AdvanceListResponse>> fetchAdvances() async {
    final result = await _apiConsumer.get<AdvanceListResponse>(
      path: AdvanceEndpoints.list,
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) => AdvanceListResponse.fromRoot(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }
}
