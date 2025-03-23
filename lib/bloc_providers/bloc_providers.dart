import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:members_app/data/absence_ical_service.dart';

import '../view_models/absences/absence_types_view_model.dart';
import '../view_models/absences/absences_ical_view_model.dart';
import '../view_models/members/absent_members_view_model.dart';
import '../view_models/members/members_view_model.dart';
import '../view_models/test_view_model.dart';

class BlocProviders {
  static final List<BlocProvider> providers = [
    BlocProvider<TestViewModel>(
      create: (context) => TestViewModel(),
    ),
    BlocProvider<MembersViewModel>(
      create: (context) => MembersViewModel(),
    ),
    BlocProvider<AbsentMembersViewModel>(
      create: (context) => AbsentMembersViewModel(),
    ),
    BlocProvider<AbsenceTypesViewModel>(
      create: (context) => AbsenceTypesViewModel(),
    ),
    BlocProvider<AbsencesIcalViewModel>(
      create: (context) => AbsencesIcalViewModel(
        AbsenceIcalServiceRepository(),
      ),
    ),
  ];
}
