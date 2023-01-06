part of 'general_bloc.dart';

class GeneralState extends Equatable {
  const GeneralState({
    required this.currentStore,
  });

  final String? currentStore;

  GeneralState copyWith({
    String? currentStore,
  }) {
    return GeneralState(
      currentStore: currentStore ?? this.currentStore,
    );
  }

  @override
  List<Object?> get props => [
        currentStore,
      ];
}
