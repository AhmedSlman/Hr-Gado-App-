import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/features/vacation/presentation/components/advance_requests_list_section.dart';
import 'package:hr_app/features/vacation/presentation/widgets/advance_type_radio_row_widget.dart';
import 'package:hr_app/features/vacation/presentation/widgets/advance_normal_widget.dart';
import 'package:hr_app/features/vacation/presentation/widgets/advance_long_widget.dart';
import 'package:hr_app/features/vacation/presentation/widgets/advance_amount_field_widget.dart';
import 'package:hr_app/features/vacation/logic/vacation_cubit.dart';
import 'package:hr_app/features/vacation/logic/vacation_states.dart';
import 'package:hr_app/features/vacation/data/models/request/vacation_submit_request.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/common/widgets/success_dialog_widget.dart';
import 'package:hr_app/core/utils/months_parser.dart';

class AdvanceTapSection extends StatefulWidget {
  const AdvanceTapSection({super.key});

  @override
  State<AdvanceTapSection> createState() => _AdvanceTapSectionState();
}

class _AdvanceTapSectionState extends State<AdvanceTapSection>
    with AutomaticKeepAliveClientMixin {
  AdvanceType _selectedType = AdvanceType.normal;
  final TextEditingController _amountController = TextEditingController();
  String _repaymentPeriod = 'شهر واحد';

  // مثال لقيم عرض فقط
  String _lastAdvanceDate = '—';
  final String _daysSinceLastAdvance = '10 أيام';
  final String _accruedBalance = '1500 جنيه';

  bool get _canSubmit {
    if (_amountController.text.trim().isEmpty) return false;
    if (_selectedType == AdvanceType.longTerm && _repaymentPeriod.isEmpty) {
      return false;
    }
    return true;
  }

  void _handleSubmit() {
    if (!_canSubmit) {
      CustomSnackBar.showError(context, message: 'يرجى استكمال البيانات');
      return;
    }

    final type = _selectedType == AdvanceType.normal ? 'normal' : 'long_term';
    final amount = _amountController.text.trim();
    String? months;
    if (_selectedType == AdvanceType.longTerm) {
      months = extractMonthsNumber(_repaymentPeriod);
      if (months == null || months.isEmpty) {
        CustomSnackBar.showError(context, message: 'عدد الأشهر مطلوب');
        return;
      }
    }

    final req = AdvanceSubmitRequest(
      type: type,
      amount: amount,
      numberOfMonths: months,
    );
    // استخدام sl للحصول على نفس instance (lazy singleton)
    sl<VacationCubit>().submitAdvance(req);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<VacationCubit, VacationStates>(
      listener: (context, state) {
        if (state is VacationSubmitSuccess) {
          // clear amount field and repayment period on success
          FocusScope.of(context).unfocus();
          setState(() {
            _amountController.clear();
            _repaymentPeriod = 'شهر واحد';
          });
          // استخدام Future.delayed لتأخير عرض الـ dialog حتى بعد انتهاء setState (متوافق مع go_router)
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted && context.mounted) {
              showDialog(
                context: context,
                builder: (dialogContext) => SuccessDialogWidget(
                  title: 'تم بنجاح',
                  message: state.message,
                ),
              );
            }
          });
        } else if (state is AdvanceLoadSuccess) {
          setState(() {
            _lastAdvanceDate = state.response.stats.latestAdvanceDate;
          });
        } else if (state is VacationSubmitError) {
          // استخدام Future.delayed لتأخير عرض رسالة الخطأ (متوافق مع go_router)
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted && context.mounted) {
              CustomSnackBar.showError(context, message: state.message);
            }
          });
        }
      },
      builder: (context, state) {
        final isLoading = state is VacationSubmitting;
        if (state is AdvanceLoading) {
          // Could show a small shimmer for the stats area
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              // Radios
              AdvanceTypeRadioRowWidget(
                selectedType: _selectedType,
                onChanged: (v) => setState(() => _selectedType = v),
              ),
              SizedBox(height: 16.h),
              if (_selectedType == AdvanceType.normal) ...[
                SizedBox(height: 16.h),
                AdvanceNormalWidget(
                  lastAdvanceDate: _lastAdvanceDate,
                  daysSinceLastAdvance: _daysSinceLastAdvance,
                  accruedBalance: _accruedBalance,
                ),
                SizedBox(height: 16.h),
                AdvanceAmountFieldWidget(controller: _amountController),
              ] else ...[
                SizedBox(height: 16.h),
                AdvanceAmountFieldWidget(controller: _amountController),
                SizedBox(height: 16.h),
                AdvanceLongWidget(
                  repaymentPeriod: _repaymentPeriod,
                  onRepaymentChanged: (v) =>
                      setState(() => _repaymentPeriod = v),
                ),
              ],

              SizedBox(height: 20.h),
              CustomButton(
                height: 45.h,
                width: 200.w,
                text: isLoading ? 'جاري الإرسال...' : 'إرسال الطلب',
                onPressed: isLoading ? null : _handleSubmit,
              ),
              const SizedBox(height: 8),

              const AdvanceRequestsListSection(),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
