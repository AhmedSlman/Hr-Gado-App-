import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/user_helper.dart';
import 'splash_states.dart';

class SplashCubit extends Cubit<SplashStates> {
  SplashCubit() : super(SplashInitial());

  static SplashCubit get(context) => BlocProvider.of(context);

  Future<void> checkAuthStatus() async {
    emit(SplashLoading());
    
    // Initialize user helper
    await UserHelper.initialize();
    
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));
    
    // Check if user is logged in
    final isLoggedIn = UserHelper.isLoggedIn;
    
    emit(SplashLoaded(isLoggedIn: isLoggedIn));
  }
}
