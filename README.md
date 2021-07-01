# flutter_advanced_seekbar

![](https://raw.githubusercontent.com/jiang111/flutter_advanced_seekbar/master/img/demo.gif)


## install

### Add to pubspec

the latest version is [![pub package](https://img.shields.io/pub/v/flutter_advanced_seekbar.svg)](https://pub.dartlang.org/packages/flutter_advanced_seekbar)

```yaml
dependencies:
  flutter_advanced_seekbar: $latest_version
```

## Usage 
```dart
AdvancedSeekBar(
              Colors.red,
              10,
              Colors.blue,
              lineHeight: 5,
              defaultProgress: 50,
              scaleWhileDrag: true,
              percentSplit: 10,
              percentSplitColor: Colors.green,
              percentSplitWidth: 1,
              seekBarStarted: () {
              },
              seekBarProgress: (v) {
              },
              seekBarFinished: (v) {
              },
            )
```


| 字段 | 注释 | 默认值 | 必填 |
| -- | -- | -- | -- |
| lineColor | 背景条的颜色 |无| 必填 |
| thumbSize | 圆点默认大小 |无 | 必填 |
| thumbColor | 圆点的颜色  |无| 必填 |
| defaultProgress | 原点默认指向 |0|  非必填 |
| lineHeight | 背景条的高度  |thumbSize/2| 非必填 |
| seekBarStarted | 开始seek回调  |无| 必填 |
| seekBarProgress | seek进度回调  |无| 必填 | 
| seekBarFinished | 完成seek回调  |无| 必填 | 
| scaleWhileDrag | 圆点在拖动时是否放大 |true | 必填 | 
| percentSplit | 是否需要拆分进度 参考demo3/4  |false| 必填 | 
| percentSplitWidth | 拆分条的宽度 输入值最小为2  |0| 必填 | 
| percentSplitColor | 拆分条的颜色  |无| 必填 | 
| autoJump2Split | 如果拆分 seek后是否必须到拆分点上 参考demo4 |true| 必填 | 
| fillProgress | 完成的进度是否标记为thumb的颜色 参考demo1 |false| | 必填 | 


