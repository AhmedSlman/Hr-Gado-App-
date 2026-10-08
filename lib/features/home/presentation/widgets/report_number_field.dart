import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String? validateReportNumber(String? value, {bool decimal = false}) {
  if (value == null || value.trim().isEmpty) return 'أدخل قيمة رقمية';
  final pattern = decimal ? r'^\d+(\.\d{1,2})?$' : r'^\d+$';
  final number = double.tryParse(value);
  if (!RegExp(pattern).hasMatch(value) ||
      number == null ||
      !number.isFinite ||
      number < 0) {
    return decimal
        ? 'أدخل رقماً موجباً أو صفراً، بحد أقصى منزلتين عشريتين'
        : 'أدخل عدداً صحيحاً موجباً أو صفراً';
  }
  return null;
}

class ReportNumberField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final bool decimal;
  final bool optional;

  const ReportNumberField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.decimal = false,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    initialValue: initialValue,
    keyboardType: TextInputType.numberWithOptions(decimal: decimal),
    inputFormatters: [
      if (decimal)
        TextInputFormatter.withFunction(
          (oldValue, newValue) =>
              RegExp(r'^\d*(\.\d{0,2})?$').hasMatch(newValue.text)
              ? newValue
              : oldValue,
        )
      else
        FilteringTextInputFormatter.digitsOnly,
    ],
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    onChanged: onChanged,
    validator: (value) => optional && (value == null || value.isEmpty)
        ? null
        : validateReportNumber(value, decimal: decimal),
  );
}
