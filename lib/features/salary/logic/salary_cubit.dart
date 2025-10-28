import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/salary_repository.dart';
import '../data/models/request/salary_request.dart';
import '../data/models/response/salary_model.dart';
import '../../../../../core/error/result_extensions.dart';
import 'salary_states.dart';

class SalaryCubit extends Cubit<SalaryStates> {
  final SalaryRepository repository;
  SalaryCubit(this.repository) : super(SalaryInitial());
  static SalaryCubit get(context) => BlocProvider.of(context);

  Future<void> loadItems() async {
    final result = await repository.fetchItems(const SalaryRequest());

    // result.fold(
    //   (failure) => emit(SalaryError(failure.message)),
    //   (items) => emit(SalarySuccess(items)),
    // );
  }
}
