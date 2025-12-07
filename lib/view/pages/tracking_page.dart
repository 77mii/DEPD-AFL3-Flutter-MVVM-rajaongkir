part of 'pages.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final waybillController = TextEditingController();
  final phoneController = TextEditingController();
  String selectedCourier = "jne";
  final List<String> courierOptions = [
    "jne",
    "pos",
    "tiki",
    "sicepat",
    "jnt",
    "anteraja",
    "gojek",
    "grab",
    "ninja",
    "lion",
  ];

  @override
  void dispose() {
    waybillController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButton<String>(
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
                      onChanged: (v) =>
                          setState(() => selectedCourier = v ?? "jne"),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: waybillController,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Resi',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: '3-5 Digit Terakhir No. HP (Opsional)',
                        hintText:
                            'Diperlukan untuk kurir tertentu (misal: JNE)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (waybillController.text.isNotEmpty) {
                            Provider.of<TrackingViewModel>(
                              context,
                              listen: false,
                            ).getTrackingData(
                              waybillController.text,
                              selectedCourier,
                              lastPhoneNumber: phoneController.text,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.all(16),
                        ),
                        child: const Text(
                          "Lacak Paket",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Consumer<TrackingViewModel>(
              builder: (context, vm, _) {
                switch (vm.trackingData.status) {
                  case Status.loading:
                    return const Center(child: CircularProgressIndicator());
                  case Status.error:
                    return Text(
                      vm.trackingData.message ?? "Error",
                      style: const TextStyle(color: Colors.red),
                    );
                  case Status.completed:
                    final data = vm.trackingData.data;
                    if (data == null) return const Text("Data tidak ditemukan");
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryCard(data),
                        const SizedBox(height: 16),
                        const Text(
                          "Riwayat Pengiriman",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildManifestList(data.manifest ?? []),
                      ],
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(Tracking data) {
    final summary = data.summary;
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Status: ${data.deliveryStatus?.status ?? summary?.status}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(),
            Text("Kurir: ${summary?.courierName}"),
            Text("Layanan: ${summary?.serviceCode}"),
            Text("Pengirim: ${summary?.shipperName}"),
            Text("Penerima: ${summary?.receiverName}"),
            Text("Asal: ${summary?.origin}"),
            Text("Tujuan: ${summary?.destination}"),
          ],
        ),
      ),
    );
  }

  Widget _buildManifestList(List<TrackingManifest> manifest) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: manifest.length,
      itemBuilder: (context, index) {
        final item = manifest[index];
        return Card(
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.manifestDate ?? "",
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  item.manifestTime ?? "",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            title: Text(item.manifestDescription ?? ""),
            subtitle: Text(item.cityName ?? ""),
          ),
        );
      },
    );
  }
}
