part of 'dashboard_cubit.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}

final class DataLoaded extends DashboardState {
  final int productCount;
  final int orderCount;
  final int returnCount;

  const DataLoaded({
    required this.orderCount,
    required this.productCount,
    required this.returnCount,
  });
}
