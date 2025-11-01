import 'rules_repository.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/response/company_rule_model.dart';
import '../../../../../core/error/result_extensions.dart';

class RulesRepositoryImpl implements RulesRepository {
  final RulesRemoteDataSource remoteDataSource;

  RulesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<CompanyRuleModel>>> fetchCompanyRules() async {
    final result = await remoteDataSource.fetchCompanyRules();
    return result;
  }
}

