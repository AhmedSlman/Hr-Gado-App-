import 'package:hr_app/features/home/data/models/request/attendance_requset_model.dart';
import 'package:hr_app/features/home/data/models/request/daily_report_request_model.dart';

import 'home_repository.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/response/attendance_model.dart';
import '../models/response/daily_report_response_model.dart';
import '../models/response/home_screen_model.dart';
import '../../../../../core/error/result_extensions.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<AttendanceResponseModel>> checkIn(
    AttendanceRequestModel request,
  ) async {
    final result = await remoteDataSource.checkIn(request);
    return result;
  }

  @override
  Future<Result<AttendanceResponseModel>> checkOut(
    AttendanceRequestModel request,
  ) async {
    final result = await remoteDataSource.checkOut(request);
    return result;
  }

  @override
  Future<Result<DailyReportResponseModel>> submitDailyReport(
    DailyReportRequestModel request,
  ) async {
    final result = await remoteDataSource.submitDailyReport(request);
    return result;
  }

  @override
  Future<Result<HomeScreenModel>> getHomeScreen() async {
    final result = await remoteDataSource.getHomeScreen();
    return result;
  }
}
