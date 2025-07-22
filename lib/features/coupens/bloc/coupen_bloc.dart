import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:techmart_seller/features/coupens/models/coupen_model.dart';
import 'package:techmart_seller/features/coupens/service/coupon_service.dart';

part 'coupen_event.dart';
part 'coupen_state.dart';

class CoupenBloc extends Bloc<CoupenEvent, CoupenState> {
  final CouponService _service = CouponService();

  CoupenBloc() : super(CoupenInitial()) {
    on<FechCoupensEvent>((event, emit) async {
      emit(CoupenLoading());
      try {
        final coupons = await _service.getSellerCoupons();
        if (coupons.isEmpty) {
          emit((CoupensIsEmpty()));
        } else {
          emit(CoupenLoaded(coupons));
        }
      } catch (e) {
        emit(CoupenError(e.toString()));
      }
    });

    on<AddCoupenEvent>((event, emit) async {
      try {
        await _service.addCoupon(event.couponModel);
        emit(CoupenAdding());
        await Future.delayed(Duration(seconds: 2));
        emit(CoupenAdded());
        add(FechCoupensEvent());
      } catch (e) {
        emit(CoupenError(e.toString()));
      }
    });

    on<EditCoupenEvent>((event, emit) async {
      try {
        await _service.updateCoupon(event.couponModel);
        add(FechCoupensEvent());
      } catch (e) {
        emit(CoupenError(e.toString()));
      }
    });

    on<DeleteCoupenEvent>((event, emit) async {
      try {
        await _service.deleteCoupon(event.id);
        add(FechCoupensEvent());
      } catch (e) {
        emit(CoupenError(e.toString()));
      }
    });

    on<ToggleEvent>((event, emit) async {
      try {
        await _service.toggleLive(event.couponModel);
        add(FechCoupensEvent());
      } catch (e) {
        emit(CoupenError(e.toString()));
      }
    });
  }
}
