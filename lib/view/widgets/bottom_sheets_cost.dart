part of 'widgets.dart';

class CostDetailBottomSheet extends StatelessWidget {
  final Costs cost;

  const CostDetailBottomSheet({super.key, required this.cost});

  String currencyFormatter(num? value, String? currency) {
    String symbol = (currency?.toUpperCase() == 'IDR' || currency == null)
        ? 'Rp'
        : currency;

    if (value == null) return "${symbol}0,00";
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  String formatEtd(String? etd) {
    if (etd == null || etd.isEmpty) return '-';
    return etd.replaceAll('day', 'hari').replaceAll('days', 'hari');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              "Detail Layanan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow("Nama Layanan", cost.service ?? "-"),
            _buildDetailRow("Deskripsi", cost.description ?? "-"),
            _buildDetailRow(
              "Biaya",
              currencyFormatter(cost.cost, cost.currency),
            ),
            _buildDetailRow("Estimasi", formatEtd(cost.etd)),
            if (cost.name != null) _buildDetailRow("Kurir", cost.name!),
            if (cost.code != null) _buildDetailRow("Kode", cost.code!),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
