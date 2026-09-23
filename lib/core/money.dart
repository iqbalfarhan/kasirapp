/// Format & parse IDR tanpa dependensi intl (agar domain tetap murni).
/// Contoh: 15000 -> "Rp 15.000"
String formatRp(int amount) {
  final isNegative = amount < 0;
  final digits = amount.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final reversedIndex = digits.length - 1 - i;
    buffer.write(digits[reversedIndex]);
    if (i % 3 == 2 && i != digits.length - 1) {
      buffer.write('.');
    }
  }
  final grouped =
      buffer.toString().split('').reversed.join().replaceAll('..', '.');
  return '${isNegative ? '- ' : ''}Rp $grouped';
}

/// Parse "Rp 15.000" -> 15000. Mengabaikan non-digit kecuali tanda minus.
int parseRp(String input) {
  final trimmed = input.trim();
  final isNegative = trimmed.startsWith('-');
  final digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return 0;
  final value = int.parse(digits);
  return isNegative ? -value : value;
}
