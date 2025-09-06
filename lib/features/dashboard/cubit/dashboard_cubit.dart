import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:techmart_seller/features/dashboard/service/dashboard_service.dart';
import 'package:rxdart/rxdart.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());
  void setupStreams() {
    final sellerId = DashboardService().sellerId;
    if (sellerId == null) {
      emit(DashboardInitial()); //
      return;
    }

    Rx.combineLatest3<int, int, int, DashboardState>(
      DashboardService().getProductCountBySellerId(sellerId),
      DashboardService().getTotalOrders(),
      DashboardService().getTotalApprovedReturns(),
      (productCount, orderCount, returnCount) {
        return DataLoaded(
          productCount: productCount,
          orderCount: orderCount,
          returnCount: returnCount,
        );
      },
    ).listen(
      (state) => emit(state),
      onError: (error) => emit(DashboardInitial()),
    );
  }
}
