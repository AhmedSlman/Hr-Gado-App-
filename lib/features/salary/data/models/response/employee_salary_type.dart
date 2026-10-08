import '../../../../../core/utils/user_helper.dart';
import 'salary_model.dart';

EmployeeType currentSalaryType() {
  if (UserHelper.isManager) return EmployeeType.manager;
  return currentReportType();
}

EmployeeType currentReportType() {
  return switch (UserHelper.userJobType?.toLowerCase()) {
    'driver' => EmployeeType.driver,
    'sales' => EmployeeType.sales,
    'technician' => EmployeeType.technician,
    _ => EmployeeType.other,
  };
}
