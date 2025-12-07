import 'package:flutter/material.dart';
import 'package:depd_mvvm_2025/data/response/api_response.dart';
import 'package:depd_mvvm_2025/model/model.dart';
import 'package:depd_mvvm_2025/repository/home_repository.dart';

class TrackingViewModel with ChangeNotifier {
  final _homeRepo = HomeRepository();

  ApiResponse<Tracking> trackingData = ApiResponse.notStarted();

  void setTrackingData(ApiResponse<Tracking> response) {
    trackingData = response;
    notifyListeners();
  }

  Future<void> getTrackingData(
    String waybill,
    String courier, {
    String? lastPhoneNumber,
  }) async {
    setTrackingData(ApiResponse.loading());
    try {
      final value = await _homeRepo.fetchWaybill(
        waybill,
        courier,
        lastPhoneNumber: lastPhoneNumber,
      );
      setTrackingData(ApiResponse.completed(value));
    } catch (e) {
      String message = e.toString();
      if (message.contains("Invalid Awb")) {
        message =
            "No Resi tidak ditemukan, No Telpon penerima tidak sesuai/lengkap";
      }
      setTrackingData(ApiResponse.error(message));
    }
  }
}
