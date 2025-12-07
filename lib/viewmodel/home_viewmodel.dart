import 'package:flutter/material.dart';
import 'package:depd_mvvm_2025/model/model.dart';
import 'package:depd_mvvm_2025/data/response/api_response.dart';
import 'package:depd_mvvm_2025/data/response/status.dart';
import 'package:depd_mvvm_2025/repository/home_repository.dart';

// ViewModel untuk mengelola data dan state Home (provinsi, kota, ongkir)
class HomeViewModel with ChangeNotifier {
  // Repository untuk akses API
  final _homeRepo = HomeRepository();

  // State daftar provinsi
  ApiResponse<List<Province>> provinceList = ApiResponse.notStarted();
  setProvinceList(ApiResponse<List<Province>> response) {
    provinceList = response;
    // Untuk memberitahu semua widget yang sedang mendengarkan (listening) bahwa ketika ada perubahan data yang terjadi, maka widget tersebut perlu di-rebuild (render ulang).
    notifyListeners();
  }

  // Ambil daftar provinsi
  Future getProvinceList() async {
    if (provinceList.status == Status.completed) return;
    setProvinceList(ApiResponse.loading());
    // Panggil repository untuk fetch data dan sesuaikan output berdasarkan statusnya
    _homeRepo
        // fetchProvinceList() akan mengembalikan Future<List<Province>>
        .fetchProvinceList()
        // Menggunakan then untuk menangani hasil sukses
        .then((value) {
          setProvinceList(ApiResponse.completed(value));
        })
        // Menggunakan onError untuk menangani error
        .onError((error, _) {
          setProvinceList(ApiResponse.error(error.toString()));
        });
  }

  // Cache kota per id provinsi agar tidak panggil API berulang
  final Map<int, List<City>> _cityCache = {};

  // State daftar kota asal
  ApiResponse<List<City>> cityOriginList = ApiResponse.notStarted();
  setCityOriginList(ApiResponse<List<City>> response) {
    cityOriginList = response;
    notifyListeners();
  }

  // Ambil kota asal
  Future getCityOriginList(int provId) async {
    if (_cityCache.containsKey(provId)) {
      setCityOriginList(ApiResponse.completed(_cityCache[provId]!));
      return;
    }
    setCityOriginList(ApiResponse.loading());
    _homeRepo
        .fetchCityList(provId)
        .then((value) {
          _cityCache[provId] = value;
          setCityOriginList(ApiResponse.completed(value));
        })
        .onError((error, _) {
          setCityOriginList(ApiResponse.error(error.toString()));
        });
  }

  // State daftar kota tujuan
  ApiResponse<List<City>> cityDestinationList = ApiResponse.notStarted();
  setCityDestinationList(ApiResponse<List<City>> response) {
    cityDestinationList = response;
    notifyListeners();
  }

  // Ambil kota tujuan
  Future getCityDestinationList(int provId) async {
    if (_cityCache.containsKey(provId)) {
      setCityDestinationList(ApiResponse.completed(_cityCache[provId]!));
      return;
    }
    setCityDestinationList(ApiResponse.loading());
    _homeRepo
        .fetchCityList(provId)
        .then((value) {
          _cityCache[provId] = value;
          setCityDestinationList(ApiResponse.completed(value));
        })
        .onError((error, _) {
          setCityDestinationList(ApiResponse.error(error.toString()));
        });
  }

  // Cache kecamatan per id kota
  final Map<int, List<District>> _districtCache = {};

  // State daftar kecamatan asal
  ApiResponse<List<District>> districtOriginList = ApiResponse.notStarted();
  setDistrictOriginList(ApiResponse<List<District>> response) {
    districtOriginList = response;
    notifyListeners();
  }

  // Ambil kecamatan asal
  Future getDistrictOriginList(int cityId) async {
    if (_districtCache.containsKey(cityId)) {
      setDistrictOriginList(ApiResponse.completed(_districtCache[cityId]!));
      return;
    }
    setDistrictOriginList(ApiResponse.loading());
    _homeRepo
        .fetchDistrictList(cityId)
        .then((value) {
          _districtCache[cityId] = value;
          setDistrictOriginList(ApiResponse.completed(value));
        })
        .onError((error, _) {
          setDistrictOriginList(ApiResponse.error(error.toString()));
        });
  }

  // State daftar kecamatan tujuan
  ApiResponse<List<District>> districtDestinationList =
      ApiResponse.notStarted();
  setDistrictDestinationList(ApiResponse<List<District>> response) {
    districtDestinationList = response;
    notifyListeners();
  }

  // Ambil kecamatan tujuan
  Future getDistrictDestinationList(int cityId) async {
    if (_districtCache.containsKey(cityId)) {
      setDistrictDestinationList(
        ApiResponse.completed(_districtCache[cityId]!),
      );
      return;
    }
    setDistrictDestinationList(ApiResponse.loading());
    _homeRepo
        .fetchDistrictList(cityId)
        .then((value) {
          _districtCache[cityId] = value;
          setDistrictDestinationList(ApiResponse.completed(value));
        })
        .onError((error, _) {
          setDistrictDestinationList(ApiResponse.error(error.toString()));
        });
  }

  // State daftar biaya ongkir
  ApiResponse<List<Costs>> costList = ApiResponse.notStarted();
  setCostList(ApiResponse<List<Costs>> response) {
    costList = response;
    notifyListeners();
  }

  // Flag loading untuk proses cek ongkir
  bool isLoading = false;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Hitung biaya pengiriman (set loading + handle success/error). Terdapat objek yang merepresentasikan nilai (atau error) yang akan tersedia di masa depan (asynchronous)
  Future checkShipmentCost(
    String origin,
    String originType,
    String destination,
    String destinationType,
    int weight,
    String courier,
  ) async {
    setLoading(true);
    setCostList(ApiResponse.loading());
    _homeRepo
        .checkShipmentCost(
          origin,
          originType,
          destination,
          destinationType,
          weight,
          courier,
        )
        .then((value) {
          setCostList(ApiResponse.completed(value));
          setLoading(false);
        })
        .onError((error, _) {
          setCostList(ApiResponse.error(error.toString()));
          setLoading(false);
        });
  }
}
