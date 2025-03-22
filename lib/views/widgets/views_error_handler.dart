import 'package:flutter/material.dart';

import '../../utils/app_strings.dart';
import '../../view_models/app_states.dart';
import 'app_snack_bar.dart';

errorHandler({required BuildContext context, required AppState state}) {
  if (state is TimeoutState) {
    showCustomSnackBar(
      context,
      AppStrings.timeoutError,
    );
  } else if (state is InternetErrorState) {
    showCustomSnackBar(
      context,
      AppStrings.internetError,
    );
  } else if (state is ApiErrorState) {
    showCustomSnackBar(
      context,
      state.error.toString(),
    );
  } else if (state is UnknownErrorState) {
    showCustomSnackBar(
      context,
      state.error.toString(),
    );
  }
}
