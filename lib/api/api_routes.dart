enum ApiRoute {
  testRoute,
  getTeamMembersRoute,
  getAbsentMembersRoute,
  getAbsenceTypes
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
      case ApiRoute.getAbsenceTypes:
        return '/absences/types';
    }
  }
}
