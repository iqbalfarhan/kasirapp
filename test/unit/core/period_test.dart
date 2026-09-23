import 'package:flutter_test/flutter_test.dart';
import 'package:kasirapp/core/period.dart';

/// Batas periode laporan: inclusive 00:00–23:59, minggu Senin–Minggu.
void main() {
  group('today', () {
    test('sama hari 00:00 - 23:59', () {
      final r = resolvePeriod(ReportPeriodType.today,
          now: DateTime(2026, 5, 13, 15, 30));
      expect(r.start, DateTime(2026, 5, 13));
      expect(r.end.year, 2026);
      expect(r.end.month, 5);
      expect(r.end.day, 13);
      expect(r.end.hour, 23);
    });
  });

  group('week (Senin–Minggu)', () {
    test('Rabu → Senin s/d Minggu sama', () {
      final r = resolvePeriod(ReportPeriodType.week,
          now: DateTime(2026, 5, 13)); // Rabu
      expect(r.start, DateTime(2026, 5, 11));
      expect(r.end.day, 17);
      expect(r.start.weekday, DateTime.monday);
      expect(r.end.weekday, DateTime.sunday);
    });
    test('Minggu → 6 hari sebelumnya', () {
      final r = resolvePeriod(ReportPeriodType.week,
          now: DateTime(2026, 5, 17)); // Minggu
      expect(r.start, DateTime(2026, 5, 11));
      expect(r.end.day, 17);
    });
    test('Senin → hari itu s/d +6', () {
      final r = resolvePeriod(ReportPeriodType.week,
          now: DateTime(2026, 5, 11)); // Senin
      expect(r.start, DateTime(2026, 5, 11));
      expect(r.end.day, 17);
    });
    test('lintas bulan', () {
      final r = resolvePeriod(ReportPeriodType.week,
          now: DateTime(2026, 6, 1)); // Senin 1 Jun
      expect(r.start, DateTime(2026, 6, 1));
      expect(r.end, DateTime(2026, 6, 7, 23, 59, 59, 999));
    });
  });

  group('month', () {
    test('Mei 31 hari penuh', () {
      final r = resolvePeriod(ReportPeriodType.month,
          now: DateTime(2026, 5, 13));
      expect(r.start, DateTime(2026, 5, 1));
      expect(r.end.day, 31);
    });
    test('Februari kabisat 2024 = 29 hari', () {
      final r = resolvePeriod(ReportPeriodType.month,
          now: DateTime(2024, 2, 10));
      expect(r.start, DateTime(2024, 2, 1));
      expect(r.end.day, 29);
    });
    test('Februari non-kabisat 2026 = 28 hari', () {
      final r = resolvePeriod(ReportPeriodType.month,
          now: DateTime(2026, 2, 10));
      expect(r.end.day, 28);
    });
    test('Desember lintas tahun tetap benar', () {
      final r = resolvePeriod(ReportPeriodType.month,
          now: DateTime(2026, 12, 25));
      expect(r.start, DateTime(2026, 12, 1));
      expect(r.end.day, 31);
    });
  });

  group('year', () {
    test('1 Jan - 31 Des', () {
      final r = resolvePeriod(ReportPeriodType.year,
          now: DateTime(2026, 7, 1));
      expect(r.start, DateTime(2026, 1, 1));
      expect(r.end.day, 31);
      expect(r.end.month, 12);
    });
  });

  group('custom', () {
    test('inclusive walau jam acak', () {
      final r = resolvePeriod(
        ReportPeriodType.custom,
        customStart: DateTime(2026, 5, 1, 15),
        customEnd: DateTime(2026, 5, 3, 2),
      );
      expect(r.start, DateTime(2026, 5, 1));
      expect(r.end.day, 3);
      expect(r.end.hour, 23);
    });
    test('satu hari', () {
      final r = resolvePeriod(
        ReportPeriodType.custom,
        customStart: DateTime(2026, 5, 5),
        customEnd: DateTime(2026, 5, 5),
      );
      expect(r.start.day, 5);
      expect(r.end.day, 5);
    });
  });
}
