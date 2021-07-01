import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_seekbar/src/utils.dart';

/// @author newtab on 2021/5/7

class AdvancedVerticalSeekBar extends LeafRenderObjectWidget {
  final int defaultProgress;

  final Color lineColor;
  final Color thumbColor;
  final int thumbSize;

  final int lineWidth;

  final SeekBarStarted? seekBarStarted;
  final SeekBarProgress? seekBarProgress;
  final SeekBarFinished? seekBarFinished;
  final bool scaleWhileDrag;
  final int percentSplit;
  final int percentSplitHeight;
  final Color percentSplitColor;
  final bool autoJump2Split;
  final bool fillProgress;

  AdvancedVerticalSeekBar(
    this.lineColor,
    this.thumbSize,
    this.thumbColor, {
    this.defaultProgress = 0,
    this.lineWidth = 0,
    this.seekBarStarted,
    this.seekBarProgress,
    this.seekBarFinished,
    this.scaleWhileDrag = true,
    this.percentSplit = 0,
    this.percentSplitHeight = 0,
    this.percentSplitColor = Colors.transparent,
    this.autoJump2Split = true,
    this.fillProgress = false,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return VerticalSeekBarRenderBox(
      this.lineColor,
      this.thumbSize,
      this.thumbColor,
      defaultProgress: this.defaultProgress,
      lineWidth: this.lineWidth,
      seekBarStarted: this.seekBarStarted,
      seekBarProgress: this.seekBarProgress,
      seekBarFinished: this.seekBarFinished,
      scaleWhileDrag: this.scaleWhileDrag,
      percentSplit: this.percentSplit,
      percentSplitColor: this.percentSplitColor,
      percentSplitHeight: this.percentSplitHeight,
      autoJump2Split: this.autoJump2Split,
      fillProgress: this.fillProgress,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant VerticalSeekBarRenderBox renderObject) {
    renderObject.update(
      this.lineColor,
      this.thumbSize,
      this.thumbColor,
      this.defaultProgress,
      this.lineWidth,
      this.seekBarStarted,
      this.seekBarProgress,
      this.seekBarFinished,
      this.scaleWhileDrag,
      this.percentSplit,
      this.percentSplitHeight,
      this.percentSplitColor,
      this.autoJump2Split,
      this.fillProgress,
    );
  }
}

class VerticalSeekBarRenderBox extends RenderBox {
  int defaultProgress;

  Color lineColor;
  Color thumbColor;
  int thumbSize = 0;

  int lineWidth;

  SeekBarStarted? seekBarStarted;
  SeekBarProgress? seekBarProgress;
  SeekBarFinished? seekBarFinished;
  bool scaleWhileDrag;
  int percentSplit;
  int percentSplitHeight;
  Color percentSplitColor;
  bool autoJump2Split;
  bool fillProgress;
  SeekBarDragState _seekBarDragState = SeekBarDragState.FINISH;

  double progress = 0; //0 - 1

  late VerticalDragGestureRecognizer _drag;

  VerticalSeekBarRenderBox(
    this.lineColor,
    this.thumbSize,
    this.thumbColor, {
    this.defaultProgress = 0,
    this.lineWidth = 0,
    this.seekBarStarted,
    this.seekBarProgress,
    this.seekBarFinished,
    this.scaleWhileDrag = true,
    this.percentSplit = 0,
    this.percentSplitHeight = 0,
    this.percentSplitColor = Colors.transparent,
    this.autoJump2Split = true,
    this.fillProgress = false,
  }) {
    progress = defaultProgress * 1.0 / 100;
    if (percentSplit > 100) {
      percentSplit = 0;
    }

    _drag = VerticalDragGestureRecognizer()
      ..onStart = (DragStartDetails details) {
        _startDragThumbPosition(details.localPosition);
      }
      ..onUpdate = (DragUpdateDetails details) {
        _updateDragThumbPosition(details.localPosition);
      }
      ..onCancel = () {
        _finishDragThumbPosition();
      }
      ..onEnd = (_) {
        _finishDragThumbPosition();
      };
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final desiredHeight = constraints.maxHeight;
    final desiredWidth = thumbSize.toDouble() * 2;
    final desiredSize = Size(desiredWidth, desiredHeight);
    return constraints.constrain(desiredSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    context.canvas.translate(offset.dx, offset.dy);

    double tempWidth =
        (lineWidth == 0 ? (thumbSize / 2) : lineWidth).toDouble();

    context.canvas.drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = tempWidth);

    if (percentSplit > 1) {
      double tempOffset = 0;
      double totalHeight = size.height;
      while (tempOffset <= totalHeight) {
        context.canvas.drawLine(
            Offset(size.width / 2, tempOffset),
            Offset(
                size.width / 2,
                tempOffset == totalHeight
                    ? (tempOffset - percentSplitHeight)
                    : tempOffset + percentSplitHeight),
            Paint()
              ..color = percentSplitColor
              ..style = PaintingStyle.stroke
              ..strokeWidth = tempWidth
              ..strokeCap = StrokeCap.round);
        tempOffset += totalHeight / percentSplit;
      }
    }

    if (fillProgress) {
      context.canvas.drawLine(
          Offset(size.width / 2, 0),
          Offset(size.width / 2, progress * size.height),
          Paint()
            ..color = thumbColor
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = tempWidth);
    }

    if (_seekBarDragState == SeekBarDragState.FINISH) {
      context.canvas.drawCircle(
          Offset(size.width / 2, progress * size.height),
          thumbSize / 2,
          Paint()
            ..color = thumbColor
            ..style = PaintingStyle.fill);
    } else {
      context.canvas.drawCircle(
          Offset(size.width / 2, progress * size.height),
          scaleWhileDrag ? thumbSize / 2 * 1.5 : thumbSize / 2,
          Paint()
            ..color = thumbColor
            ..style = PaintingStyle.fill);
    }
    context.canvas.restore();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent) {
      _drag.addPointer(event);
    }
  }

  void _startDragThumbPosition(Offset localPosition) {
    var dx = localPosition.dy.clamp(0, size.height);
    var tempOffset = dx / size.height;
    _seekBarDragState = SeekBarDragState.START;
    progress = tempOffset;
    if (seekBarStarted != null) {
      seekBarStarted!();
    }

    if (seekBarProgress != null) {
      seekBarProgress!(getShownProgress());
    }
    markNeedsPaint();
  }

  void _updateDragThumbPosition(Offset localPosition) {
    var dx = localPosition.dy.clamp(0, size.height);
    var tempOffset = dx / size.height;
    progress = tempOffset;
    _seekBarDragState = SeekBarDragState.PROGRESS;
    if (seekBarProgress != null) {
      seekBarProgress!(getShownProgress());
    }
    markNeedsPaint();
  }

  void _finishDragThumbPosition() {
    _seekBarDragState = SeekBarDragState.FINISH;

    if (percentSplit > 1 && autoJump2Split) {
      int temp = (progress * 100).round();
      double offset = temp % (100 / percentSplit);

      int result = 0;

      var left = 100 / percentSplit - offset;

      if (left < (100 / percentSplit) / 2) {
        result = (temp + left).toInt();
      } else {
        result = (temp - offset).toInt();
      }
      progress = result * 1.0 / 100;
    }
    if (seekBarFinished != null) {
      seekBarFinished!(getShownProgress());
    }
    markNeedsPaint();
  }

  int getShownProgress() {
    return (progress * 100).round();
  }

  void update(
    Color lineColor,
    int thumbSize,
    Color thumbColor,
    int defaultProgress,
    int lineHeight,
    SeekBarStarted? seekBarStarted,
    SeekBarProgress? seekBarProgress,
    SeekBarFinished? seekBarFinished,
    bool scaleWhileDrag,
    int percentSplit,
    int percentSplitWidth,
    Color percentSplitColor,
    bool autoJump2Split,
    bool fillProgress,
  ) {
    this.lineColor = lineColor;
    this.thumbSize = thumbSize;
    this.thumbColor = thumbColor;
    this.defaultProgress = defaultProgress;
    this.lineWidth = lineHeight;
    this.seekBarStarted = seekBarStarted;
    this.seekBarProgress = seekBarProgress;
    this.seekBarFinished = seekBarFinished;
    this.scaleWhileDrag = scaleWhileDrag;
    this.percentSplitColor = percentSplitColor;
    this.percentSplit = percentSplit;
    this.percentSplitHeight = percentSplitWidth;
    this.autoJump2Split = autoJump2Split;
    this.fillProgress = fillProgress;
    if (percentSplit > 100) {
      percentSplit = 0;
    }
    markNeedsPaint();
  }
}
