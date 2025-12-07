part of 'model.dart';

class District extends Equatable {
  final int? id;
  final String? name;

  const District({this.id, this.name});

  factory District.fromJson(Map<String, dynamic> json) =>
      District(id: json['id'] as int?, name: json['name'] as String?);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}
