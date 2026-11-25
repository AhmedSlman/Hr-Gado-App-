import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/common/widgets/success_dialog_widget.dart';
import 'package:hr_app/core/error/result_extensions.dart';
import 'package:hr_app/features/account/data/models/response/attendance_request_details.dart';
import 'package:hr_app/features/account/data/repository/account_repository.dart';
import 'package:hr_app/features/account/presentation/widgets/leave_request_field_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/requset_actions_buttons.dart';

class AttendanceRequestDetailsView extends StatefulWidget {
  const AttendanceRequestDetailsView({
    super.key,
    required this.requestId,
    required this.repository,
  });

  final int requestId;
  final AccountRepository repository;

  @override
  State<AttendanceRequestDetailsView> createState() =>
      _AttendanceRequestDetailsViewState();
}

class _AttendanceRequestDetailsViewState
    extends State<AttendanceRequestDetailsView> {
  late Future<Result<AttendanceRequestDetails>> _details;
  bool? _approving;

  @override
  void initState() {
    super.initState();
    _details = widget.repository.fetchAttendanceDetails(widget.requestId);
  }

  Future<void> _review({required bool approve}) async {
    if (_approving != null) return;
    setState(() => _approving = approve);

    final result = await widget.repository.reviewAttendance(
      widget.requestId,
      approve: approve,
    );
    if (!mounted) return;

    final response = result.fold((_) => null, (response) => response);
    if (response == null || response.key != 'success') {
      setState(() => _approving = null);
      CustomSnackBar.showError(
        context,
        message: result.fold(
          (failure) => failure.message,
          (response) => response.msg,
        ),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (_) =>
          SuccessDialogWidget(title: 'تم بنجاح', message: response.msg),
    );
    if (mounted) context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'تفاصيل طلب الحضور'),
            Expanded(
              child: FutureBuilder<Result<AttendanceRequestDetails>>(
                future: _details,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final details = snapshot.data?.fold(
                    (_) => null,
                    (data) => data,
                  );
                  if (details == null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            snapshot.data?.fold(
                                  (failure) => failure.message,
                                  (_) => 'تعذر تحميل تفاصيل الطلب',
                                ) ??
                                'تعذر تحميل تفاصيل الطلب',
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () => setState(() {
                              _details = widget.repository
                                  .fetchAttendanceDetails(widget.requestId);
                            }),
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView(
                    children: [
                      Text(
                        details.employeeName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      LeaveRequestFieldWidget(
                        label: 'نوع الطلب',
                        value: details.typeName,
                        isDaysField: true,
                      ),
                      LeaveRequestFieldWidget(
                        label: 'التاريخ',
                        value: details.date,
                      ),
                      LeaveRequestFieldWidget(
                        label: 'المدة',
                        value: '${details.durationMinutes} دقيقة',
                        isDaysField: true,
                      ),
                      LeaveRequestFieldWidget(
                        label: 'الحالة',
                        value: details.statusName,
                        isDaysField: true,
                      ),
                      if (details.isPending)
                        RequsetActionsButtons(
                          onAcceptPressed: () => _review(approve: true),
                          onRejectPressed: () => _review(approve: false),
                          isApproving: _approving == true,
                          isRejecting: _approving == false,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
