import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/rules_repository.dart';
import 'rules_states.dart';

class RulesCubit extends Cubit<RulesStates> {
  final RulesRepository repository;
  RulesCubit(this.repository) : super(RulesInitial());
  static RulesCubit get(context) => BlocProvider.of(context);

  Future<void> loadCompanyRules() async {
    emit(RulesLoading());
    final result = await repository.fetchCompanyRules();

    result.fold(
      (failure) => emit(RulesLoadError(failure.message)),
      (rules) => emit(RulesLoadSuccess(rules)),
    );
  }
}

