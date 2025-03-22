enum ApiRoute {
  testRoute
}

extension ApiRouteExtension on ApiRoute {
  String get path {
    switch (this) {
      case ApiRoute.testRoute:
        return '/ping';
    }
  }
}
