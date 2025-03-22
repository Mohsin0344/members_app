import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
sealed class AppState implements Equatable {
  const AppState();
}

final class InitialState extends AppState {
  const InitialState();

  @override
  // TODO: implement props
  List<Object?> get props => ['InitialState'];

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}

final class LoadingState extends AppState {
  const LoadingState();

  @override
  // TODO: implement props
  List<Object?> get props => ['LoadingState'];

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}

final class LoadingStateWithProgress extends AppState {
  final double progress;

  const LoadingStateWithProgress({
    required this.progress,
  });

  @override
  // TODO: implement props
  List<Object?> get props => ['LoadingStateWithProgress'];

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}

final class SuccessState<T> extends AppState {
  final T data;

  const SuccessState({
    required this.data,
  });

  @override
  // TODO: implement props
  List<Object?> get props => ['SuccessState'];

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}

final class ApiErrorState extends AppState {
  final String? error;

  const ApiErrorState({this.error});

  @override
  // TODO: implement props
  List<Object?> get props => ['ApiErrorState'];

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}

final class TimeoutState extends AppState {
  const TimeoutState();

  @override
  // TODO: implement props
  List<Object?> get props => ['TimeoutState'];

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}

final class InternetErrorState extends AppState {
  const InternetErrorState();

  @override
  // TODO: implement props
  List<Object?> get props => ['InternetErrorState'];

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}

final class VersionErrorState extends AppState {
  const VersionErrorState();

  @override
  // TODO: implement props
  List<Object?> get props => ['VersionErrorState'];

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}

final class UnknownErrorState extends AppState {
  final String? error;

  const UnknownErrorState({this.error});

  @override
  // TODO: implement props
  List<Object?> get props => ['UnknownErrorState'];

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}


