part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class FetchOrder extends OrderEvent {}

class FetchedOrder extends OrderEvent {
  List<OrderModel> order;
  FetchedOrder(this.order);
}

class UpdateStaus extends OrderEvent {
  String id;
  String status;
  UpdateStaus(this.status, this.id);
}
