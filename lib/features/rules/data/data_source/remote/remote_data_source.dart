import 'package:dartz/dartz.dart';

import '../../../../../core/network/api_consumer.dart';
import '../../../../../core/error/result_extensions.dart';
import '../../models/response/company_rule_model.dart';
import 'endpoints.dart';

abstract class RulesRemoteDataSource {
  Future<Result<List<CompanyRuleModel>>> fetchCompanyRules();
}

class RulesRemoteDataSourceImpl implements RulesRemoteDataSource {
  final ApiConsumer _apiConsumer;
  RulesRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<List<CompanyRuleModel>>> fetchCompanyRules() async {
    final result = await _apiConsumer.get<List<CompanyRuleModel>>(
      path: RulesEndpoints.faqs,
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) {
        final data = (json['data'] ?? []) as List;
        return data
            .map((item) => CompanyRuleModel.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }
}

