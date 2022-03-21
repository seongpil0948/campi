part of './index.dart';

const apiUrl = "https://campi-f8278.du.r.appspot.com/api";
const multiPushUrl = "$apiUrl/fcm/push";

const entryPostType = PostType.mgz;
const defaultPostOrder = PostOrder.latest;
const defaultPostOrderStr = "최신순";

const prefFeedOrderKey = "feedOrder";
const prefMgzOrderKey = "mgzOrder";

/// Widgets
const errorIndicator = Center(child: Text("Has EEEEEERRRROR"));
const loadingIndicator = Center(child: CircularProgressIndicator.adaptive());
