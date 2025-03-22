import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:members_app/api/api_client.dart';
import 'package:members_app/view_models/app_states.dart';
import 'package:members_app/view_models/members/members_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:members_app/models/members/members_model.dart';
import 'package:members_app/models/pagination_request_model.dart';

import '../mock_api_client.mocks.dart';

void main() {
  late MembersViewModel membersViewModel;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    membersViewModel = MembersViewModel();
    membersViewModel.client = mockApiClient;
  });

  group('MembersViewModel Tests', () {
    final paginationRequest = PaginationRequest(page: 1, limit: 10);
    final membersModel = MembersModel(data: []);

    blocTest<MembersViewModel, AppState>(
      'emits [LoadingState, SuccessState] when getTeamMembers is successful',
      build: () {
        when(mockApiClient.request<MembersModel>(
          endpoint: anyNamed('endpoint'),
          method: anyNamed('method'),
          model: anyNamed('model'),
          queryParams: anyNamed('queryParams'),
        )).thenAnswer((_) async => membersModel);
        return membersViewModel;
      },
      act: (bloc) => bloc.getTeamMembers(paginationRequest: paginationRequest),
      expect: () => [
        const LoadingState(),
        isA<SuccessState>(),
      ],
      verify: (_) {
        verify(mockApiClient.request<MembersModel>(
          endpoint: anyNamed('endpoint'),
          method: anyNamed('method'),
          model: anyNamed('model'),
          queryParams: anyNamed('queryParams'),
        )).called(1);
      },
    );

    blocTest<MembersViewModel, AppState>(
      'emits [LoadingState, UnknownErrorState] when getTeamMembers fails',
      build: () {
        when(mockApiClient.request<MembersModel>(
          endpoint: anyNamed('endpoint'),
          method: anyNamed('method'),
          model: anyNamed('model'),
          queryParams: anyNamed('queryParams'),
        )).thenThrow(Exception('Failed to load data'));
        return membersViewModel;
      },
      act: (bloc) => bloc.getTeamMembers(paginationRequest: paginationRequest),
      expect: () => [
        const LoadingState(),
        isA<UnknownErrorState>(),
      ],
    );

    blocTest<MembersViewModel, AppState>(
      'emits [LoadingState, InternetErrorState] when getTeamMembers fails',
      build: () {
        when(mockApiClient.request<MembersModel>(
          endpoint: anyNamed('endpoint'),
          method: anyNamed('method'),
          model: anyNamed('model'),
          queryParams: anyNamed('queryParams'),
        )).thenThrow(InternetException()
        );
        return membersViewModel;
      },
      act: (bloc) => bloc.getTeamMembers(paginationRequest: paginationRequest),
      expect: () => [
        const LoadingState(),
        isA<InternetErrorState>(),
      ],
    );

    blocTest<MembersViewModel, AppState>(
      'emits [LoadingState, TimeoutState] when getTeamMembers fails',
      build: () {
        when(mockApiClient.request<MembersModel>(
          endpoint: anyNamed('endpoint'),
          method: anyNamed('method'),
          model: anyNamed('model'),
          queryParams: anyNamed('queryParams'),
        )).thenThrow(TimeoutException()
        );
        return membersViewModel;
      },
      act: (bloc) => bloc.getTeamMembers(paginationRequest: paginationRequest),
      expect: () => [
        const LoadingState(),
        isA<TimeoutState>(),
      ],
    );
  });
}
