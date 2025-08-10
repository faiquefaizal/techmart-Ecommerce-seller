part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class LoadingState extends OrderState {}

final class OrderEmptyState extends OrderState {}

final class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;

  const OrdersLoaded(this.orders);
  @override
  List<Object> get props => [orders];
}

final class ErrorState extends OrderState {
  String message;
  ErrorState(this.message);
}
