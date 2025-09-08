import 'package:flutter/material.dart';
import '../models/report_models.dart';
import '../services/report_service.dart';

class ReportController extends ChangeNotifier {
  final ReportService _reportService = ReportService();
  
  bool _isLoading = false;
  List<ReportOption> _reportOptions = [];
  bool _isSubmittingReport = false;

  bool get isLoading => _isLoading;
  List<ReportOption> get reportOptions => _reportOptions;
  bool get isSubmittingReport => _isSubmittingReport;

  /// Load report options from API
  Future<void> loadReportOptions() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final response = await _reportService.getReportOptions();
      
      if (response.success) {
        _reportOptions = response.data;
      } else {
        // Handle error - could use a callback or error state
        debugPrint('Failed to load report options: ${response.message}');
      }
    } catch (e) {
      debugPrint('Failed to load report options: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Submit a report
  Future<bool> submitReport({
    required String reportId,
    required String postId,
    required ReportModel reportModel,
  }) async {
    try {
      _isSubmittingReport = true;
      notifyListeners();
      
      final request = CreateReportRequest(
        reportId: reportId,
        postId: postId,
        reportModel: reportModel,
      );
      
      final success = await _reportService.submitReport(request);
      
      if (success) {
        debugPrint('Report submitted successfully');
        return true;
      } else {
        debugPrint('Failed to submit report');
        return false;
      }
    } catch (e) {
      debugPrint('Failed to submit report: ${e.toString()}');
      return false;
    } finally {
      _isSubmittingReport = false;
      notifyListeners();
    }
  }

  /// Initialize the controller and load report options
  void initialize() {
    loadReportOptions();
  }
}