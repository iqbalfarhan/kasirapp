import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/reports/domain/entities/report_summary.dart';

abstract class ReportRepository {
  /// Agregat penuh satu rentang. Hanya transaksi sukses yang dihitung.
  Future<Result<ReportData>> getReport(
      {required DateTime start, required DateTime end});
}
