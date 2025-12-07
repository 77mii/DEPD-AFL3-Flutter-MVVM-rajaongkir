import 'package:flutter/material.dart';
import 'package:depd_mvvm_2025/model/model.dart';
import 'package:depd_mvvm_2025/data/response/api_response.dart';
import 'package:depd_mvvm_2025/data/response/status.dart';
import 'package:depd_mvvm_2025/repository/home_repository.dart';

class InternationalViewModel with ChangeNotifier {
  final _homeRepo = HomeRepository();

  // State daftar provinsi (untuk origin)
  ApiResponse<List<Province>> provinceList = ApiResponse.notStarted();
  setProvinceList(ApiResponse<List<Province>> response) {
    provinceList = response;
    notifyListeners();
  }

  Future getProvinceList() async {
    if (provinceList.status == Status.completed) return;
    setProvinceList(ApiResponse.loading());
    _homeRepo
        .fetchProvinceList()
        .then((value) {
          setProvinceList(ApiResponse.completed(value));
        })
        .onError((error, _) {
          setProvinceList(ApiResponse.error(error.toString()));
        });
  }

  // Cache kota per id provinsi
  final Map<int, List<City>> _cityCache = {};

  // State daftar kota asal
  ApiResponse<List<City>> cityOriginList = ApiResponse.notStarted();
  setCityOriginList(ApiResponse<List<City>> response) {
    cityOriginList = response;
    notifyListeners();
  }

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

  // State pencarian negara tujuan
  ApiResponse<List<Country>> countryList = ApiResponse.notStarted();
  setCountryList(ApiResponse<List<Country>> response) {
    countryList = response;
    notifyListeners();
  }

  Future searchCountry(String query) async {
    if (query.isEmpty) {
      setCountryList(ApiResponse.notStarted());
      return;
    }
    setCountryList(ApiResponse.loading());
    _homeRepo
        .fetchInternationalDestination(query)
        .then((value) {
          setCountryList(ApiResponse.completed(value));
        })
        .onError((error, _) {
          setCountryList(ApiResponse.error(error.toString()));
        });
  }

  // State daftar biaya ongkir
  ApiResponse<List<Costs>> costList = ApiResponse.notStarted();
  setCostList(ApiResponse<List<Costs>> response) {
    costList = response;
    notifyListeners();
  }

  bool isLoading = false;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future checkInternationalShipmentCost(
    String origin,
    String destination,
    int weight,
    String courier,
  ) async {
    setLoading(true);
    setCostList(ApiResponse.loading());
    _homeRepo
        .checkInternationalShipmentCost(origin, destination, weight, courier)
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
