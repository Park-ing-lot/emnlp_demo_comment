import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:mccounting_text/mccounting_text.dart';

class ModelOutput extends StatefulWidget {
  final double value_;
  final String abusive_score;
  final String sentiment_score;
  final String abusive;
  final String sentiment;
  final bool is_loading;
  const ModelOutput(this.value_, this.abusive, this.abusive_score,
      this.sentiment, this.sentiment_score, this.is_loading,
      {Key? key})
      : super(key: key);

  @override
  _ModelOutputState createState() => _ModelOutputState();
}

class _ModelOutputState extends State<ModelOutput>
    with TickerProviderStateMixin {
  late AnimationController _resizableController;
  @override
  void initState() {
    _resizableController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 1000,
      ),
    );
    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();
    super.initState();
  }

  AnimatedBuilder getContainer(txt, color) {
    return new AnimatedBuilder(
        animation: _resizableController,
        builder: (context, child) {
          return Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.width * 0.04,
            width: MediaQuery.of(context).size.width * 0.12,
            child: Text(
              txt,
              style: TextStyle(
                  color: Colors.grey[850],
                  fontFamily: 'Noto',
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: Border.all(
                  color: color, width: _resizableController.value * 3 + 2),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SfRadialGauge(
            animationDuration: 1000,
            enableLoadingAnimation: true,
            axes: <RadialAxis>[
              RadialAxis(
                  showFirstLabel: true,
                  showLastLabel: true,
                  minimum: 0,
                  maximum: 100,
                  showLabels: false,
                  showTicks: false,
                  radiusFactor: 0.8,
                  axisLineStyle: AxisLineStyle(
                      cornerStyle: CornerStyle.bothCurve,
                      color: Colors.black12,
                      thickness: 20),
                  pointers: <GaugePointer>[
                    RangePointer(
                        enableAnimation: true,
                        value: widget.value_,
                        cornerStyle: CornerStyle.bothCurve,
                        width: 20,
                        sizeUnit: GaugeSizeUnit.logicalPixel,
                        gradient: SweepGradient(
                            colors: widget.value_ > 67
                                ? <Color>[
                                    Colors.greenAccent,
                                    Colors.orangeAccent,
                                    Colors.redAccent,
                                  ]
                                : widget.value_ > 35
                                    ? <Color>[
                                        Colors.greenAccent,
                                        Colors.orangeAccent
                                      ]
                                    : <Color>[
                                        Colors.greenAccent,
                                      ],
                            stops: widget.value_ > 67
                                ? <double>[
                                    0.1,
                                    0.4,
                                    0.5,
                                  ]
                                : widget.value_ > 35
                                    ? <double>[0.25, 0.75]
                                    : <double>[1])),
                    MarkerPointer(
                        enableAnimation: true,
                        value: widget.value_,
                        enableDragging: false,
                        onValueChanged: null,
                        markerHeight: 34,
                        markerWidth: 34,
                        markerType: MarkerType.circle,
                        color: Colors.blueGrey,
                        borderWidth: 2,
                        borderColor: Colors.white54)
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        angle: 90,
                        axisValue: 5,
                        positionFactor: 0.2,
                        widget: Text('${widget.value_}%\n',
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: widget.value_ > 67
                                    ? Colors.red
                                    : widget.value_ > 34
                                        ? Colors.orange
                                        : Colors.green)))
                  ])
            ]),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          alignment: Alignment.topCenter,
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.width * 0.05,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(),
            child: Column(
              children: [
                Text(
                  widget.abusive == '-'
                      ? widget.is_loading
                          ? '잠시만 기다려주세요.'
                          : '입력 대기중...'
                      : widget.value_ > 67
                          ? '이 댓글은 악의성이 있어 삭제될 위험이 있습니다.'
                          : widget.value_ > 34
                              ? '다른 의도로 파악될 수 있는 댓글입니다.'
                              : '악의성이 없는 댓글입니다.',
                  style: TextStyle(
                      color: Colors.grey[850],
                      fontFamily: 'Noto',
                      fontSize: 30,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  widget.abusive == '-'
                      ? widget.is_loading
                          ? 'Wait a moment, please..'
                          : 'Waiting for input...'
                      : widget.value_ > 67
                          ? 'This comment is at risk of being deleted.'
                          : widget.value_ > 34
                              ? 'This comment may have different intentions.'
                              : 'It is fine.',
                  style: TextStyle(
                      color: Colors.grey[850],
                      fontFamily: 'Noto',
                      fontSize: 30,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 10,
          color: Colors.transparent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Abusive',
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontFamily: 'Noto',
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                widget.abusive == '-'
                    ? getContainer(widget.abusive, Colors.black)
                    : widget.abusive == 'Toxic'
                        ? getContainer(widget.abusive, Colors.red)
                        : getContainer(widget.abusive, Colors.green)
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Abusive score',
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontFamily: 'Noto',
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width * 0.04,
                  width: MediaQuery.of(context).size.width * 0.12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 2.5, color: Colors.black.withOpacity(0.75))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      McCountingText(
                        begin: 0.0,
                        end: double.parse(widget.abusive_score).toDouble(),
                        curve: Curves.ease,
                        duration: Duration(milliseconds: 1000),
                        precision: 2,
                        style: TextStyle(
                            color: Colors.grey[850],
                            fontFamily: 'Noto',
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ' %',
                        style: TextStyle(
                            color: Colors.grey[850],
                            fontFamily: 'Noto',
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Sentiment',
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontFamily: 'Noto',
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                widget.sentiment == '-'
                    ? getContainer(widget.sentiment, Colors.black)
                    : widget.sentiment == 'Neg'
                        ? getContainer(widget.sentiment, Colors.red)
                        : widget.sentiment == 'Pos'
                            ? getContainer(widget.sentiment, Colors.green)
                            : getContainer(widget.sentiment, Colors.orange)
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Sentiment score',
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontFamily: 'Noto',
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width * 0.04,
                  width: MediaQuery.of(context).size.width * 0.12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 2.5, color: Colors.black.withOpacity(0.75))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      McCountingText(
                        begin: 0.0,
                        end: double.parse(widget.sentiment_score).toDouble(),
                        curve: Curves.ease,
                        duration: Duration(milliseconds: 1000),
                        precision: 2,
                        style: TextStyle(
                            color: Colors.grey[850],
                            fontFamily: 'Noto',
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ' %',
                        style: TextStyle(
                            color: Colors.grey[850],
                            fontFamily: 'Noto',
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
