import 'package:campi/modules/posts/repo.dart';
import 'package:campi/modules/posts/state.dart';
import 'package:flutter/material.dart';

const entryPostType = PostType.mgz;
const defaultPostOrder = PostOrder.latest;
const defaultPostOrderStr = "최신순";

const prefFeedOrderKey = "feedOrder";
const prefMgzOrderKey = "mgzOrder";

/// Widgets
const errorIndicator = Center(child: Text("Has EEEEEERRRROR"));
const loadingIndicator = Center(child: CircularProgressIndicator.adaptive());
