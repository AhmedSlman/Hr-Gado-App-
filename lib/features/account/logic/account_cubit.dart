import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/account_repository.dart';
import '../data/models/request/account_request.dart';
import '../data/models/response/account_model.dart';
import '../../../../../core/error/result_extensions.dart';
import 'account_states.dart';

class AccountCubit extends Cubit<AccountStates> {
  final AccountRepository repository;
  AccountCubit(this.repository) : super(AccountInitial());
  static AccountCubit get(context) => BlocProvider.of(context);

  Future<void> loadItems() async {
    final result = await repository.fetchItems(const AccountRequest());

    // result.fold(
    //   (failure) => emit(AccountError(failure.message)),
    //   (items) => emit(AccountSuccess(items)),
    // );
  }
}
