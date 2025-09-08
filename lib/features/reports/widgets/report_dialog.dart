import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/report_controller.dart';
import '../models/report_models.dart';

class ReportDialog extends StatelessWidget {
  final String postId;
  final ReportModel reportModel;
  final String contentType; // "post", "poll", or "story"
  /// Callback when post is reported and should be removed
  final Function(String)? onPostReported;

  const ReportDialog({
    super.key,
    required this.postId,
    required this.reportModel,
    required this.contentType,
    this.onPostReported,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportController>(
      builder: (context, controller, child) {
        // Initialize controller if needed
        if (controller.reportOptions.isEmpty && !controller.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.initialize();
          });
        }

        return _buildDialog(context, controller);
      },
    );
  }

  Widget _buildDialog(BuildContext context, ReportController controller) {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.flag_outlined,
                  color: Colors.red[600],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Report this $contentType',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Please select a reason for reporting this $contentType:',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Report options list
            if (controller.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (controller.reportOptions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No report options available',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              )
            else
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Column(
                    children: controller.reportOptions.map((option) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => _onReportOptionSelected(
                              context,
                              controller,
                              option,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.report_outlined,
                                    size: 20,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      option.message,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey[400],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            
            const SizedBox(height: 20),
            
            // Cancel button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onReportOptionSelected(
    BuildContext context,
    ReportController controller,
    ReportOption option,
  ) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Report'),
        content: Text(
          'Are you sure you want to report this $contentType for "${option.message}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Consumer<ReportController>(
            builder: (context, reportController, child) => TextButton(
              onPressed: reportController.isSubmittingReport
                  ? null
                  : () => _submitReport(context, reportController, option),
              child: reportController.isSubmittingReport
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Report',
                      style: TextStyle(color: Colors.red),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitReport(
    BuildContext context,
    ReportController controller,
    ReportOption option,
  ) async {
    final success = await controller.submitReport(
      reportId: option.id,
      postId: postId,
      reportModel: reportModel,
    );
    
    if (success && context.mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Call the callback to hide/remove the post from UI
      onPostReported?.call(postId);
      
      // Close both dialogs
      Navigator.of(context).pop(); // Close confirmation dialog
      Navigator.of(context).pop(); // Close report dialog
    } else if (!success && context.mounted) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit report'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

/// Helper function to show the report dialog
void showReportDialog({
  required BuildContext context,
  required String postId,
  required ReportModel reportModel,
  required String contentType,
  Function(String)? onPostReported,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => ReportDialog(
      postId: postId,
      reportModel: reportModel,
      contentType: contentType,
      onPostReported: onPostReported,
    ),
  );
}