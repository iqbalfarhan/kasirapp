import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/core/period.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/providers.dart';
import 'package:kasirapp/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:kasirapp/features/transactions/domain/entities/transaction.dart';
import 'package:kasirapp/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:kasirapp/features/transactions/domain/usecases/get_transactions.dart';

enum HistoryRange { today, last7, last30, custom }

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepositoryImpl(ref.watch(databaseProvider)),
);

final historyRangeProvider =
    StateProvider<HistoryRange>((ref) => HistoryRange.today);

final historyCustomProvider = StateProvider<DateRange?>((ref) => null);

final historyQueryProvider = StateProvider<String>((ref) => '');

DateRange _resolve(HistoryRange range, DateRange? custom) {
  final now = DateTime.now();
  switch (range) {
    case HistoryRange.today:
      return resolvePeriod(ReportPeriodType.today, now: now);
    case HistoryRange.last7:
      final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
      return DateRange(
          start: end.subtract(const Duration(days: 6)), end: end);
    case HistoryRange.last30:
      final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
      return DateRange(
          start: end.subtract(const Duration(days: 29)), end: end);
    case HistoryRange.custom:
      return custom ??
          resolvePeriod(ReportPeriodType.today, now: now);
  }
}

final historyListProvider =
    FutureProvider<List<Transaction>>((ref) async {
  final range = _resolve(
    ref.watch(historyRangeProvider),
    ref.watch(historyCustomProvider),
  );
  final result = await GetTransactions(
      ref.watch(transactionRepositoryProvider))(GetTransactionsParams(
    start: range.start,
    end: range.end,
    query: ref.watch(historyQueryProvider),
  ));
  return switch (result) {
    Success() => result.data,
    FailureResult() => throw result.failure.message,
  };
});

final historyDetailProvider =
    FutureProvider.family<Transaction, String>((ref, id) async {
  final result =
      await ref.watch(transactionRepositoryProvider).getDetail(id);
  return switch (result) {
    Success() => result.data,
    FailureResult() => throw result.failure.message,
  };
});
