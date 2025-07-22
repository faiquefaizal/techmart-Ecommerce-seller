part of 'coupen_bloc.dart';

@immutable
sealed class CoupenState {}

final class CoupenInitial extends CoupenState {}

final class CoupenLoading extends CoupenState {}

final class CoupenError extends CoupenState {
  final String error;
  CoupenError(this.error);
}

final class CoupenLoaded extends CoupenState {
  final List<SellerCouponModel> coupens;
  CoupenLoaded(this.coupens);
}

final class CoupensIsEmpty extends CoupenState {}

final class CoupenAdding extends CoupenState {}

final class CoupenAdded extends CoupenState {}
