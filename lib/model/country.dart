part of 'model.dart';

class Country extends Equatable {
  final String? id;
  final String? name;

  const Country({this.id, this.name});

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json['country_id'] as String?,
    name: json['country_name'] as String?,
  );

  Map<String, dynamic> toJson() => {'country_id': id, 'country_name': name};

  @override
  List<Object?> get props => [id, name];
}
