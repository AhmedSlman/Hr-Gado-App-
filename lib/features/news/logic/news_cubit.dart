import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/news_repository.dart';
import '../data/models/request/news_request.dart';
import '../data/models/response/news_model.dart';
import '../../../../../core/error/result_extensions.dart';
import 'news_states.dart';

class NewsCubit extends Cubit<NewsStates> {
  final NewsRepository repository;
  NewsCubit(this.repository) : super(NewsInitial());
  static NewsCubit get(context) => BlocProvider.of(context);

  Future<void> loadItems() async {
    final result = await repository.fetchItems(const NewsRequest());

    // result.fold(
    //   (failure) => emit(NewsError(failure.message)),
    //   (items) => emit(NewsSuccess(items)),
    // );
  }
}
