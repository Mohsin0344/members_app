import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_models/test_view_model.dart';


class BlocProviders {
  static final List<BlocProvider> providers = [
    BlocProvider<TestViewModel>(
      create: (context) => TestViewModel(),
    ),
  ];
}
