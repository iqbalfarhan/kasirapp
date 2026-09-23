import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/reports/domain/entities/report_summary.dart';

abstract class ReportRepository {
  Future<Result<ReportSummary>> getSummary(
      {required DateTime start, required DateTime end});
}
