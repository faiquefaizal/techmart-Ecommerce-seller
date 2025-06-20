import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'current_varient_state.dart';

class CurrentVarientCubit extends Cubit<CurrentVarientState> {
  CurrentVarientCubit() : super(CurrentVarientState.initial());

  void updateCategoryId(String? categoryId) {
    emit(state.copyWith(categoryId: categoryId, variantAttributes: {}));
  }

  void updateBrandId(String? brandId) {
    emit(state.copyWith(brandId: brandId));
  }

  void updateBrandIdAndCategoryId(String brandId, String catagoryId) {
    emit(state.copyWith(brandId: brandId, categoryId: catagoryId));
  }

  void updateVariantAttribute(String variantName, String? variantValue) {
    final updatedAttributes = Map<String, String?>.from(
      state.variantAttributes,
    );
    updatedAttributes[variantName] = variantValue;
    emit(state.copyWith(variantAttributes: updatedAttributes));
  }

  void clearInputs() {
    emit(state.copyWith(variantAttributes: {}));
  }

  void clearAllInputs() {
    emit(
      state.copyWith(variantAttributes: {}, categoryId: null, brandId: null),
    );
  }
}
