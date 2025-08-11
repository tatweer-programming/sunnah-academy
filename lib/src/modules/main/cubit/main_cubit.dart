import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'main_state.dart';

class MainCubit extends HydratedCubit<MainState> {
  static MainCubit? _instance;
  static MainCubit get instance {
    _instance ??= MainCubit._internal();
    return _instance!;
  }

  MainCubit._internal() : super(MainState());

  void changeTheme() {
    emit(state.copyWith(isDarkModeEnabled: !state.isDarkModeEnabled));
  }

  @override
  MainState? fromJson(Map<String, dynamic> json) {
    final isDarkModeEnabled = json['isDarkModeEnabled'] ?? false;
    return MainState(isDarkModeEnabled: isDarkModeEnabled);
  }

  @override
  Map<String, dynamic>? toJson(MainState state) {
    return {'isDarkModeEnabled': state.isDarkModeEnabled};
  }
}
