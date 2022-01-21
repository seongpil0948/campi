import 'package:flutter/material.dart';

int priceToInt(String price) => int.parse(price.replaceAll(r",", ""));

TextStyle? tagTextSty(String tag, BuildContext context) {
  return tag.startsWith("#")
      ? Theme.of(context).primaryTextTheme.bodyText2
      : tag.startsWith("@")
          ? Theme.of(context).primaryTextTheme.bodyText1
          : TextStyle(color: Theme.of(context).errorColor);
}
