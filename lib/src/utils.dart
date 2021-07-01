/// @author newtab on 2021/5/7
enum SeekBarDragState {
  START,
  PROGRESS,
  FINISH,
}

typedef SeekBarProgress = void Function(int progress);
typedef SeekBarStarted = void Function();
typedef SeekBarFinished = void Function(int progress);
