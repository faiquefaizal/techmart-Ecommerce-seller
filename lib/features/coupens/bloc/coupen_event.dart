part of 'coupen_bloc.dart';

@immutable
sealed class CoupenEvent {}

class FechCoupensEvent extends CoupenEvent {
  FechCoupensEvent();
}

class AddCoupenEvent extends CoupenEvent {
  final SellerCouponModel couponModel;
  AddCoupenEvent(this.couponModel);
}

class EditCoupenEvent extends CoupenEvent {
  final SellerCouponModel couponModel;
  EditCoupenEvent(this.couponModel);
}

class DeleteCoupenEvent extends CoupenEvent {
  final String id;
  DeleteCoupenEvent(this.id);
}

class ToggleEvent extends CoupenEvent {
  final SellerCouponModel couponModel;
  ToggleEvent(this.couponModel);
}
