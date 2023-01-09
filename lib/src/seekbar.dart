import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_seekbar/src/utils.dart';

/// @author newtab on 2021/5/7

class AdvancedSeekBar extends LeafRenderObjectWidget {
  final int defaultProgress;

  final Color lineColor;
  final Color thumbColor;
  final Color strokeColor;
  final int thumbSize;
  final double strokeWidth;

  final int lineHeight;

  final SeekBarStarted? seekBarStarted;
  final SeekBarProgress? seekBarProgress;
  final SeekBarFinished? seekBarFinished;
  final bool scaleWhileDrag;
  final int percentSplit;
  final int percentSplitWidth;
  final Color percentSplitColor;
  final bool autoJump2Split;
  final bool fillProgress;

  AdvancedSeekBar(
      this.lineColor,
      this.thumbSize,
      this.thumbColor, {
        this.strokeWidth = 0,
        this.strokeColor = Colors.white,
        this.defaultProgress = 0,
        this.lineHeight = 0,
        this.seekBarStarted,
        this.seekBarProgress,
        this.seekBarFinished,
        this.scaleWhileDrag = true,
        this.percentSplit = 0,
        this.percentSplitWidth = 0,
        this.percentSplitColor = Colors.transparent,
        this.autoJump2Split = true,
        this.fillProgress = false,
      });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SeekBarRenderBox(
      this.lineColor,
      this.thumbSize,
      this.thumbColor,
      strokeWidth: this.strokeWidth,
      strokeColor: this.strokeColor,
      defaultProgress: this.defaultProgress,
      lineHeight: this.lineHeight,
      seekBarStarted: this.seekBarStarted,
      seekBarProgress: this.seekBarProgress,
      seekBarFinished: this.seekBarFinished,
      scaleWhileDrag: this.scaleWhileDrag,
      percentSplit: this.percentSplit,
      percentSplitColor: this.percentSplitColor,
      percentSplitWidth: this.percentSplitWidth,
      autoJump2Split: this.autoJump2Split,
      fillProgress: this.fillProgress,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant SeekBarRenderBox renderObject) {
    renderObject.update(
      this.lineColor,
      this.thumbSize,
      this.thumbColor,
      this.defaultProgress,
      this.lineHeight,
      this.seekBarStarted,
      this.seekBarProgress,
      this.seekBarFinished,
      this.scaleWhileDrag,
      this.percentSplit,
      this.percentSplitWidth,
      this.percentSplitColor,
      this.autoJump2Split,
      this.fillProgress,
    );
  }
}

class SeekBarRenderBox extends RenderBox {
  int defaultProgress;

  Color lineColor;
  Color thumbColor;
  Color? strokeColor;
  int thumbSize = 0;
  double strokeWidth = 0;

  int lineHeight;

  SeekBarStarted? seekBarStarted;
  SeekBarProgress? seekBarProgress;
  SeekBarFinished? seekBarFinished;
  bool scaleWhileDrag;
  int percentSplit;
  int percentSplitWidth;
  Color percentSplitColor;
  bool autoJump2Split;
  bool fillProgress;
  SeekBarDragState _seekBarDragState = SeekBarDragState.FINISH;

  double progress = 0; //0 - 1

  late HorizontalDragGestureRecognizer _drag;

  SeekBarRenderBox(
      this.lineColor,
      this.thumbSize,
      this.thumbColor, {
        this.defaultProgress = 0,
        this.strokeWidth = 0,
        this.strokeColor,
        this.lineHeight = 0,
        this.seekBarStarted,
        this.seekBarProgress,
        this.seekBarFinished,
        this.scaleWhileDrag = true,
        this.percentSplit = 0,
        this.percentSplitWidth = 0,
        this.percentSplitColor = Colors.transparent,
        this.autoJump2Split = true,
        this.fillProgress = false,
      }) {
    progress = defaultProgress * 1.0 / 100;
    if (percentSplit > 100) {
      percentSplit = 0;
    }

    _drag = HorizontalDragGestureRecognizer()
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
    final desiredWidth = constraints.maxWidth;
    final desiredHeight = thumbSize.toDouble() * 2;
    final desiredSize = Size(desiredWidth, desiredHeight);
    return constraints.constrain(desiredSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    context.canvas.translate(offset.dx, offset.dy);

    double tempHeight =
    (lineHeight == 0 ? (thumbSize / 2) : lineHeight).toDouble();

    context.canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = tempHeight);

    if (percentSplit > 1) {
      double tempOffset = 0;
      double totalWidth = size.width;
      while (tempOffset <= totalWidth) {
        context.canvas.drawLine(
            Offset(tempOffset, size.height / 2),
            Offset(
                tempOffset == totalWidth
                    ? (tempOffset - percentSplitWidth)
                    : tempOffset + percentSplitWidth,
                size.height / 2),
            Paint()
              ..color = percentSplitColor
              ..style = PaintingStyle.stroke
              ..strokeWidth = tempHeight
              ..strokeCap = StrokeCap.round);
        tempOffset += totalWidth / percentSplit;
      }
    }

    if (fillProgress) {
      context.canvas.drawLine(
          Offset(0, size.height / 2),
          Offset(progress * size.width, size.height / 2),
          Paint()
            ..color = thumbColor
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = tempHeight);
    }

    if (_seekBarDragState == SeekBarDragState.FINISH) {
      context.canvas.drawCircle(
          Offset(progress * size.width, size.height / 2),
          thumbSize / 2,
          Paint()
            ..color = thumbColor
            ..style = PaintingStyle.fill);
      if(strokeWidth!=0)addStroke(context, thumbSize / 2);
    } else {
      context.canvas.drawCircle(
          Offset(progress * size.width, size.height / 2),
          scaleWhileDrag ? thumbSize / 2 * 1.5 : thumbSize / 2,
          Paint()
            ..color = thumbColor
            ..style = PaintingStyle.fill);
      if(strokeWidth!=0)addStroke(context, scaleWhileDrag ? thumbSize / 2 * 1.5 : thumbSize / 2);
    }
    context.canvas.restore();
  }

  void addStroke(PaintingContext context, double thumbSize){
    context.canvas.drawCircle(
        Offset(progress * size.width, size.height / 2),
        thumbSize,
        Paint()
          ..color = Colors.white
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke);

    context.canvas.drawCircle(
        Offset(progress * size.width, size.height / 2),
        (thumbSize) + strokeWidth/2.5,
        Paint()
          ..color = thumbColor
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke);
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
    var dx = localPosition.dx.clamp(0, size.width);
    var tempOffset = dx / size.width;
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
    var dx = localPosition.dx.clamp(0, size.width);
    var tempOffset = dx / size.width;
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
    this.lineHeight = lineHeight;
    this.seekBarStarted = seekBarStarted;
    this.seekBarProgress = seekBarProgress;
    this.seekBarFinished = seekBarFinished;
    this.scaleWhileDrag = scaleWhileDrag;
    this.percentSplitColor = percentSplitColor;
    this.percentSplit = percentSplit;
    this.percentSplitWidth = percentSplitWidth;
    this.autoJump2Split = autoJump2Split;
    this.fillProgress = fillProgress;
    if (percentSplit > 100) {
      percentSplit = 0;
    }
    markNeedsPaint();
  }
}
