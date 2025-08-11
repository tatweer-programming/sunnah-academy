part of 'main_cubit.dart';

class MainState extends Equatable {
  final bool isDarkModeEnabled;
  const MainState({
    this.isDarkModeEnabled = false,
  });
  MainState copyWith({bool? isDarkModeEnabled}) {
    return MainState(
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
    );
  }

  @override
  List<Object> get props => [isDarkModeEnabled];
}
