library mcvgo_pip_view;

import 'package:flutter/cupertino.dart';
import 'package:flutter_learn/presentation/picture_in_picture/pip_view_screen.dart';

class PipView {
  static void featureInit() {}

  static OverlayEntry? _pipModeViewOverlay;
  static GlobalKey<PipViewScreenState>? _globalKey;

  static void showPipScreen(
      {required BuildContext rootContext,
      required Widget screenView,
      required Widget pipModeView}) {
    _pipModeViewOverlay?.remove();

    _globalKey = GlobalKey();

    PipViewScreen pipViewScreen = PipViewScreen(
        key: _globalKey, screenView: screenView, pipModeView: pipModeView);

    _pipModeViewOverlay = OverlayEntry(builder: (context) => pipViewScreen);

    Overlay.of(rootContext)?.insert(_pipModeViewOverlay!);
  }

  static void closePipScreen() {
    _pipModeViewOverlay?.remove();
    _pipModeViewOverlay = null;
  }
  static void changeSizeTapPipMode() {
    // _pipViewScreen.
    _globalKey?.currentState?.changeSizePipMode();
  }

  static void offPipMode() {
    // _pipViewScreen.
    _globalKey?.currentState?.setPipMode(false);
  }

  static void onPipMode() {
    _globalKey?.currentState?.setPipMode(true);
  }
}
