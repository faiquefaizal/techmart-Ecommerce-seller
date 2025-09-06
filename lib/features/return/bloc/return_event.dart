part of 'return_bloc.dart';

sealed class ReturnEvent extends Equatable {
  const ReturnEvent();

  @override
  List<Object> get props => [];
}

final class FetchReturnRequest extends ReturnEvent {
  const FetchReturnRequest();
}

final class AcceptReturn extends ReturnEvent {
  final String id, productId, varientId;
  final int count;
  const AcceptReturn(this.id, this.productId, this.varientId, this.count);
}

final class RejectReturn extends ReturnEvent {
  final String id;
  const RejectReturn(this.id);
}
