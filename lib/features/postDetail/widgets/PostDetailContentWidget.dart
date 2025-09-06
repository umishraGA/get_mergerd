import 'package:flutter/material.dart';

import 'FullScreenImageViewer.dart';
import 'SimpleReadMoreWidget.dart';

class PostDetailContentWidget extends StatefulWidget {
  final String postImage;
  final String profileImage;
  final String description;
  final String location;
  final String username;
  final bool useLightTheme;

  const PostDetailContentWidget({
    super.key,
    required this.postImage,
    required this.profileImage,
    required this.description,
    required this.location,
    required this.username,
    this.useLightTheme = false,
  });

  @override
  State<PostDetailContentWidget> createState() =>
      _PostDetailContentWidgetState();
}

class _PostDetailContentWidgetState extends State<PostDetailContentWidget> {
  void _openFullScreenImage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (BuildContext context, _, __) {
          return FullScreenImageViewer(
            imagePath: widget.postImage,
            onClose: () => Navigator.of(context).pop(),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.1);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.useLightTheme ? Colors.black : Colors.white;
    final backgroundColor = widget.useLightTheme ? Colors.white : Colors.black;
    final errorColor =
        widget.useLightTheme ? Colors.grey.shade200 : Colors.grey.shade800;
    final subtitleColor = widget.useLightTheme
        ? Colors.grey.shade600
        : Colors.white.withOpacity(0.7);
    const accentColor = Color(0xFF426DB3);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post image with tap to zoom
          GestureDetector(
            onTap: () => _openFullScreenImage(context),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Hero(
                  tag: 'image-${widget.postImage}',
                  child: Image.asset(
                    widget.postImage,
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 400,
                        color: errorColor,
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              size: 50, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),

                // Zoom indicator
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.zoom_out_map,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Brand info
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Logo
                Image.asset(
                  widget.profileImage,
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.store, color: Color(0xFFEF3340));
                  },
                ),
                const SizedBox(width: 16),

                // Brand name and location
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'FacebookSans',
                      ),
                    ),
                    Text(
                      widget.location,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 14,
                        fontFamily: 'FacebookSans',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Description with Read more/less button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SimpleReadMoreWidget(
              text: widget.description,
              trimLines: 3,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontFamily: 'FacebookSans',
                height: 1.4,
              ),
              trimCollapsedButtonStyle: const TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'FacebookSans',
              ),
            ),
          ),

          // Add some space at the bottom
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
