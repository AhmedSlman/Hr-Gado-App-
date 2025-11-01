import '../data/models/response/company_rule_model.dart';

abstract class RulesStates {}

class RulesInitial extends RulesStates {}

class RulesLoading extends RulesStates {}

class RulesLoadSuccess extends RulesStates {
  final List<CompanyRuleModel> rules;
  RulesLoadSuccess(this.rules);
}

class RulesLoadError extends RulesStates {
  final String message;
  RulesLoadError(this.message);
}

