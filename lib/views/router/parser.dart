part of './index.dart';

class PiRouteParser extends RouteInformationParser<PiPageConfig> {
  @override
  Future<PiPageConfig> parseRouteInformation(
      RouteInformation routeInformation) async {
    final String path = routeInformation.location ?? '';
    return PiPageConfig(location: path);
  }
}
