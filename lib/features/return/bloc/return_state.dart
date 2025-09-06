part of 'return_bloc.dart';

sealed class ReturnState extends Equatable {
  const ReturnState();

  @override
  List<Object> get props => [];
}

final class ReturnInitial extends ReturnState {}

final class LoadingState extends ReturnState {}

final class EmptyReturnState extends ReturnState {}

final class ErrorState extends ReturnState {
  final String error;
  const ErrorState(this.error);
}

final class ReturnFetchedState extends ReturnState {
  final List<OrderModel> orders;
  const ReturnFetchedState({required this.orders});
  @override
  List<Object> get props => [orders];
}
