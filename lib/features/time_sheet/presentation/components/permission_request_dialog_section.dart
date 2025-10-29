import 'package:flutter/material.dart';
import 'package:hr_app/features/time_sheet/presentation/widgets/permission_request_dialog_widget.dart';

class PermissionRequestDialogComponent extends StatefulWidget {
  final List<String> delayDurations;
  final VoidCallback onRequestSubmitted;

  const PermissionRequestDialogComponent({
    super.key,
    required this.delayDurations,
    required this.onRequestSubmitted,
  });

  @override
  State<PermissionRequestDialogComponent> createState() =>
      _PermissionRequestDialogComponentState();
}

class _PermissionRequestDialogComponentState
    extends State<PermissionRequestDialogComponent> {
  String _selectedPermissionType = "اذن حضور";
  String? _selectedDelayDuration;

  void _handleSubmit() {
    if (_selectedDelayDuration != null) {
      Navigator.of(context).pop();
      Future.microtask(() {
        widget.onRequestSubmitted();
      });
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PermissionRequestDialogWidget(
      selectedPermissionType: _selectedPermissionType,
      selectedDelayDuration: _selectedDelayDuration,
      delayDurations: widget.delayDurations,
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
    );
  }
}
