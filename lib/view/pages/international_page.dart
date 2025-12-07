part of 'pages.dart';

class InternationalPage extends StatefulWidget {
  const InternationalPage({super.key});

  @override
  State<InternationalPage> createState() => _InternationalPageState();
}

class _InternationalPageState extends State<InternationalPage> {
  late InternationalViewModel internationalViewModel;
  final weightController = TextEditingController();
  final searchController = TextEditingController();

  // Daftar pilihan kurir internasional (contoh: pos, jne, tiki, dll yang support internasional)
  // Note: Tidak semua kurir support internasional, biasanya POS, JNE, TIKI, EXPEDITO
  final List<String> courierOptions = ["pos", "jne", "tiki", "expedito"];
  String selectedCourier = "pos";

  int? selectedProvinceOriginId;
  int? selectedCityOriginId;
  String? selectedCountryDestinationId;
  String? selectedCountryDestinationName;

  @override
  void initState() {
    super.initState();
    internationalViewModel = Provider.of<InternationalViewModel>(
      context,
      listen: false,
    );
    if (internationalViewModel.provinceList.status == Status.notStarted) {
      internationalViewModel.getProvinceList();
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _showCostDetail(BuildContext context, Costs cost) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CostDetailBottomSheet(cost: cost),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Courier & Weight
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedCourier,
                                items: courierOptions
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c.toUpperCase()),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) => setState(
                                  () => selectedCourier = v ?? "pos",
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: weightController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Berat (gr)',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Origin (Indonesia)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Origin (Indonesia)",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Consumer<InternationalViewModel>(
                                builder: (context, vm, _) {
                                  if (vm.provinceList.status ==
                                      Status.loading) {
                                    return const SizedBox(
                                      height: 40,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }
                                  final provinces = vm.provinceList.data ?? [];
                                  return DropdownButton<int>(
                                    isExpanded: true,
                                    value: selectedProvinceOriginId,
                                    hint: const Text('Pilih provinsi'),
                                    items: provinces
                                        .map(
                                          (p) => DropdownMenuItem<int>(
                                            value: p.id,
                                            child: Text(p.name ?? ''),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (newId) {
                                      setState(() {
                                        selectedProvinceOriginId = newId;
                                        selectedCityOriginId = null;
                                      });
                                      if (newId != null) {
                                        vm.getCityOriginList(newId);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Consumer<InternationalViewModel>(
                                builder: (context, vm, _) {
                                  if (vm.cityOriginList.status ==
                                      Status.loading) {
                                    return const SizedBox(
                                      height: 40,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }
                                  final cities = vm.cityOriginList.data ?? [];
                                  final validIds = cities
                                      .map((c) => c.id)
                                      .toSet();
                                  final validValue =
                                      validIds.contains(selectedCityOriginId)
                                      ? selectedCityOriginId
                                      : null;

                                  return DropdownButton<int>(
                                    isExpanded: true,
                                    value: validValue,
                                    hint: const Text('Pilih kota'),
                                    items: cities
                                        .map(
                                          (c) => DropdownMenuItem<int>(
                                            value: c.id,
                                            child: Text(c.name ?? ''),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (newId) {
                                      setState(() {
                                        selectedCityOriginId = newId;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(thickness: 2),
                        const SizedBox(height: 12),
                        // Destination (International)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Destination (International)",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            labelText: 'Cari Negara',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                internationalViewModel.searchCountry(
                                  searchController.text,
                                );
                              },
                            ),
                          ),
                          onSubmitted: (value) {
                            internationalViewModel.searchCountry(value);
                          },
                        ),
                        const SizedBox(height: 8),
                        Consumer<InternationalViewModel>(
                          builder: (context, vm, _) {
                            if (vm.countryList.status == Status.loading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              );
                            }
                            if (vm.countryList.status == Status.completed) {
                              final countries = vm.countryList.data ?? [];
                              if (countries.isEmpty) {
                                return const Text("Negara tidak ditemukan");
                              }
                              // Tampilkan hasil pencarian sebagai list atau dropdown
                              // Di sini kita gunakan Dropdown untuk memilih dari hasil pencarian
                              final validIds = countries
                                  .map((c) => c.id)
                                  .toSet();
                              final validValue =
                                  validIds.contains(
                                    selectedCountryDestinationId,
                                  )
                                  ? selectedCountryDestinationId
                                  : null;

                              return DropdownButton<String>(
                                isExpanded: true,
                                value: validValue,
                                hint: const Text('Pilih negara tujuan'),
                                items: countries
                                    .map(
                                      (c) => DropdownMenuItem<String>(
                                        value: c.id,
                                        child: Text(c.name ?? ''),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (newId) {
                                  setState(() {
                                    selectedCountryDestinationId = newId;
                                    selectedCountryDestinationName = countries
                                        .firstWhere((c) => c.id == newId)
                                        .name;
                                  });
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedCityOriginId != null &&
                                  selectedCountryDestinationId != null &&
                                  weightController.text.isNotEmpty) {
                                final weight =
                                    int.tryParse(weightController.text) ?? 0;
                                if (weight <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Berat harus lebih dari 0'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                  return;
                                }
                                internationalViewModel
                                    .checkInternationalShipmentCost(
                                      selectedCityOriginId!.toString(),
                                      selectedCountryDestinationId!,
                                      weight,
                                      selectedCourier,
                                    );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Lengkapi semua field!'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.all(16),
                            ),
                            child: const Text(
                              "Hitung Ongkir Internasional",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Result
                Card(
                  color: Colors.blue[50],
                  elevation: 2,
                  child: Consumer<InternationalViewModel>(
                    builder: (context, vm, _) {
                      switch (vm.costList.status) {
                        case Status.loading:
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          );
                        case Status.error:
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                vm.costList.message ?? 'Error',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        case Status.completed:
                          if (vm.costList.data == null ||
                              vm.costList.data!.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text("Tidak ada data ongkir."),
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: vm.costList.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final cost = vm.costList.data!.elementAt(index);
                              return CardCost(
                                cost,
                                onTap: () => _showCostDetail(context, cost),
                              );
                            },
                          );
                        default:
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "Pilih lokasi dan klik Hitung Ongkir.",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Consumer<InternationalViewModel>(
            builder: (context, vm, _) {
              if (vm.isLoading) {
                return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
