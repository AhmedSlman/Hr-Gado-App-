import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/locator/service_locator.dart';
import '../../data/models/response/car_model.dart';
import '../../logic/cars_cubit.dart';
import '../../logic/cars_states.dart';
import '../components/add_car_body_section.dart';

class AddCarView extends StatefulWidget {
  final int? carId; // null for add, not null for edit

  const AddCarView({super.key, this.carId});

  @override
  State<AddCarView> createState() => _AddCarViewState();
}

class _AddCarViewState extends State<AddCarView> {
  CarDetails? _carData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<CarsCubit>();
        // Load car details if in edit mode
        if (widget.carId != null) {
          // Use addPostFrameCallback to ensure the widget tree is built first
          WidgetsBinding.instance.addPostFrameCallback((_) {
            cubit.getCarDetails(widget.carId!);
          });
        }
        return cubit;
      },
      child: BlocListener<CarsCubit, CarsStates>(
        listener: (context, state) {
          if (state is CarDetailsSuccess && widget.carId != null) {
            setState(() {
              _carData = state.carDetailsResponse.data;
            });
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                CustomAppBar(
                  title: widget.carId == null ? "اضافة سيارة" : "تعديل سيارة",
                ),
                Expanded(
                  child: BlocBuilder<CarsCubit, CarsStates>(
                    builder: (context, state) {
                      if (widget.carId != null) {
                        if (state is CarDetailsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is CarDetailsError) {
                          return Center(
                            child: Text('حدث خطأ: ${state.message}'),
                          );
                        }
                      }

                      return AddCarBodySection(
                        carId: widget.carId,
                        carData: _carData,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
