import 'package:bloc/bloc.dart';
import 'package:members_app/models/absences/absence_types-model.dart';
import '../../api/api_client.dart';
import '../../api/api_methods.dart';
import '../../api/api_routes.dart';
import '../app_states.dart';
import '../view_model_exception_handler.dart';

class AbsenceTypesViewModel extends Cubit<AppState>
    with ExceptionHandlingMixin<AppState> {
  AbsenceTypesViewModel() : super(const InitialState());
  var client = ApiClient();
  String selectedType = 'All';

  getAbsenceTypes() async {
    try {
      emit(const LoadingState());
      final model = await client.request<AbsenceTypesModel>(
        endpoint: ApiRoute.getAbsenceTypes.path,
        method: ApiMethod.get.value,
        model: AbsenceTypesModel(),
      );
      emit(
        SuccessState(
          data: model,
        ),
      );
    } catch (e) {
      handleException(e);
    }
  }
}
