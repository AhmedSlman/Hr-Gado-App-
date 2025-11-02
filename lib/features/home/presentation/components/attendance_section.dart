import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
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
    // حفظ context من build method لاستخدامه في callbacks
    final parentContext = context;

    showDialog(
      context: parentContext,
      builder: (dialogContext) => CheckInDialog(
        checkInTime: currentTime,
        onConfirm: () async {
          if (dialogContext.canPop()) {
            dialogContext.pop();
          }

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
            // استخدام context.read للحصول على نفس instance الذي يستمع له BlocListener
            parentContext.read<HomeCubit>().checkIn(latitude, longitude);
          } catch (e) {
            setState(() {
              _isLoading = false;
            });

            String errorMessage = 'فشل الحصول على الموقع';
            if (e is LocationPermissionException) {
              errorMessage = 'يرجى تفعيل صلاحيات الموقع من الإعدادات';
              // Optionally open settings
              final opened = await LocationService.openLocationSettings();
              if (!opened && mounted && parentContext.mounted) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted && parentContext.mounted) {
                    CustomSnackBar.showError(
                      parentContext,
                      message: 'يرجى تفعيل صلاحيات الموقع يدوياً من الإعدادات',
                    );
                  }
                });
              }
            } else if (e is LocationServiceException) {
              errorMessage = 'يرجى تفعيل خدمات الموقع في إعدادات الجهاز';
            } else {
              errorMessage = e.toString();
            }

            // استخدام Future.delayed لتأخير العرض حتى بعد إغلاق dialog
            if (mounted && parentContext.mounted) {
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted && parentContext.mounted) {
                  CustomSnackBar.showError(
                    parentContext,
                    message: errorMessage,
                  );
                }
              });
            }
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
    // استخدام context.read للحصول على نفس instance الذي يستمع له BlocListener
    final homeCubit = context.read<HomeCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider<HomeCubit>.value(
        value: homeCubit,
        child: ReportSummaryDialog(
          workReport: workReport,
          onConfirm: () {
            // ReportSummaryDialog يغلق نفسه بالفعل، فقط استدعاء الخطوة التالية
            _showSuccessDialog(currentTime);
          },
        ),
      ),
    );
  }

  void _showSuccessDialog(String currentTime) {
    // حفظ context من build method
    final parentContext = context;
    showDialog(
      context: parentContext,
      builder: (dialogContext) => SuccessDialog(
        onConfirm: () {
          if (dialogContext.canPop()) {
            dialogContext.pop();
          }
          _showCheckOutDialog(currentTime);
        },
      ),
    );
  }

  void _showCheckOutDialog(String currentTime) {
    if (!mounted) return;

    // حفظ context من build method لاستخدامه في callbacks
    final parentContext = context;

    showDialog(
      context: parentContext,
      builder: (dialogContext) => CheckOutDialog(
        checkOutTime: currentTime,
        onConfirm: () async {
          if (dialogContext.canPop()) {
            dialogContext.pop();
          }

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
              // استخدام context.read للحصول على نفس instance الذي يستمع له BlocListener
              parentContext.read<HomeCubit>().checkOut(latitude, longitude);
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
                  if (!opened && mounted && parentContext.mounted) {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (mounted && parentContext.mounted) {
                        CustomSnackBar.showError(
                          parentContext,
                          message:
                              'يرجى تفعيل صلاحيات الموقع يدوياً من الإعدادات',
                        );
                      }
                    });
                  }
                } else if (e is LocationServiceException) {
                  errorMessage = 'يرجى تفعيل خدمات الموقع في إعدادات الجهاز';
                } else {
                  errorMessage = e.toString();
                }

                // استخدام Future.delayed لتأخير العرض حتى بعد إغلاق dialog
                if (mounted && parentContext.mounted) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted && parentContext.mounted) {
                      CustomSnackBar.showError(
                        parentContext,
                        message: errorMessage,
                      );
                    }
                  });
                }
              }
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // حفظ context من build method لاستخدامه في callbacks
    final buildContext = context;

    return BlocListener<HomeCubit, HomeStates>(
      listener: (listenerContext, state) {
        if (state is AttendanceLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is AttendanceSuccess) {
          print('🔍 AttendanceSection - AttendanceSuccess received');
          print('🔍 isSuccess: ${state.response.isSuccess}');
          print('🔍 msg: ${state.response.msg}');

          final isSuccess = state.response.isSuccess;
          final message = state.response.msg;

          setState(() {
            _isLoading = false;
            if (isSuccess) {
              if (!_isCheckedIn) {
                _isCheckedIn = true;
                _checkInTime = DateTimeHelper.getCurrentTime();
              } else if (!_isCheckedOut) {
                _isCheckedOut = true;
                _checkOutTime = DateTimeHelper.getCurrentTime();
              }
            }
          });

          // عرض الرسالة بعد انتهاء setState باستخدام buildContext
          // استخدام Future.delayed لتأخير العرض حتى بعد انتهاء frame كامل (متوافق مع go_router)
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted && buildContext.mounted) {
              print('🔍 AttendanceSection - Showing snackbar: $message');
              if (isSuccess) {
                CustomSnackBar.showSuccess(buildContext, message: message);
              } else {
                CustomSnackBar.showError(buildContext, message: message);
              }
            }
          });
        } else if (state is AttendanceError) {
          setState(() {
            _isLoading = false;
          });

          // عرض رسالة الخطأ بعد انتهاء setState باستخدام buildContext
          // استخدام Future.delayed لتأخير العرض حتى بعد انتهاء frame كامل (متوافق مع go_router)
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted && buildContext.mounted) {
              CustomSnackBar.showError(buildContext, message: state.message);
            }
          });
        } else if (state is HomeScreenSuccess) {
          setState(() {
            final shift = state.homeScreen.data.shift;
            _isCheckedIn = shift.isCheckedIn;
            _isCheckedOut = shift.isCheckedOut;
            // تحويل الوقت من 24 ساعة إلى 12 ساعة إذا كان موجوداً
            _checkInTime =
                shift.attendanceTime != null && shift.attendanceTime!.isNotEmpty
                ? DateTimeHelper.convertTo12Hour(shift.attendanceTime!)
                : '';
            _checkOutTime =
                shift.departureTime != null && shift.departureTime!.isNotEmpty
                ? DateTimeHelper.convertTo12Hour(shift.departureTime!)
                : '';
            // تحويل أوقات العمل أيضاً إلى 12 ساعة
            _workStartTime = shift.from.isNotEmpty
                ? DateTimeHelper.convertTo12Hour(shift.from)
                : '09:00 ص';
            _workEndTime = shift.to.isNotEmpty
                ? DateTimeHelper.convertTo12Hour(shift.to)
                : '05:00 م';
            _lastTimeBeforeDeduction = shift.lastTimeBeforeDeduction.isNotEmpty
                ? DateTimeHelper.convertTo12Hour(shift.lastTimeBeforeDeduction)
                : '09:30 ص';
          });
        } else if (state is HomeScreenError) {
          // عرض رسالة الخطأ بعد انتهاء أي عمليات أخرى
          // استخدام Future.delayed لتأخير العرض حتى بعد انتهاء frame كامل (متوافق مع go_router)
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted && buildContext.mounted) {
              CustomSnackBar.showError(buildContext, message: state.message);
            }
          });
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
