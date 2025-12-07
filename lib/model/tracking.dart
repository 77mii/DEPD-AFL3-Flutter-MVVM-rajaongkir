part of 'model.dart';

class Tracking extends Equatable {
  final bool? delivered;
  final TrackingSummary? summary;
  final TrackingDetails? details;
  final TrackingDeliveryStatus? deliveryStatus;
  final List<TrackingManifest>? manifest;

  const Tracking({
    this.delivered,
    this.summary,
    this.details,
    this.deliveryStatus,
    this.manifest,
  });

  factory Tracking.fromJson(Map<String, dynamic> json) => Tracking(
    delivered: json['delivered'] as bool?,
    summary: json['summary'] == null
        ? null
        : TrackingSummary.fromJson(json['summary']),
    details: json['details'] == null
        ? null
        : TrackingDetails.fromJson(json['details']),
    deliveryStatus: json['delivery_status'] == null
        ? null
        : TrackingDeliveryStatus.fromJson(json['delivery_status']),
    manifest: (json['manifest'] as List?)
        ?.map((e) => TrackingManifest.fromJson(e))
        .toList(),
  );

  @override
  List<Object?> get props => [
    delivered,
    summary,
    details,
    deliveryStatus,
    manifest,
  ];
}

class TrackingSummary extends Equatable {
  final String? courierCode;
  final String? courierName;
  final String? waybillNumber;
  final String? serviceCode;
  final String? waybillDate;
  final String? shipperName;
  final String? receiverName;
  final String? origin;
  final String? destination;
  final String? status;

  const TrackingSummary({
    this.courierCode,
    this.courierName,
    this.waybillNumber,
    this.serviceCode,
    this.waybillDate,
    this.shipperName,
    this.receiverName,
    this.origin,
    this.destination,
    this.status,
  });

  factory TrackingSummary.fromJson(Map<String, dynamic> json) =>
      TrackingSummary(
        courierCode: json['courier_code'],
        courierName: json['courier_name'],
        waybillNumber: json['waybill_number'],
        serviceCode: json['service_code'],
        waybillDate: json['waybill_date'],
        shipperName: json['shipper_name'],
        receiverName: json['receiver_name'],
        origin: json['origin'],
        destination: json['destination'],
        status: json['status'],
      );

  @override
  List<Object?> get props => [courierCode, courierName, waybillNumber, status];
}

class TrackingDetails extends Equatable {
  final String? waybillNumber;
  final String? waybillDate;
  final String? waybillTime;
  final String? weight;
  final String? origin;
  final String? destination;
  final String? shipperName;
  final String? shipperAddress1;
  final String? receiverName;
  final String? receiverAddress1;

  const TrackingDetails({
    this.waybillNumber,
    this.waybillDate,
    this.waybillTime,
    this.weight,
    this.origin,
    this.destination,
    this.shipperName,
    this.shipperAddress1,
    this.receiverName,
    this.receiverAddress1,
  });

  factory TrackingDetails.fromJson(Map<String, dynamic> json) =>
      TrackingDetails(
        waybillNumber: json['waybill_number'],
        waybillDate: json['waybill_date'],
        waybillTime: json['waybill_time'],
        weight: json['weight'],
        origin: json['origin'],
        destination: json['destination'],
        shipperName: json['shippper_name'] ?? json['shipper_name'],
        shipperAddress1: json['shipper_address1'],
        receiverName: json['receiver_name'],
        receiverAddress1: json['receiver_address1'],
      );

  @override
  List<Object?> get props => [waybillNumber, origin, destination];
}

class TrackingDeliveryStatus extends Equatable {
  final String? status;
  final String? podReceiver;
  final String? podDate;
  final String? podTime;

  const TrackingDeliveryStatus({
    this.status,
    this.podReceiver,
    this.podDate,
    this.podTime,
  });

  factory TrackingDeliveryStatus.fromJson(Map<String, dynamic> json) =>
      TrackingDeliveryStatus(
        status: json['status'],
        podReceiver: json['pod_receiver'],
        podDate: json['pod_date'],
        podTime: json['pod_time'],
      );

  @override
  List<Object?> get props => [status, podReceiver, podDate, podTime];
}

class TrackingManifest extends Equatable {
  final String? manifestCode;
  final String? manifestDescription;
  final String? manifestDate;
  final String? manifestTime;
  final String? cityName;

  const TrackingManifest({
    this.manifestCode,
    this.manifestDescription,
    this.manifestDate,
    this.manifestTime,
    this.cityName,
  });

  factory TrackingManifest.fromJson(Map<String, dynamic> json) =>
      TrackingManifest(
        manifestCode: json['manifest_code'],
        manifestDescription: json['manifest_description'],
        manifestDate: json['manifest_date'],
        manifestTime: json['manifest_time'],
        cityName: json['city_name'],
      );

  @override
  List<Object?> get props => [
    manifestCode,
    manifestDescription,
    manifestDate,
    manifestTime,
    cityName,
  ];
}
