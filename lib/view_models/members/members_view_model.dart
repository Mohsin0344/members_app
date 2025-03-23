import 'package:bloc/bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../api/api_client.dart';
import '../../api/api_methods.dart';
import '../../api/api_routes.dart';
import '../../models/members/members_model.dart';
import '../../models/pagination_request_model.dart';
import '../app_states.dart';
import '../view_model_exception_handler.dart';

class MembersViewModel extends Cubit<AppState>
    with ExceptionHandlingMixin<AppState> {
  MembersViewModel() : super(const InitialState());
  var client = ApiClient();

  getTeamMembers({required PaginationRequest paginationRequest}) async {
    try {
      emit(const LoadingState());
      final model = await client.request<MembersModel>(
        endpoint: ApiRoute.getTeamMembersRoute.path,
        method: ApiMethod.get.value,
        model: MembersModel(),
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
