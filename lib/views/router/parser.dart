import 'package:campi/views/router/config.dart';
import 'package:flutter/material.dart';

class PiRouteParser extends RouteInformationParser<PiPageConfig> {
  @override
  Future<PiPageConfig> parseRouteInformation(
      RouteInformation routeInformation) async {
    final String path = routeInformation.location ?? '';
    return PiPageConfig(location: path);
  }
}
