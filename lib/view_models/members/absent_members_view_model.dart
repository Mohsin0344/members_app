import 'package:bloc/bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:members_app/models/members/absent_members_model.dart';
import '../../api/api_client.dart';
import '../../api/api_methods.dart';
import '../../api/api_routes.dart';
import '../../models/pagination_request_model.dart';
import '../app_states.dart';
import '../view_model_exception_handler.dart';

class AbsentMembersViewModel extends Cubit<AppState>
    with ExceptionHandlingMixin<AppState> {
  AbsentMembersViewModel() : super(const InitialState());
  var client = ApiClient();

  getAbsentMembers({required PaginationRequest paginationRequest}) async {
    try {
      emit(const LoadingState());
      final model = await client.request<AbsentMembersModel>(
        endpoint: ApiRoute.getAbsentMembersRoute.path,
        method: ApiMethod.get.value,
        model: AbsentMembersModel(),
        queryParams: paginationRequest.toJson(),
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
