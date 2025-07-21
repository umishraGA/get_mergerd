import 'package:flutter/material.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/location/LocationSearchPage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../views/search_page.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showDropdown;
  final bool showDivider;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final VoidCallback? onTitleTap;
  final VoidCallback? onWriteReview;
  final VoidCallback? onReportBusiness;
  final bool showMenu;
  final bool showShare;
  final bool showSearch;
  final String shareUrl;
  final String shareText;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showDropdown = false,
    this.showDivider = true,
    this.actions,
    this.onBackPressed,
    this.onTitleTap,
    this.onWriteReview,
    this.onReportBusiness,
    this.showMenu = false,
    this.showShare = true,
    this.showSearch = true,
    this.shareUrl = 'https://happeningbazar.com',
    this.shareText = 'Check out this amazing content on Happening Bazar!',
  });

  Future<void> _shareContent(BuildContext context) async {
    final String shareString = '$shareText\n$shareUrl';

    try {
      // Use share_plus for a more native sharing experience
      await Share.share(
        shareString,
        subject: 'Shared from Happening Bazar',
      );
    } catch (e) {
      // Fallback to URL launching if sharing fails
      try {
        final Uri uri = Uri.parse(
            'mailto:?subject=Shared from Happening Bazar&body=${Uri.encodeComponent(shareString)}');

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          // If email doesn't work, try WhatsApp
          final whatsappUri = Uri.parse(
              'https://api.whatsapp.com/send?text=${Uri.encodeComponent(shareString)}');

          if (await canLaunchUrl(whatsappUri)) {
            await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
          } else {
            // Show error if all methods fail
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not share content')),
              );
            }
          }
        }
      } catch (e) {
        // Handle exceptions from the fallback
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error sharing content: $e')),
          );
        }
      }
    }
  }

  void _navigateToLocationSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LocationSearchPage(
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        // bottom: 8,
      ),
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Back Button
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFBB9F9F)),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFFBB9F9F),
                        size: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Title and Subtitle Section

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (onTitleTap != null) {
                        onTitleTap!();
                      }
                      _navigateToLocationSearch(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                !showMenu ? title : "",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            if (showDropdown)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              subtitle!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF909090),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Action Buttons
                if (actions != null) ...actions!,
                if (actions == null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showSearch)
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 26,
                            minHeight: 26,
                          ),
                          icon: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: showMenu ? 26 : 24,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchPage(),
                              ),
                            );
                          },
                          highlightColor: Colors.transparent,
                          splashColor: Colors.grey.withOpacity(0.1),
                        ),
                      // const SizedBox(width: 8),
                      if (showShare)
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 26,
                            minHeight: 26,
                          ),
                          icon: Icon(
                            Icons.share,
                            color: Colors.black,
                            size: showMenu ? 26 : 24,
                          ),
                          onPressed: () => _shareContent(context),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.grey.withOpacity(0.1),
                        ),
                      // if (showMenu) const SizedBox(width: 8),
                      if (showMenu)
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 26,
                            minHeight: 26,
                          ),
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.black,
                            size: 26,
                          ),
                          offset: const Offset(0, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: Color(0xFFEEEEEE),
                              width: 1.0,
                            ),
                          ),
                          elevation: 4,
                          position: PopupMenuPosition.under,
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem<String>(
                              value: 'write_review',
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              height: 44,
                              onTap: onWriteReview,
                              child: const Text(
                                'Write a review',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'report',
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              height: 44,
                              onTap: onReportBusiness,
                              child: const Text(
                                'Report this Business',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          if (showDivider) const CommonDivider(),
        ],
      ),
    );
  }
}
