import 'package:equatable/equatable.dart';

import '../data/models/response/report_model.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final ReportData reportData;

  const ReportLoaded({required this.reportData, });

  @override
  List<Object?> get props => [reportData, ];
}

class ReportError extends ReportState {
  final String message;

  const ReportError({required this.message});

  @override
  List<Object?> get props => [message];
}
