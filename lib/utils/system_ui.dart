part of './index.dart';

enum StatusBarTo { transparent, restore, ignore }

void handleStatusBar({StatusBarTo to = StatusBarTo.ignore}) {
  switch (to) {
    case StatusBarTo.transparent:
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ));
      break;
    case StatusBarTo.restore:
      SystemChrome.restoreSystemUIOverlays();
      break;
    case StatusBarTo.ignore:
      break;
  }
}
