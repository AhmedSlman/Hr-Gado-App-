import '../models/response/company_rule_model.dart';
import '../../../../../core/error/result_extensions.dart';

abstract class RulesRepository {
  Future<Result<List<CompanyRuleModel>>> fetchCompanyRules();
}

