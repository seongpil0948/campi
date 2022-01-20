import 'package:campi/views/router/config.dart';
import 'package:flutter/material.dart';

class PiRouteParser extends RouteInformationParser<PiPageConfig> {
  @override
  Future<PiPageConfig> parseRouteInformation(
      RouteInformation routeInformation) async {
    return PiPageConfig(
        path: routeInformation.location ?? "", state: routeInformation.state);
  }
}
