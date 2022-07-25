import 'package:flutter/material.dart';

class PipViewScreen extends StatefulWidget {
  final Widget screenView;
  final Widget pipModeView;

  const PipViewScreen(
      {Key? key, required this.screenView, required this.pipModeView})
      : super(key: key);

  @override
  State<PipViewScreen> createState() => PipViewScreenState();
}

class PipViewScreenState extends State<PipViewScreen>
    with TickerProviderStateMixin {
  bool isPipMode = false;

  bool isChangeSizePipMode = false;
  double width = 0;
  double height = 0;

  void setPipMode(bool pIsPipMode) {
    setState(() {
      isPipMode = pIsPipMode;
    });
  }

  void changeSizePipMode() {
    if (isChangeSizePipMode) {
      return;
    }
    if (_scale == _minScale) {
      setState(() {
        _scale = 1.3;
        isChangeSizePipMode = true;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      width = MediaQuery.of(context).size.width;
      height = MediaQuery.of(context).size.height;
      _offset = Offset(width * 0.54 / 3, height - width * 0.56 * .56 - 100);
      _offsetPIP = _offset;
      _maxScale = (width - 24) / (.56 * width);
    });

    super.initState();
  }

  Offset _offset = Offset.zero;

  Offset _offsetPIP = Offset.zero;

  Offset _initialFocalPoint = Offset.zero;
  Offset _sessionOffset = Offset.zero;

  double _scale = 1.0;
  double _initialScale = 1;

  double _maxScale = 1 / 0.56;

  final double _minScale = 1;

  @override
  void didUpdateWidget(covariant PipViewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return SizedBox(
        child: isPipMode
            ? Center(
                child: Transform.translate(
                  offset: _offsetPIP + _sessionOffset,
                  child: Transform.scale(
                    scale: _scale,
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        GestureDetector(
                            onScaleStart: (details) {
                              _initialFocalPoint = details.focalPoint;
                              _initialScale = _scale;
                            },
                            onScaleUpdate: (details) {
                              double autoScale = _initialScale * details.scale;
                              setState(() {
                                _sessionOffset =
                                    (details.focalPoint - _initialFocalPoint);
                                if (autoScale <= _maxScale &&
                                    autoScale >= _minScale) {
                                  _scale = autoScale;
                                }
                              });
                            },
                            onScaleEnd: (details) {
                              setState(() {
                                _offset += _sessionOffset;
                                _sessionOffset = Offset.zero;
                                Offset updateOffset = _offset;
                                _offsetPIP = Offset(
                                    updateOffset.dx < -12
                                        ? -width / 2 +
                                            12 +
                                            (width * 0.56 * _scale) / 2
                                        : updateOffset.dx +
                                                    (width * 0.56 * _scale) /
                                                        2 >=
                                                12
                                            ? width / 2 -
                                                12 -
                                                (width * 0.56 * _scale) / 2
                                            : updateOffset.dx,
                                    updateOffset.dy);
                              });
                            },
                            child: widget.pipModeView),
                      ],
                    ),
                  ),
                ),
              )
            : widget.screenView);

    // return AnimatedPositioned(
    //     left: isPipMode ? pipViewOffset.dx : 0,
    //     top: isPipMode ? pipViewOffset.dy : 0,
    //     child: Draggable(
    //       feedback: const SizedBox.shrink(),
    //       child: AnimatedSize(
    //         alignment: Alignment.center,
    //         curve: Curves.easeInOutCubicEmphasized,
    //         duration: const Duration(
    //           milliseconds: 500,
    //         ),
    //         child: isPipMode
    //             ? ClipRRect(
    //                 borderRadius: BorderRadius.circular(12),
    //                 child: GestureDetector(
    //                   // onScaleStart: (details) {
    //                   //   _initialFocalPoint = details.focalPoint;
    //                   //   _initialScale = _scale;
    //                   // },
    //                   // onScaleUpdate: (details) {
    //                   //   setState(() {
    //                   //     _sessionOffset =
    //                   //         details.focalPoint - _initialFocalPoint;
    //                   //     _scale = _initialScale * details.scale;
    //                   //   });
    //                   // },
    //                   // onScaleEnd: (details) {
    //                   //   setState(() {
    //                   //     _offset += _sessionOffset;
    //                   //     _sessionOffset = Offset.zero;
    //                   //   });
    //                   // },
    //                   onPanUpdate: (dragDetail) {
    //                     Offset offset = dragDetail.delta;
    //                     double widethVideoRe =
    //                         widthVideo + offset.dy + offset.dx;
    //                     if (widethVideoRe < width &&
    //                         widethVideoRe > width * 0.56) {
    //                       setState(() {
    //                         widthVideo = widethVideoRe;
    //                         heightVideo = (widthVideo * 0.56);
    //                       });
    //                     }
    //                   },
    //                   child: AnimatedContainer(
    //                     width: widthVideo,
    //                     height: heightVideo,
    //                     alignment: Alignment.center,
    //                     duration: const Duration(
    //                       milliseconds: 100,
    //                     ),
    //                     child: widget.pipModeView,
    //                   ),
    //                 ))
    //             : AnimatedContainer(
    //                 width: width,
    //                 height: height,
    //                 duration: const Duration(
    //                   milliseconds: 200,
    //                 ),
    //                 child: widget.screenView),
    //       ),
    //       onDragUpdate: (dragDetail) {
    //         Offset offset = dragDetail.globalPosition;
    //         double xPlus = 0;
    //         double yPlus = 0;
    //         offset = Offset(
    //             offset.dx - (widthVideo / 2), offset.dy - (heightVideo / 2));
    //         if ((offset.dx + widthVideo) > width) {
    //           xPlus = offset.dx + widthVideo - width + 2;
    //         }
    //         if ((offset.dy + heightVideo) > height) {
    //           yPlus = offset.dy + heightVideo - height + 10;
    //         }

    //         if (offset.dx < 0) {
    //           offset = Offset(2, offset.dy);
    //         }
    //         if (offset.dy < 0) {
    //           offset = Offset(offset.dx, 10);
    //         }

    //         setState(() {
    //           pipViewOffset = offset - Offset(xPlus, yPlus);
    //         });
    //       },
    //     ),
    //     duration: const Duration(milliseconds: 10));
  }
}




// class ZoomAndPanDemo extends StatefulWidget {
//   @override
//   _ZoomAndPanDemoState createState() => _ZoomAndPanDemoState();
// }

// class _ZoomAndPanDemoState extends State<ZoomAndPanDemo> {
//   Offset _offset = Offset.zero;
//   Offset _initialFocalPoint = Offset.zero;
//   Offset _sessionOffset = Offset.zero;

//   double _scale = 1.0;
//   double _initialScale = 1.0;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onScaleStart: (details) {
//         _initialFocalPoint = details.focalPoint;
//         _initialScale = _scale;
//       },
//       onScaleUpdate: (details) {
//         setState(() {
//           _sessionOffset = details.focalPoint - _initialFocalPoint;
//           _scale = _initialScale * details.scale;
//         });
//       },
//       onScaleEnd: (details) {
//         setState(() {
//           _offset += _sessionOffset;
//           _sessionOffset = Offset.zero;
//         });
//       },
//       child: Transform.translate(
//         offset: _offset + _sessionOffset,
//         child: Transform.scale(
//           scale: _scale,
//           child: FlutterLogo(),
//         ),
//       ),
//     );
//   }
// }