part of 'current_varient_cubit.dart';

@immutable
class CurrentVarientState {
  final String? categoryId;
  final String? brandId;
  final Map<String, String?> variantAttributes;

  const CurrentVarientState({
    this.categoryId,
    this.brandId,
    required this.variantAttributes,
  });

  factory CurrentVarientState.initial() {
    return const CurrentVarientState(
      categoryId: null,
      brandId: null,
      variantAttributes: {},
    );
  }
  CurrentVarientState copyWith({
    String? categoryId,
    String? brandId,
    Map<String, String?>? variantAttributes,
  }) {
    return CurrentVarientState(
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      variantAttributes: variantAttributes ?? this.variantAttributes,
    );
  }
}
