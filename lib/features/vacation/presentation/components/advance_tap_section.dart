import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/common/widgets/success_dialog_widget.dart';
import 'package:hr_app/features/vacation/presentation/components/advance_requests_list_section.dart';
import 'package:hr_app/features/vacation/presentation/widgets/advance_type_radio_row_widget.dart';
import 'package:hr_app/features/vacation/presentation/widgets/advance_normal_widget.dart';
import 'package:hr_app/features/vacation/presentation/widgets/advance_long_widget.dart';
import 'package:hr_app/features/vacation/presentation/widgets/advance_amount_field_widget.dart';

class AdvanceTapSection extends StatefulWidget {
  const AdvanceTapSection({super.key});

  @override
  State<AdvanceTapSection> createState() => _AdvanceTapSectionState();
}

class _AdvanceTapSectionState extends State<AdvanceTapSection> {
  AdvanceType _selectedType = AdvanceType.normal;
  final TextEditingController _amountController = TextEditingController();
  String _repaymentPeriod = 'شهر واحد';

  // مثال لقيم عرض فقط
  final String _lastAdvanceDate = '١٥ سبتمبر ٢٠٢٥';
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى استكمال البيانات')));
      return;
    }
    showDialog(
      context: context,
      builder: (context) => const SuccessDialogWidget(
        title: 'تم إرسال طلب السلفة',
        message: 'سيتم مراجعة طلبك والرد عليك قريباً',
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Radios
          AdvanceTypeRadioRowWidget(
            selectedType: _selectedType,
            onChanged: (v) => setState(() => _selectedType = v),
          ),
          SizedBox(height: 16.h),
          // محتوى حسب النوع
          if (_selectedType == AdvanceType.normal) ...[
            // إحصائيات السلفة السابقة ثم حقل المبلغ
            SizedBox(height: 16.h),
            AdvanceNormalWidget(
              lastAdvanceDate: _lastAdvanceDate,
              daysSinceLastAdvance: _daysSinceLastAdvance,
              accruedBalance: _accruedBalance,
            ),
            SizedBox(height: 16.h),
            AdvanceAmountFieldWidget(controller: _amountController),
          ] else ...[
            // في الطويلة الأمد: حقل المبلغ ثم اختيار وقت السداد
            SizedBox(height: 16.h),
            AdvanceAmountFieldWidget(controller: _amountController),
            SizedBox(height: 16.h),
            AdvanceLongWidget(
              repaymentPeriod: _repaymentPeriod,
              onRepaymentChanged: (v) => setState(() => _repaymentPeriod = v),
            ),
          ],

          SizedBox(height: 20.h),
          CustomButton(
            height: 45.h,
            width: 200.w,
            text: 'إرسال الطلب',
            onPressed: _canSubmit ? _handleSubmit : null,
          ),
          const SizedBox(height: 8),

          const AdvanceRequestsListSection(),
        ],
      ),
    );
  }
}
