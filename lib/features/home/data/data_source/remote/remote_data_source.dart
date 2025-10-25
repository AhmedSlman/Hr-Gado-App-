import 'package:dartz/dartz.dart';
import 'package:hr_app/features/home/data/models/request/attendance_requset_model.dart';

import '../../../../../core/network/api_consumer.dart';
import '../../../../../core/error/result_extensions.dart';
import '../../models/response/attendance_model.dart';
import '../../models/response/home_screen_model.dart';
import '../local/endpoints.dart';

abstract class HomeRemoteDataSource {
  Future<Result<AttendanceResponseModel>> checkIn(
    AttendanceRequestModel request,
  );
  Future<Result<AttendanceResponseModel>> checkOut(
    AttendanceRequestModel request,
  );
  Future<Result<HomeScreenModel>> getHomeScreen();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiConsumer _apiConsumer;
  HomeRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<AttendanceResponseModel>> checkIn(
    AttendanceRequestModel request,
  ) async {
    final result = await _apiConsumer.post<AttendanceResponseModel>(
      path: HomeEndpoints.attendance,
      queryParameters: request.toJson(),
      parser: (json) => AttendanceResponseModel.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<AttendanceResponseModel>> checkOut(
    AttendanceRequestModel request,
  ) async {
    final result = await _apiConsumer.post<AttendanceResponseModel>(
      path: HomeEndpoints.attendance,
      queryParameters: request.toJson(),
      parser: (json) => AttendanceResponseModel.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<HomeScreenModel>> getHomeScreen() async {
    final result = await _apiConsumer.get<HomeScreenModel>(
      path: HomeEndpoints.homeScreen,
      parser: (json) => HomeScreenModel.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }
}
