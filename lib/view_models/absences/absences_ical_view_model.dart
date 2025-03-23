import 'package:bloc/bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:members_app/data/absence_ical_service.dart';
import 'package:members_app/models/absences/absence_types-model.dart';
import 'package:members_app/models/members/absent_members_model.dart';
import '../../api/api_client.dart';
import '../../api/api_methods.dart';
import '../../api/api_routes.dart';
import '../app_states.dart';
import '../view_model_exception_handler.dart';

class AbsencesIcalViewModel extends Cubit<AppState>
    with ExceptionHandlingMixin<AppState> {
  final AbsenceIcalService _absenceIcalService;

  AbsencesIcalViewModel(this._absenceIcalService) : super(const InitialState());

  generateIcalFile({required List<AbsentMember> absences}) async {
    try {
      emit(const LoadingState());
      var absenceIcalServiceResponse = await _absenceIcalService.generateICalFile(
        absences: absences,
      );
      emit(
        SuccessState(
          data: absenceIcalServiceResponse,
        ),
      );
    } catch (e) {
      handleException(e);
    }
  }
}
