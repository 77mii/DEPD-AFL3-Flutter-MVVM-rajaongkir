part of 'widgets.dart';

// Widget untuk menampilkan informasi biaya pengiriman dalam bentuk card
class CardCost extends StatefulWidget {
  final Costs cost;
  final VoidCallback? onTap;
  const CardCost(this.cost, {super.key, this.onTap});

  @override
  State<CardCost> createState() => _CardCostState();
}

class _CardCostState extends State<CardCost> {
  // Memformat angka menjadi mata uang Rupiah
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

  // Memformat satuan "day" menjadi "hari" pada estimasi pengiriman
  String formatEtd(String? etd) {
    if (etd == null || etd.isEmpty) return '-';
    return etd.replaceAll('day', 'hari').replaceAll('days', 'hari');
  }

  @override
  Widget build(BuildContext context) {
    Costs cost = widget.cost;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue[800]!),
      ),
      margin: const EdgeInsetsDirectional.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      color: Colors.white,
      child: ListTile(
        onTap: widget.onTap,
        title: Text(
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.w700,
          ),
          "${cost.name}: ${cost.service}",
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              "Biaya: ${currencyFormatter(cost.cost, cost.currency)}",
            ),
            const SizedBox(height: 4),
            Text(
              style: TextStyle(color: Colors.green[800]),
              "Estimasi sampai: ${formatEtd(cost.etd)}",
            ),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[50],
          child: Icon(Icons.local_shipping, color: Colors.blue[800]),
        ),
      ),
    );
  }
}
