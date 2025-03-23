import 'package:bloc/bloc.dart';
import 'package:members_app/data/absence_ical_service.dart';
import 'package:members_app/models/members/absent_members_model.dart';
import '../app_states.dart';
import '../view_model_exception_handler.dart';

class AbsenceCalendarFileViewModel extends Cubit<AppState>
    with ExceptionHandlingMixin<AppState> {
  final AbsenceIcsFileService _absenceIcsFileService;

  AbsenceCalendarFileViewModel(this._absenceIcsFileService) : super(const InitialState());

  generateIcsFile({required List<AbsentMember> absences}) async {
    try {
      emit(const LoadingState());
      var icsFileGenerationResponse = await _absenceIcsFileService.generateIcsFile(
        absences: absences,
      );
      emit(
        SuccessState(
          data: icsFileGenerationResponse,
        ),
      );
    } catch (e) {
      handleException(e);
    }
  }
}
