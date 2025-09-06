import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/features/orders/bloc/order_bloc.dart';
import 'package:techmart_seller/features/orders/models/order_status.dart';
import 'package:techmart_seller/features/return/service/return_service.dart';

part 'return_event.dart';
part 'return_state.dart';

class ReturnBloc extends Bloc<ReturnEvent, ReturnState> {
  ReturnService returnService;
  ReturnBloc(this.returnService) : super(ReturnInitial()) {
    on<FetchReturnRequest>(_returnRequest);
    on<AcceptReturn>(_acceptReturn);
    on<RejectReturn>(_rejectReturn);
  }

  _returnRequest(ReturnEvent event, Emitter<ReturnState> emit) async {
    emit(LoadingState());
    emit.forEach(
      returnService.fetchReturns(),
      onData: (order) {
        if (order.isEmpty) {
          return EmptyReturnState();
        }

        return (ReturnFetchedState(orders: order));
      },
      onError: (error, stackTrace) => ErrorState(error.toString()),
    );
  }

  _acceptReturn(AcceptReturn event, Emitter<ReturnState> emit) async {
    await returnService.acceptReturn(
      event.id,
      event.productId,
      event.varientId,
      event.count,
    );
  }

  _rejectReturn(RejectReturn event, Emitter<ReturnState> emit) async {
    await returnService.rejectReturn(event.id);
  }
}
