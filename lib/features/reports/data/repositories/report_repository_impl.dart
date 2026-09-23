import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/reports/domain/entities/report_summary.dart';
import 'package:kasirapp/features/reports/domain/repositories/report_repository.dart';

/// TODO Fase 4: agregasi Drift (exclude status batal).
class ReportRepositoryImpl implements ReportRepository {
  const ReportRepositoryImpl();

  @override
  Future<Result<ReportSummary>> getSummary(
          {required DateTime start, required DateTime end}) async =>
      const FailureResult(
          DatabaseFailure('Belum diimplementasi (Fase 4: Drift)'));
}
