import 'package:dartz/dartz.dart';
import 'package:hr_app/features/home/data/models/request/attendance_requset_model.dart';
import 'package:hr_app/features/home/data/models/request/daily_report_request_model.dart';

import '../../../../../core/network/api_consumer.dart';
import '../../../../../core/error/result_extensions.dart';
import '../../models/response/attendance_model.dart';
import '../../models/response/daily_report_response_model.dart';
import '../../models/response/home_screen_model.dart';
import '../local/endpoints.dart';

abstract class HomeRemoteDataSource {
  Future<Result<AttendanceResponseModel>> checkIn(
    AttendanceRequestModel request,
  );
  Future<Result<AttendanceResponseModel>> checkOut(
    AttendanceRequestModel request,
  );
  Future<Result<DailyReportResponseModel>> submitDailyReport(
    DailyReportRequestModel request,
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
  Future<Result<DailyReportResponseModel>> submitDailyReport(
    DailyReportRequestModel request,
  ) async {
    // إرسال التقرير اليومي في body كـ form data
    final result = await _apiConsumer.post<DailyReportResponseModel>(
      path: HomeEndpoints.dailyReport,
      body: request.toFormMap(),
      isFormData: true,
      headers: const {
        'Accept': 'application/vnd.api+json',
        'Content-Type': 'application/vnd.api+json',
      },
      parser: (json) => DailyReportResponseModel.fromJson(json),
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
