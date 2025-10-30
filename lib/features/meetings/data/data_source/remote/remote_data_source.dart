import 'package:dartz/dartz.dart';

import '../../../../../core/error/result_extensions.dart';
import '../../../../../core/network/api_consumer.dart';
import '../../models/request/create_meeting_request.dart';
import '../../models/response/create_meeting_response.dart';
import '../../models/response/employee_model.dart';
import '../../models/response/meeting_model.dart';
import '../../repository/endpoints.dart';

abstract class MeetingsRemoteDataSource {
  Future<Result<MeetingsResponse>> getMyMeetings();
  Future<Result<EmployeesResponse>> getEmployees();
  Future<Result<CreateMeetingResponse>> createMeeting(
    CreateMeetingRequest request,
  );
}

class MeetingsRemoteDataSourceImpl implements MeetingsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  MeetingsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<MeetingsResponse>> getMyMeetings() async {
    final result = await _apiConsumer.get<MeetingsResponse>(
      path: MeetingsEndpoints.myMeetings,
      parser: (json) => MeetingsResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<EmployeesResponse>> getEmployees() async {
    final result = await _apiConsumer.get<EmployeesResponse>(
      path: MeetingsEndpoints.employees,
      parser: (json) => EmployeesResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<CreateMeetingResponse>> createMeeting(
    CreateMeetingRequest request,
  ) async {
    // API expects participants[] repeated; send as form-data
    final body = <String, dynamic>{
      'title': request.title,
      'date': request.date,
      'time': request.time,
      'link': request.link,
      for (int i = 0; i < request.participants.length; i++)
        'participants[$i]': request.participants[i],
    };

    final result = await _apiConsumer.post<CreateMeetingResponse>(
      path: MeetingsEndpoints.createMeeting,
      body: body,
      isFormData: true,
      parser: (json) => CreateMeetingResponse.fromJson(json),
      showLoading: true,
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }
}
