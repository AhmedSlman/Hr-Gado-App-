import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/locator/service_locator.dart';

import '../logic/cars_cubit.dart';
import '../presentation/views/add_car_view.dart';
import '../presentation/views/car_details_view.dart';
import '../presentation/views/cars_view.dart';
import 'cars_names.dart';

class CarsRouter {
  static List<GoRoute> get routes => [
    // Cars List Screen (Manager only)
    GoRoute(
      path: CarsRoutes.cars,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<CarsCubit>()..getCars(),
        child: const CarsView(),
      ),
    ),
    // Add/Edit Car Screen
    GoRoute(
      path: CarsRoutes.addCar,
      builder: (context, state) {
        final carId = state.extra as int?;
        return AddCarView(carId: carId);
      },
    ),
    // My Car Screen (for Employee) - MUST come before /cars/:carId
    GoRoute(
      path: CarsRoutes.myCar,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<CarsCubit>()..getMyCar(),
        child: const CarDetailsView(),
      ),
    ),
    // Car Details Screen (for Manager - specific car)
    // This must come AFTER /cars/my-car to avoid matching "my-car" as a carId
    GoRoute(
      path: '/cars/:carId',
      builder: (context, state) {
        final carId = int.parse(state.pathParameters['carId']!);
        return BlocProvider(
          create: (context) => sl<CarsCubit>()..getCarDetails(carId),
          child: const CarDetailsView(),
        );
      },
    ),
  ];
}
