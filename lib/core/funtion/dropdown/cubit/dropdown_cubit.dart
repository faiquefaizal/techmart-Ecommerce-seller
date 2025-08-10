import 'package:bloc/bloc.dart';

class DropdownCubit extends Cubit<String?> {
  DropdownCubit() : super(null);
  void selectItem(data) {
    emit(data);
  }
}
