import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/core/period.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/providers.dart';
import 'package:kasirapp/features/reports/data/repositories/report_repository_impl.dart';
import 'package:kasirapp/features/reports/domain/entities/report_summary.dart';
import 'package:kasirapp/features/reports/domain/repositories/report_repository.dart';
import 'package:kasirapp/features/reports/domain/usecases/get_report.dart';

enum ReportRange { today, week, month, year, custom }

final reportRepositoryProvider = Provider<ReportRepository>(
  (ref) => ReportRepositoryImpl(ref.watch(databaseProvider)),
);

final reportRangeProvider =
    StateProvider<ReportRange>((ref) => ReportRange.week);

final reportCustomProvider = StateProvider<DateRange?>((ref) => null);

DateRange resolveReportRange(ReportRange range, DateRange? custom) {
  final now = DateTime.now();
  switch (range) {
    case ReportRange.today:
      return resolvePeriod(ReportPeriodType.today, now: now);
    case ReportRange.week:
      return resolvePeriod(ReportPeriodType.week, now: now);
    case ReportRange.month:
      return resolvePeriod(ReportPeriodType.month, now: now);
    case ReportRange.year:
      return resolvePeriod(ReportPeriodType.year, now: now);
    case ReportRange.custom:
      return custom ??
          resolvePeriod(ReportPeriodType.today, now: now);
  }
}

final reportProvider = FutureProvider<ReportData>((ref) async {
  final range = resolveReportRange(
    ref.watch(reportRangeProvider),
    ref.watch(reportCustomProvider),
  );
  final result = await GetReport(ref.watch(reportRepositoryProvider))(
      GetReportParams(start: range.start, end: range.end));
  return switch (result) {
    Success() => result.data,
    FailureResult() => throw result.failure.message,
  };
});
