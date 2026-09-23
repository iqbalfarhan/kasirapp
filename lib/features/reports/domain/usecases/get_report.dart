import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/reports/domain/entities/report_summary.dart';
import 'package:kasirapp/features/reports/domain/repositories/report_repository.dart';

class GetReportParams {
  const GetReportParams({required this.start, required this.end});
  final DateTime start;
  final DateTime end;
}

class GetReport implements UseCase<ReportSummary, GetReportParams> {
  const GetReport(this._repository);
  final ReportRepository _repository;

  @override
  Future<Result<ReportSummary>> call(GetReportParams params) {
    if (params.end.isBefore(params.start)) {
      return Future.value(const FailureResult<ReportSummary>(
          ValidationFailure('Tanggal akhir < tanggal awal')));
    }
    return _repository.getSummary(start: params.start, end: params.end);
  }
}
