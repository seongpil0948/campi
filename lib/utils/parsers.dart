import 'package:flutter/material.dart';

int priceToInt(String price) => int.parse(price.replaceAll(r",", ""));

String rmTagAllPrefix(String s) => s.replaceAll(RegExp("#|@|!"), "");
String rmTagPrefix(String s) => s.replaceFirst(RegExp("#|@|!"), "");

TextStyle? tagTextSty(String tag, BuildContext context) {
  if (tag.startsWith("#")) {
    return Theme.of(context).primaryTextTheme.bodyText2;
  } else if (tag.startsWith("@")) {
    return Theme.of(context).primaryTextTheme.bodyText1;
  } else if (tag.startsWith("!")) {
    return TextStyle(color: Theme.of(context).errorColor);
  }
  return null;
}

List<String> strToTag(List<String> l) {
  List<String> tags = [];
  for (var str in l) {
    for (var pre in ["#", "@", "!"]) {
      tags.add(pre + str);
    }
  }
  return tags;
}
