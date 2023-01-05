part of 'general_bloc.dart';

class GeneralState extends Equatable {
  const GeneralState({
    // required this.id,
    required this.currentStore,
  });

  final String? currentStore;
  //final int? id;

  GeneralState copyWith({
    String? currentStore,
    // int? id ,
  }) {
    return GeneralState(
      currentStore: currentStore ?? this.currentStore,
      // id:  id ,
    );
  }

  @override
  List<Object?> get props => [
        currentStore,
        //id
      ];
}
