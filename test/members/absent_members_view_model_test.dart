import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:members_app/api/api_client.dart';
import 'package:members_app/view_models/app_states.dart';
import 'package:members_app/view_models/members/absent_members_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:members_app/models/members/absent_members_model.dart';
import 'package:members_app/models/pagination_request_model.dart';

import '../mock_api_client.mocks.dart';

void main() {
  late AbsentMembersViewModel absentMembersViewModel;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    absentMembersViewModel = AbsentMembersViewModel();
    absentMembersViewModel.client = mockApiClient;
  });

  group('AbsentMembersViewModel Tests', () {
    final paginationRequest = PaginationRequest(page: 1, limit: 10);
    final absentMembersModel = AbsentMembersModel(data: []);

    blocTest<AbsentMembersViewModel, AppState>(
      'emits [LoadingState, SuccessState] when getAbsentMembers is successful',
      build: () {
        when(mockApiClient.request<AbsentMembersModel>(
          endpoint: anyNamed('endpoint'),
          method: anyNamed('method'),
          model: anyNamed('model'),
          queryParams: anyNamed('queryParams'),
        )).thenAnswer((_) async => absentMembersModel);
        return absentMembersViewModel;
      },
      act: (bloc) => bloc.getAbsentMembers(paginationRequest: paginationRequest),
      expect: () => [
        const LoadingState(),
        isA<SuccessState>(),
      ],
      verify: (_) {
        verify(mockApiClient.request<AbsentMembersModel>(
          endpoint: anyNamed('endpoint'),
          method: anyNamed('method'),
          model: anyNamed('model'),
          queryParams: anyNamed('queryParams'),
        )).called(1);
      },
    );


    blocTest<AbsentMembersViewModel, AppState>(
      'emits [LoadingState, UnknownErrorState] when getAbsentMembers fails',
      build: () {
        when(mockApiClient.request<AbsentMembersModel>(
          endpoint: anyNamed('endpoint'),
          method: anyNamed('method'),
          model: anyNamed('model'),
          queryParams: anyNamed('queryParams'),
        )).thenThrow(Exception('Failed to load data'));
        return absentMembersViewModel;
      },
      act: (bloc) => bloc.getAbsentMembers(paginationRequest: paginationRequest),
      expect: () => [
        const LoadingState(),
        isA<UnknownErrorState>(),
      ],
    );

    blocTest<AbsentMembersViewModel, AppState>(
      'emits [LoadingState, TimeoutState] when getAbsentMembers fails',
      build: () {
        when(mockApiClient.request<AbsentMembersModel>(
          endpoint: anyNamed('endpoint'),
          method: anyNamed('method'),
          model: anyNamed('model'),
          queryParams: anyNamed('queryParams'),
        )).thenThrow(TimeoutException());
        return absentMembersViewModel;
      },
      act: (bloc) => bloc.getAbsentMembers(paginationRequest: paginationRequest),
      expect: () => [
        const LoadingState(),
        isA<TimeoutState>(),
      ],
    );

    blocTest<AbsentMembersViewModel, AppState>(
      'emits [LoadingState, InternetErrorState] when getAbsentMembers fails',
      build: () {
        when(mockApiClient.request<AbsentMembersModel>(
          endpoint: anyNamed('endpoint'),
          method: anyNamed('method'),
          model: anyNamed('model'),
          queryParams: anyNamed('queryParams'),
        )).thenThrow(InternetException());
        return absentMembersViewModel;
      },
      act: (bloc) => bloc.getAbsentMembers(paginationRequest: paginationRequest),
      expect: () => [
        const LoadingState(),
        isA<InternetErrorState>(),
      ],
    );
  });
}
