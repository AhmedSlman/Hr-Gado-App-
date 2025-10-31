import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/request/create_news_request.dart';
import '../data/models/request/news_request.dart';
import '../data/repository/news_repository.dart';
import 'news_states.dart';

class NewsCubit extends Cubit<NewsStates> {
  final NewsRepository repository;
  NewsCubit(this.repository) : super(NewsInitial());
  static NewsCubit get(context) => BlocProvider.of(context);

  Future<void> loadItems() async {
    emit(NewsLoading());
    final result = await repository.fetchItems(const NewsRequest());
    result.fold(
      (failure) => emit(NewsError(failure.message)),
      (items) => emit(NewsSuccess(items)),
    );
  }

  Future<void> createNews(CreateNewsRequest request) async {
    emit(CreateNewsLoading());
    final result = await repository.createNews(request);
    result.fold((failure) => emit(CreateNewsError(failure.message)), (resp) {
      final msg = resp.msg.isNotEmpty ? resp.msg : 'تم إنشاء المقال بنجاح';
      emit(CreateNewsSuccess(msg));
    });
  }

  Future<void> getEmployees() async {
    emit(EmployeesLoading());
    final result = await repository.getEmployees();
    result.fold(
      (failure) => emit(EmployeesError(failure.message)),
      (employees) => emit(EmployeesSuccess(employees)),
    );
  }
}
