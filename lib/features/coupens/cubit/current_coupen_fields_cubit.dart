import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:techmart_seller/features/coupens/models/coupen_model.dart';

part 'current_coupen_fields_state.dart';

class CurrentCoupenFieldsCubit extends Cubit<CoupenFieldsUpdated> {
  CurrentCoupenFieldsCubit()
    : super(
        CoupenFieldsUpdated(
          minPrice: 0,
          islive: true,
          couponName: "",
          percentage: 0,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
        ),
      );

  void updateName(String name) {
    emit(state.copyWith(couponName: name));
  }

  void updateMinPrice(double min) {
    emit(state.copyWith(minPrice: min));
  }

  void updatePercentage(double percent) {
    emit(state.copyWith(percentage: percent));
  }

  void updateStartDate(DateTime date) {
    emit(state.copyWith(startDate: date));
  }

  void updateEndDate(DateTime date) {
    emit(state.copyWith(endDate: date));
  }

  void loadFromModel(SellerCouponModel model) {
    emit(
      CoupenFieldsUpdated(
        sellerId: model.sellerId,
        minPrice: model.minimumPrice,
        islive: model.isActive,
        couponName: model.couponName,
        percentage: model.discountPercentage,
        startDate: model.startTime,
        endDate: model.endTime,
      ),
    );
  }

  void reset() {
    emit(
      CoupenFieldsUpdated(
        id: null,
        sellerId: null,
        minPrice: 0,
        islive: true,
        couponName: "",
        percentage: 0,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
      ),
    );
  }
}
