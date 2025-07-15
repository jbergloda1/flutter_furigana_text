library;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//==============================================================================
// 1. PUBLIC DATA CLASS
//==============================================================================

/// Represents a single unit of text, which may or may not have furigana.
/// This class is part of the public API.
class FuriganaChar {
  /// The main text character(s), e.g., '漢字'.
  final String text;

  /// The furigana (ruby) text, e.g., 'かんじ'.
  final String? furigana;

  /// Optional data, like a definition, to associate with this character.
  final Object? data;

  /// A flag to control the highlight state of this character.
  bool isHighlighted;

  FuriganaChar({
    required this.text,
    this.furigana,
    this.data,
    this.isHighlighted = false,
  });
}

//==============================================================================
// 2. PUBLIC WIDGET
//==============================================================================

/// A widget that renders Japanese text with furigana, supporting line wrapping
/// and tap events on individual characters.
class FuriganaText extends MultiChildRenderObjectWidget {
  /// A list of [FuriganaChar] objects to be rendered.
  final List<FuriganaChar> spans;

  /// The text style for the main characters.
  final TextStyle style;

  /// The text style for the smaller furigana characters.
  final TextStyle furiganaStyle;

  /// A callback function that is triggered when a text span is tapped.
  /// The index of the tapped span in the `spans` list is provided.
  final Function(int) onSpanTap;

  FuriganaText({
    super.key,
    required this.spans,
    required this.onSpanTap,
    this.style = const TextStyle(
      fontSize: 28.0,
      height: 1.0,
      color: Colors.black,
    ),
    this.furiganaStyle = const TextStyle(
      fontSize: 14.0,
      height: 1.0,
      color: Colors.black87,
    ),
  }) : super(children: _buildChildren(spans, style, furiganaStyle));

  static List<Widget> _buildChildren(
    List<FuriganaChar> spans,
    TextStyle style,
    TextStyle furiganaStyle,
  ) {
    final children = <Widget>[];
    for (final span in spans) {
      children.add(
        Text(
          span.text,
          style: style.copyWith(
            backgroundColor: span.isHighlighted
                ? Colors.yellow.withValues(
                    red: 255,
                    green: 235,
                    blue: 59,
                    alpha: 179,
                  )
                : null,
          ),
        ),
      );
      if (span.furigana != null && span.furigana!.isNotEmpty) {
        children.add(
          Text(
            span.furigana!,
            style: furiganaStyle.copyWith(
              backgroundColor: span.isHighlighted
                  ? Colors.yellow.withValues(
                      red: 255,
                      green: 235,
                      blue: 59,
                      alpha: 179,
                    )
                  : null,
            ),
          ),
        );
      }
    }
    return children;
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderFurigana(onSpanTap: onSpanTap);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderFurigana renderObject,
  ) {
    renderObject.onSpanTap = onSpanTap;
  }
}

//==============================================================================
// 3. RENDERBOX (PRIVATE IMPLEMENTATION)
//==============================================================================

class RenderFurigana extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData> {
  Function(int) onSpanTap;

  RenderFurigana({required this.onSpanTap});

  final List<Rect> _spanBounds = [];

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  void performLayout() {
    if (firstChild == null) {
      size = constraints.smallest;
      return;
    }

    _spanBounds.clear();
    var child = firstChild;
    // ignore: unused_local_variable
    int spanIndex = 0;

    double currentX = 0.0;
    double currentY = 0.0;
    double maxLineHeight = 0.0;
    final double availableWidth = constraints.maxWidth;

    while (child != null) {
      final textChild = child;
      RenderBox? furiganaChild;

      final nextChild = childAfter(textChild);
      if (nextChild != null &&
          (nextChild as RenderParagraph).text.style!.fontSize! <
              (textChild as RenderParagraph).text.style!.fontSize!) {
        furiganaChild = nextChild;
      }

      textChild.layout(constraints, parentUsesSize: true);
      furiganaChild?.layout(constraints, parentUsesSize: true);

      final textWidth = textChild.size.width;
      final furiganaWidth = furiganaChild?.size.width ?? 0.0;
      final spanWidth = textWidth > furiganaWidth ? textWidth : furiganaWidth;

      final textHeight = textChild.size.height;
      final furiganaHeight = furiganaChild?.size.height ?? 0.0;
      final spanHeight = textHeight + furiganaHeight;

      if (currentX + spanWidth > availableWidth && currentX > 0) {
        currentX = 0.0;
        currentY += maxLineHeight;
        maxLineHeight = 0.0;
      }

      if (spanHeight > maxLineHeight) {
        maxLineHeight = spanHeight;
      }

      if (furiganaChild != null) {
        final furiganaParentData =
            furiganaChild.parentData as MultiChildLayoutParentData;
        final furiganaXOffset = (spanWidth - furiganaWidth) / 2;
        furiganaParentData.offset = Offset(
          currentX + furiganaXOffset,
          currentY,
        );
      }

      final textParentData = textChild.parentData as MultiChildLayoutParentData;
      final textXOffset = (spanWidth - textWidth) / 2;
      textParentData.offset = Offset(
        currentX + textXOffset,
        currentY + furiganaHeight,
      );

      _spanBounds.add(Rect.fromLTWH(currentX, currentY, spanWidth, spanHeight));

      currentX += spanWidth;

      child = furiganaChild != null ? childAfter(furiganaChild) : nextChild;
      spanIndex++;
    }

    size = Size(availableWidth, currentY + maxLineHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as MultiChildLayoutParentData;
      context.paintChild(child, childParentData.offset + offset);
      child = childAfter(child);
    }
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, covariant HitTestEntry entry) {
    if (event is PointerDownEvent) {
      for (int i = 0; i < _spanBounds.length; i++) {
        if (_spanBounds[i].contains(event.localPosition)) {
          onSpanTap(i);
          break;
        }
      }
    }
  }
}
