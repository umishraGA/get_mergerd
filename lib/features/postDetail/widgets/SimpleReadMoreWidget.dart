import 'package:flutter/material.dart';

class SimpleReadMoreWidget extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int trimLines;
  final TextStyle? trimExpandedButtonStyle;
  final TextStyle? trimCollapsedButtonStyle;

  const SimpleReadMoreWidget({
    super.key,
    required this.text,
    this.style,
    this.trimLines = 3,
    this.trimExpandedButtonStyle,
    this.trimCollapsedButtonStyle,
  });

  @override
  State<SimpleReadMoreWidget> createState() => _SimpleReadMoreWidgetState();
}

class _SimpleReadMoreWidgetState extends State<SimpleReadMoreWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle = widget.style ?? defaultTextStyle.style;
    final TextStyle linkStyle = widget.trimCollapsedButtonStyle ??
        effectiveTextStyle.copyWith(
          color: const Color(0xFFEF3340),
          fontWeight: FontWeight.bold,
        );

    final String displayText = widget.text;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        // Create a TextSpan with the data
        final text = TextSpan(
          text: displayText,
          style: effectiveTextStyle,
        );

        // Layout and measure text
        final TextPainter textPainter = TextPainter(
          text: text,
          textDirection: TextDirection.ltr,
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(maxWidth: maxWidth);

        // Check if the text overflows and requires "more" button
        final bool hasOverflow = textPainter.didExceedMaxLines;

        if (hasOverflow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                displayText,
                style: effectiveTextStyle,
                maxLines: _isExpanded ? null : widget.trimLines,
                overflow:
                    _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _isExpanded ? 'less' : 'more',
                    style: linkStyle,
                  ),
                ),
              ),
            ],
          );
        } else {
          return Text(
            displayText,
            style: effectiveTextStyle,
          );
        }
      },
    );
  }
}
