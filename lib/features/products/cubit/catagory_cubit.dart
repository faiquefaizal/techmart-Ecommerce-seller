import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class CatagoryCubit extends Cubit<String?> {
  CatagoryCubit() : super(null);

  void selectCategory(String? id) {
    emit(id);
  }
}
