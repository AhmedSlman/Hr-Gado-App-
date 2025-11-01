import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/common/widgets/success_dialog_widget.dart';
import 'package:hr_app/features/time_sheet/logic/time_sheet_cubit.dart';
import 'package:hr_app/features/time_sheet/logic/time_sheet_states.dart';
import 'package:hr_app/features/time_sheet/presentation/widgets/permission_request_dialog_widget.dart';

class PermissionRequestDialogComponent extends StatefulWidget {
  final List<String> delayDurations;

  const PermissionRequestDialogComponent({
    super.key,
    required this.delayDurations,
  });

  @override
  State<PermissionRequestDialogComponent> createState() =>
      _PermissionRequestDialogComponentState();
}

class _PermissionRequestDialogComponentState
    extends State<PermissionRequestDialogComponent> {
  String _selectedPermissionType = "اذن حضور";
  String? _selectedDelayDuration;
  bool _isLoading = false;

  void _handleSubmit() {
    if (_selectedDelayDuration == null) {
      return;
    }

    context.read<TimeSheetCubit>().submitPermissionRequest(
          _selectedPermissionType,
          _selectedDelayDuration!,
        );
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimeSheetCubit, TimeSheetStates>(
      listener: (context, state) {
        if (state is PermissionRequestSuccess) {
          Navigator.of(context).pop(); // Close request dialog
          Future.microtask(() {
            showDialog(
              context: context,
              builder: (_) => SuccessDialogWidget(
                title: 'تم بنجاح',
                message: state.message,
              ),
            );
          });
        }
        if (state is PermissionRequestError) {
          CustomSnackBar.showError(context, message: state.message);
        }
        if (state is PermissionRequestProcessing) {
          setState(() => _isLoading = true);
        } else if (state is PermissionRequestSuccess ||
            state is PermissionRequestError) {
          setState(() => _isLoading = false);
        }
      },
      child: PermissionRequestDialogWidget(
        selectedPermissionType: _selectedPermissionType,
        selectedDelayDuration: _selectedDelayDuration,
        delayDurations: widget.delayDurations,
        isLoading: _isLoading,
        onPermissionTypeChanged: (String value) {
          setState(() {
            _selectedPermissionType = value;
          });
        },
        onDelayDurationChanged: (String? value) {
          setState(() {
            _selectedDelayDuration = value;
          });
        },
        onSubmit: _handleSubmit,
        onCancel: _handleCancel,
      ),
    );
  }
}
