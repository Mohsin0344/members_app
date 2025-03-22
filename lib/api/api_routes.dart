enum ApiRoute {
  testRoute,
  getTeamMembersRoute,
  getAbsentMembersRoute,
}

extension ApiRouteExtension on ApiRoute {
  String get path {
    switch (this) {
      case ApiRoute.testRoute:
        return '/ping';
      case ApiRoute.getTeamMembersRoute:
        return '/members';
      case ApiRoute.getAbsentMembersRoute:
        return '/absences';
    }
  }
}
