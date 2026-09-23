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

class GetReport implements UseCase<ReportData, GetReportParams> {
  const GetReport(this._repository);
  final ReportRepository _repository;

  @override
  Future<Result<ReportData>> call(GetReportParams params) {
    if (params.end.isBefore(params.start)) {
      return Future.value(const FailureResult<ReportData>(
          ValidationFailure('Tanggal akhir < tanggal awal')));
    }
    return _repository.getReport(start: params.start, end: params.end);
  }
}
