import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/core/utils/date_time_helper.dart';
import 'package:hr_app/core/utils/location_service.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/home/data/models/work_report_model.dart';
import 'package:hr_app/features/home/logic/home_cubit.dart';
import 'package:hr_app/features/home/logic/home_states.dart';
import 'package:hr_app/features/home/presentation/widgets/attendance_widget.dart';
import 'package:hr_app/features/home/presentation/widgets/check_in_dialog.dart';
import 'package:hr_app/features/home/presentation/widgets/check_out_dialog.dart';
import 'package:hr_app/features/home/presentation/widgets/report_sammary_dialoage.dart';
import 'package:hr_app/features/home/presentation/widgets/success_dialoage.dart';
import 'package:hr_app/features/home/presentation/widgets/work_report_dialog.dart';

class AttendanceSection extends StatefulWidget {
  const AttendanceSection({super.key});

  @override
  State<AttendanceSection> createState() => _AttendanceSectionState();
}

class _AttendanceSectionState extends State<AttendanceSection> {
  bool _isCheckedIn = false;
  bool _isCheckedOut = false;
  String _checkInTime = '';
  String _checkOutTime = '';
  bool _isLoading = false;

  String _currentDate = '';
  final String _workHours = '8';

  String _workStartTime = '09:00 ص';
  String _workEndTime = '05:00 م';
  String _lastTimeBeforeDeduction = '09:30 ص';

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
    _refreshUserData();
  }

  void _refreshUserData() async {
    await UserHelper.refreshUser();
  }

  void _loadAttendanceData() {
    setState(() {
      _currentDate = DateTimeHelper.getCurrentDate();
    });
  }

  Future<void> _handleCheckIn() async {
    final currentTime = DateTimeHelper.getCurrentTime();

    showDialog(
      context: context,
      builder: (context) => CheckInDialog(
        checkInTime: currentTime,
        onConfirm: () async {
          Navigator.of(context).pop();

          setState(() {
            _isLoading = true;
          });

          try {
            // Get current location
            final coordinates =
                await LocationService.getCurrentLocationCoordinates();
            final latitude = coordinates['latitude']!;
            final longitude = coordinates['longitude']!;

            // Call checkIn with actual location
            sl<HomeCubit>().checkIn(latitude, longitude);
          } catch (e) {
            setState(() {
              _isLoading = false;
            });

            String errorMessage = 'فشل الحصول على الموقع';
            if (e is LocationPermissionException) {
              errorMessage = 'يرجى تفعيل صلاحيات الموقع من الإعدادات';
              // Optionally open settings
              final opened = await LocationService.openLocationSettings();
              if (!opened) {
                CustomSnackBar.showError(
                  context,
                  message: 'يرجى تفعيل صلاحيات الموقع يدوياً من الإعدادات',
                );
              }
            } else if (e is LocationServiceException) {
              errorMessage = 'يرجى تفعيل خدمات الموقع في إعدادات الجهاز';
            } else {
              errorMessage = e.toString();
            }

            CustomSnackBar.showError(context, message: errorMessage);
          }
        },
      ),
    );
  }

  void _handleCheckOut() {
    final currentTime = DateTimeHelper.getCurrentTime();

    _showWorkReportDialog(currentTime);
  }

  void _showWorkReportDialog(String currentTime) {
    showDialog(
      context: context,
      builder: (context) => WorkReportDialog(
        onConfirm: (WorkReportModel workReport) {
          _showReportSummaryDialog(currentTime, workReport);
        },
      ),
    );
  }

  void _showReportSummaryDialog(
    String currentTime,
    WorkReportModel workReport,
  ) {
    showDialog(
      context: context,
      builder: (context) => ReportSummaryDialog(
        workReport: workReport,
        onConfirm: () {
          Navigator.of(context).pop();
          _showSuccessDialog(currentTime);
        },
      ),
    );
  }

  void _showSuccessDialog(String currentTime) {
    showDialog(
      context: context,
      builder: (context) => SuccessDialog(
        onConfirm: () {
          Navigator.of(context).pop();
          _showCheckOutDialog(currentTime);
        },
      ),
    );
  }

  void _showCheckOutDialog(String currentTime) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => CheckOutDialog(
        checkOutTime: currentTime,
        onConfirm: () async {
          Navigator.of(context).pop();

          if (mounted) {
            // بدء الـ loading
            setState(() {
              _isLoading = true;
            });

            try {
              // Get current location
              final coordinates =
                  await LocationService.getCurrentLocationCoordinates();
              final latitude = coordinates['latitude']!;
              final longitude = coordinates['longitude']!;

              // Call checkOut with actual location
              sl<HomeCubit>().checkOut(latitude, longitude);
            } catch (e) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });

                String errorMessage = 'فشل الحصول على الموقع';
                if (e is LocationPermissionException) {
                  errorMessage = 'يرجى تفعيل صلاحيات الموقع من الإعدادات';
                  // Optionally open settings
                  final opened = await LocationService.openLocationSettings();
                  if (!opened) {
                    CustomSnackBar.showError(
                      context,
                      message: 'يرجى تفعيل صلاحيات الموقع يدوياً من الإعدادات',
                    );
                  }
                } else if (e is LocationServiceException) {
                  errorMessage = 'يرجى تفعيل خدمات الموقع في إعدادات الجهاز';
                } else {
                  errorMessage = e.toString();
                }

                CustomSnackBar.showError(context, message: errorMessage);
              }
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is AttendanceLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is AttendanceSuccess) {
          setState(() {
            _isLoading = false;
            if (state.response.isSuccess) {
              if (!_isCheckedIn) {
                _isCheckedIn = true;
                _checkInTime = DateTimeHelper.getCurrentTime();
              } else if (!_isCheckedOut) {
                _isCheckedOut = true;
                _checkOutTime = DateTimeHelper.getCurrentTime();
              }
            }
          });

          if (state.response.isSuccess) {
            CustomSnackBar.showSuccess(context, message: state.response.msg);
          } else {
            CustomSnackBar.showError(context, message: state.response.msg);
          }
        } else if (state is AttendanceError) {
          setState(() {
            _isLoading = false;
          });
          CustomSnackBar.showError(context, message: state.message);
        } else if (state is HomeScreenSuccess) {
          setState(() {
            final shift = state.homeScreen.data.shift;
            _isCheckedIn = shift.isCheckedIn;
            _isCheckedOut = shift.isCheckedOut;
            _checkInTime = shift.attendanceTime ?? '';
            _checkOutTime = shift.departureTime ?? '';
            _workStartTime = shift.from;
            _workEndTime = shift.to;
            _lastTimeBeforeDeduction = shift.lastTimeBeforeDeduction;
          });
        } else if (state is HomeScreenError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      child: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          return AttendanceWidget(
            date: _currentDate,
            workHours: _workHours,
            isCheckedIn: _isCheckedIn,
            isCheckedOut: _isCheckedOut,
            onCheckIn: _handleCheckIn,
            onCheckOut: _handleCheckOut,
            checkInTime: _checkInTime,
            checkOutTime: _checkOutTime,
            showCompleted: _isCheckedIn || _isCheckedOut,
            isLoading: _isLoading,
            workStartTime: _workStartTime,
            workEndTime: _workEndTime,
            lastTimeBeforeDeduction: _lastTimeBeforeDeduction,
          );
        },
      ),
    );
  }
}
