import 'package:bloc/bloc.dart';
import '../../api/api_client.dart';
import '../../api/api_methods.dart';
import '../../api/api_routes.dart';
import '../models/test_model.dart';
import 'app_states.dart';
import 'view_model_exception_handler.dart';

class TestViewModel extends Cubit<AppState>
    with ExceptionHandlingMixin<AppState> {
  TestViewModel() : super(const InitialState());
  var client = ApiClient();
  
  getFeed() async {
    try {
      emit(const LoadingState());
      final model = await client.request<TestModel>(
          endpoint: ApiRoute.testRoute.path,
          method: ApiMethod.get.value,
          model: TestModel(),
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
