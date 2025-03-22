import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:members_app/api/api_client.dart';
import 'package:members_app/view_models/absences/absence_types_view_model.dart';
import 'package:members_app/view_models/app_states.dart';
import 'package:mockito/mockito.dart';
import 'package:members_app/models/absences/absence_types-model.dart';

import '../mock_api_client.mocks.dart';

void main() {
  late AbsenceTypesViewModel absenceTypesViewModel;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    absenceTypesViewModel = AbsenceTypesViewModel();
    absenceTypesViewModel.client = mockApiClient;
  });

  group('AbsenceTypesViewModel Tests', () {
    final absenceTypesModel = AbsenceTypesModel(data: []);

    blocTest<AbsenceTypesViewModel, AppState>(
      'emits [LoadingState, SuccessState] when getAbsenceTypes is successful',
      build: () {
        when(mockApiClient.request<AbsenceTypesModel>(
          endpoint: anyNamed('endpoint'),
          method: anyNamed('method'),
          model: anyNamed('model'),
        )).thenAnswer((_) async => absenceTypesModel);
        return absenceTypesViewModel;
      },
      act: (bloc) => bloc.getAbsenceTypes(),
      expect: () => [
        const LoadingState(),
        isA<SuccessState>(),
      ],
      verify: (_) {
        verify(mockApiClient.request<AbsenceTypesModel>(
          endpoint: anyNamed('endpoint'),
          method: anyNamed('method'),
          model: anyNamed('model'),
        )).called(1);
      },
    );

    blocTest<AbsenceTypesViewModel, AppState>(
      'emits [LoadingState, ErrorState] when getAbsenceTypes fails',
      build: () {
        when(mockApiClient.request<AbsenceTypesModel>(
          endpoint: anyNamed('endpoint'),
          method: anyNamed('method'),
          model: anyNamed('model'),
        )).thenThrow(Exception('Failed to load data'));
        return absenceTypesViewModel;
      },
      act: (bloc) => bloc.getAbsenceTypes(),
      expect: () => [
        const LoadingState(),
        isA<UnknownErrorState>(),
      ],
    );

    blocTest<AbsenceTypesViewModel, AppState>(
      'emits [LoadingState, TimeoutState] when getAbsenceTypes fails',
      build: () {
        when(mockApiClient.request<AbsenceTypesModel>(
          endpoint: anyNamed('endpoint'),
          method: anyNamed('method'),
          model: anyNamed('model'),
        )).thenThrow(TimeoutException());
        return absenceTypesViewModel;
      },
      act: (bloc) => bloc.getAbsenceTypes(),
      expect: () => [
        const LoadingState(),
        isA<TimeoutState>(),
      ],
    );

    blocTest<AbsenceTypesViewModel, AppState>(
      'emits [LoadingState, InternetErrorState] when getAbsenceTypes fails',
      build: () {
        when(mockApiClient.request<AbsenceTypesModel>(
          endpoint: anyNamed('endpoint'),
          method: anyNamed('method'),
          model: anyNamed('model'),
        )).thenThrow(InternetException());
        return absenceTypesViewModel;
      },
      act: (bloc) => bloc.getAbsenceTypes(),
      expect: () => [
        const LoadingState(),
        isA<InternetErrorState>(),
      ],
    );
  });
}
