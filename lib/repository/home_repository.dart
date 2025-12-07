import 'package:depd_mvvm_2025/data/network/network_api_service.dart';
import 'package:depd_mvvm_2025/model/model.dart';

// Repository untuk menangani logika bisnis terkait data ongkir
class HomeRepository {
  // NetworkApiServices hanya perlu 1 instance sehingga tidak perlu ganti service selama aplikasi berjalan
  final _apiServices = NetworkApiServices();

  // Mengambil daftar provinsi dari API
  Future<List<Province>> fetchProvinceList() async {
    final response = await _apiServices.getApiResponse('destination/province');

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data provinsi
    final data = response['data'];
    if (data is! List) return [];

    // Ubah setiap item (Map) menjadi object Province
    return data.map((e) => Province.fromJson(e)).toList();
  }

  // Mengambil daftar kota berdasarkan ID provinsi
  Future<List<City>> fetchCityList(var provId) async {
    final response = await _apiServices.getApiResponse(
      'destination/city/$provId',
    );

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data kota
    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => City.fromJson(e)).toList();
  }

  // Mengambil daftar kecamatan berdasarkan ID kota
  Future<List<District>> fetchDistrictList(var cityId) async {
    final response = await _apiServices.getApiResponse(
      'destination/district/$cityId',
    );

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data kecamatan
    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => District.fromJson(e)).toList();
  }

  // Menghitung biaya pengiriman berdasarkan parameter yang diberikan
  Future<List<Costs>> checkShipmentCost(
    String origin,
    String originType,
    String destination,
    String destinationType,
    int weight,
    String courier,
  ) async {
    String endpoint = 'calculate/domestic-cost';
    if (originType == 'subdistrict' || destinationType == 'subdistrict') {
      endpoint = 'calculate/district/domestic-cost';
    }

    // Kirim request POST untuk kalkulasi ongkir
    final response = await _apiServices.postApiResponse(endpoint, {
      "origin": origin,
      "destination": destination,
      "weight": weight.toString(),
      "courier": courier,
    });

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data biaya pengiriman
    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => Costs.fromJson(e)).toList();
  }

  // Mencari negara tujuan internasional
  Future<List<Country>> fetchInternationalDestination(String query) async {
    final response = await _apiServices.getApiResponse(
      'destination/international-destination?search=$query&limit=100',
    );

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      // Jika data tidak ditemukan (404), kembalikan list kosong
      if (meta['code'] == 404) return [];
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data negara
    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => Country.fromJson(e)).toList();
  }

  // Menghitung biaya pengiriman internasional
  Future<List<Costs>> checkInternationalShipmentCost(
    String origin,
    String destination,
    int weight,
    String courier,
  ) async {
    final response = await _apiServices
        .postApiResponse('calculate/international-cost', {
          "origin": origin,
          "destination": destination,
          "weight": weight.toString(),
          "courier": courier,
        });

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data biaya pengiriman
    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => Costs.fromJson(e)).toList();
  }

  // Melacak status pengiriman berdasarkan nomor resi
  Future<Tracking?> fetchWaybill(
    String waybill,
    String courier, {
    String? lastPhoneNumber,
  }) async {
    final body = {"awb": waybill, "courier": courier};

    if (lastPhoneNumber != null && lastPhoneNumber.isNotEmpty) {
      body['last_phone_number'] = lastPhoneNumber;
    }

    final response = await _apiServices.postApiResponse('track/waybill', body);

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data tracking
    final data = response['data'];
    if (data == null) return null;

    return Tracking.fromJson(data);
  }
}
