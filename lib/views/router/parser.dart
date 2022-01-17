import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
import 'path.dart';

/// 현재 루트정보를 받아, PyPathConfig 로서 파싱 및 반환한다.
class PiPathParser extends RouteInformationParser<PiPathConfig> {
  @override
  Future<PiPathConfig> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    if (uri.pathSegments.isEmpty) return unknownPathConfig;
    final path = uri.pathSegments[0];
    switch (path) {
      case rootPath:
        return defaultPage;
      case postListPath:
        if (uri.pathSegments.length == 2) {
          throw UnimplementedError();
        }
        // return PiPathConfig.feedDetail(feedId: uri.pathSegments[1]);
        return postListPathConfig;
      case storePath:
        if (uri.pathSegments.length == 2) {
          return PiPathConfig.productDetail(productId: uri.pathSegments[1]);
        }
        return storePathConfig;
      default:
        return unknownPathConfig;
    }
  }

  /// 역으로 현재 argument 데이터 타입이 어떤 루트와 매핑되는지 정의한다.
  @override
  RouteInformation restoreRouteInformation(PiPathConfig configuration) {
    return RouteInformation(location: configuration.path);
  }
}
