import 'package:hr_app/features/home/data/models/request/attendance_requset_model.dart';

import '../models/response/attendance_model.dart';
import '../models/response/home_screen_model.dart';
import '../../../../../core/error/result_extensions.dart';

abstract class HomeRepository {
  Future<Result<AttendanceResponseModel>> checkIn(
    AttendanceRequestModel request,
  );
  Future<Result<AttendanceResponseModel>> checkOut(
    AttendanceRequestModel request,
  );
  Future<Result<HomeScreenModel>> getHomeScreen();
}
