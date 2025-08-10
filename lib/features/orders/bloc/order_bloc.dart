import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:techmart_seller/features/orders/models/order_status.dart';
import 'package:techmart_seller/features/orders/service/order_service.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  StreamSubscription? _streamSubscription;
  OrderService orderService;

  OrderBloc(this.orderService) : super(OrderInitial()) {
    on<FetchOrder>(_orderFetch);
    on<FetchedOrder>(_fechedOrder);
    on<UpdateStaus>(_updateState);
  }
  _fechedOrder(FetchedOrder event, Emitter<OrderState> emit) {
    if (event.order.isEmpty) {
      emit(OrderEmptyState());
    }
    emit(OrdersLoaded(event.order));
  }

  _orderFetch(OrderEvent event, Emitter<OrderState> emit) {
    emit(LoadingState());
    _streamSubscription?.cancel();
    _streamSubscription = orderService.fetchOrder().listen((orders) {
      add(FetchedOrder(orders));
    }, onError: (error) => emit(ErrorState(error.toString())));
  }

  _updateState(UpdateStaus status, Emitter<OrderState> emit) {
    orderService.updateState(status.status, status.id);
  }
}
