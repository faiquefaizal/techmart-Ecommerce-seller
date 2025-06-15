import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class DropdownCubit extends Cubit<String?> {
  DropdownCubit() : super(null);
  void selectItem(data) {
    emit(data);
  }
}
