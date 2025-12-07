part of 'model.dart';

class Costs extends Equatable {
  final String? name;
  final String? code;
  final String? service;
  final String? description;
  final String? currency;
  final double? cost;
  final String? etd;

  const Costs({
    this.name,
    this.code,
    this.service,
    this.description,
    this.currency,
    this.cost,
    this.etd,
  });

  factory Costs.fromJson(Map<String, dynamic> json) => Costs(
    name: json['name'] as String?,
    code: json['code'] as String?,
    service: json['service'] as String?,
    description: json['description'] as String?,
    currency: json['currency'] as String?,
    cost: (json['cost'] as num?)?.toDouble(),
    etd: json['etd'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'code': code,
    'service': service,
    'description': description,
    'currency': currency,
    'cost': cost,
    'etd': etd,
  };

  @override
  List<Object?> get props {
    return [name, code, service, description, currency, cost, etd];
  }
}
