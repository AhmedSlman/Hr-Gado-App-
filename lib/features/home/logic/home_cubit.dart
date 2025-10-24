import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/home_repository.dart';
import '../data/models/request/home_request.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepository repository;
  HomeCubit(this.repository) : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);

  Future<void> loadItems() async {
    final result = await repository.fetchItems(const HomeRequest());

    // result.fold(
    //   (failure) => emit(HomeError(failure.message)),
    //   (items) => emit(HomeSuccess(items)),
    // );
  }
}
