import 'package:equatable/equatable.dart';

class PetProfileState extends Equatable {
  final String name;
  final String? species;
  final String? sex;
  final DateTime? birthday;
  final String? weight;

  const PetProfileState({
    this.name = '',
    this.species,
    this.sex,
    this.birthday,
    this.weight,
  });

  PetProfileState copyWith({
    String? name,
    String? species,
    String? sex,
    DateTime? birthday,
    String? weight,
  }) {
    return PetProfileState(
      name: name ?? this.name,
      species: species ?? this.species,
      sex: sex ?? this.sex,
      birthday: birthday ?? this.birthday,
      weight: weight ?? this.weight,
    );
  }

  @override
  List<Object?> get props => [name, species, sex, birthday, weight];
}
