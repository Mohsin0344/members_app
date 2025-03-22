import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api_client.dart';
import 'app_states.dart';

mixin ExceptionHandlingMixin<S> on Cubit<S> {
  void handleException(Object e, {String? callBackUrl,}) {
    log(e.toString());
    if (e is ApiException) {
      emit(ApiErrorState(error: e.message) as S);
    } else if (e is TimeoutException) {
      emit(const TimeoutState() as S);
    } else if (e is InternetException) {
      emit(const InternetErrorState() as S);
    } else if (e is VersionException) {
      emit(const VersionErrorState() as S);
    } else {
      emit(UnknownErrorState(error: e.toString()) as S);
    }
  }
}
