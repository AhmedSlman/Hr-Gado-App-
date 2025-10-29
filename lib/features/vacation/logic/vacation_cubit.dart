import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/vacation_repository.dart';
import '../data/models/request/vacation_request.dart';
import '../data/models/response/vacation_model.dart';
import '../../../../../core/error/result_extensions.dart';
import 'vacation_states.dart';

class VacationCubit extends Cubit<VacationStates> {
  final VacationRepository repository;
  VacationCubit(this.repository) : super(VacationInitial());
  static VacationCubit get(context) => BlocProvider.of(context);

  Future<void> loadItems() async {
    final result = await repository.fetchItems(const VacationRequest());

    // result.fold(
    //   (failure) => emit(VacationError(failure.message)),
    //   (items) => emit(VacationSuccess(items)),
    // );
  }
}
