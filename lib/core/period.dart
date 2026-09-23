/// Rentang periode laporan. Inclusive: start 00:00:00 - end 23:59:59.
/// Dipakai oleh reports/domain/usecases/get_report.dart.
enum ReportPeriodType { today, week, month, year, custom }

class DateRange {
  const DateRange({required this.start, required this.end});
  final DateTime start;
  final DateTime end;
}

DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime _endOfDay(DateTime d) =>
    DateTime(d.year, d.month, d.day, 23, 59, 59, 999);

/// Minggu dimulai Senin (sesuai kesepakatan plan).
DateRange resolvePeriod(
  ReportPeriodType type, {
  DateTime? now,
  DateTime? customStart,
  DateTime? customEnd,
}) {
  final ref = now ?? DateTime.now();
  switch (type) {
    case ReportPeriodType.today:
      return DateRange(start: _startOfDay(ref), end: _endOfDay(ref));
    case ReportPeriodType.week:
      final monday = _startOfDay(ref.subtract(Duration(days: ref.weekday - 1)));
      final sunday = _endOfDay(monday.add(const Duration(days: 6)));
      return DateRange(start: monday, end: sunday);
    case ReportPeriodType.month:
      final first = DateTime(ref.year, ref.month, 1);
      final last = _endOfDay(DateTime(ref.year, ref.month + 1, 0));
      return DateRange(start: first, end: last);
    case ReportPeriodType.year:
      return DateRange(
        start: DateTime(ref.year, 1, 1),
        end: _endOfDay(DateTime(ref.year, 12, 31)),
      );
    case ReportPeriodType.custom:
      assert(customStart != null && customEnd != null,
          'customStart & customEnd wajib diisi untuk custom range');
      return DateRange(
        start: _startOfDay(customStart!),
        end: _endOfDay(customEnd!),
      );
  }
}
