import 'package:flutter/material.dart';
import 'package:hr_app/core/utils/date_time_helper.dart';
import 'package:hr_app/features/home/presentation/widgets/attendance_widget.dart';

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

  String _currentDate = '';
  String _workHours = '8';

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  void _loadAttendanceData() {
    setState(() {
      _currentDate = DateTimeHelper.getCurrentDate();
    });
  }

  void _handleCheckIn() {
    final currentTime = DateTimeHelper.getCurrentTime();

    setState(() {
      _isCheckedIn = true;
      _checkInTime = currentTime;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم تسجيل الحضور بنجاح')));
  }

  void _handleCheckOut() {
    final currentTime = DateTimeHelper.getCurrentTime();

    setState(() {
      _isCheckedOut = true;
      _checkOutTime = currentTime;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم تسجيل الانصراف بنجاح')));
  }

  @override
  Widget build(BuildContext context) {
    return AttendanceWidget(
      date: _currentDate,
      workHours: _workHours,
      isCheckedIn: _isCheckedIn,
      isCheckedOut: _isCheckedOut,
      onCheckIn: _handleCheckIn,
      onCheckOut: _handleCheckOut,
      checkInTime: _checkInTime,
      checkOutTime: _checkOutTime,
    );
  }
}
