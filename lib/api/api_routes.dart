enum ApiRoute {
  testRoute,
  getTeamMembersRoute
}

extension ApiRouteExtension on ApiRoute {
  String get path {
    switch (this) {
      case ApiRoute.testRoute:
        return '/ping';
      case ApiRoute.getTeamMembersRoute:
        return '/members';
    }
  }
}
