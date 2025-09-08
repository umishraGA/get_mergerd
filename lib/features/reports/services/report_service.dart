// import '../../../common/constant/endpoints.dart';
// import '../../../utils/dio/api_service.dart';
// import '../models/report_models.dart';
//
// class ReportService {
//   final ApiService _apiService = ApiService();
//
//   /// Get report options/reasons
//   Future<ReportOptionsResponse> getReportOptions() async {
//     return _apiService.get<ReportOptionsResponse>(
//       Endpoints.getReportOptions,
//       parser: (data) => ReportOptionsResponse.fromJson(
//         data as Map<String, dynamic>,
//       ),
//     );
//   }
//
//   /// Submit a report
//   Future<bool> submitReport(CreateReportRequest request) async {
//     return _apiService.post<bool>(
//       Endpoints.createPostPollsStoryReport,
//       data: request.toJson(),
//       parser: (data) => data['success'] == true,
//     );
//   }
// }