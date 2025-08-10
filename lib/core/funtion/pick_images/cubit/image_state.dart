part of 'image_cubit.dart';

@immutable
sealed class PickimageState {}

final class PickimageInitial extends PickimageState {}

final class PickimagePicked extends PickimageState {
  final List<Uint8List> images;
  PickimagePicked(this.images);
}

final class PickimageError extends PickimageState {
  final String error;
  PickimageError(this.error);
}
