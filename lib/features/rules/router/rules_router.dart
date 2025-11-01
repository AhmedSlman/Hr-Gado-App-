import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'rules_names.dart';
import '../logic/rules_cubit.dart';
import '../presentation/views/company_rules_view.dart';

class RulesRouter {
  static List<GoRoute> get routes => [
    // Company Rules Screen
    GoRoute(
      path: RulesRoutes.rules,
      builder: (context, state) {
        final cubit = sl<RulesCubit>()..loadCompanyRules();
        return BlocProvider<RulesCubit>.value(
          value: cubit,
          child: const CompanyRulesView(),
        );
      },
    ),
  ];
}

