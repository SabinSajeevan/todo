import 'package:flutter/foundation.dart';

class ResponseState {
  final dynamic response;
  final bool? isLoading;
  final bool? isError;
  final String? errorMessage;
  final String? head;

  ResponseState(
      {this.head,
      this.response,
      this.isLoading,
      this.errorMessage,
      this.isError});

  ResponseState.initial()
      : response = [],
        isLoading = false,
        errorMessage = '',
        head = '',
        isError = false;

  ResponseState copyWith(
      {dynamic response,
      bool? isLoading,
      bool? isError,
      String? errorMessage,
      String? head}) {
    return ResponseState(
        response: response ?? this.response,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        isError: isError ?? this.isError,
        head: head ?? this.head);
  }

  @override
  String toString() =>
      'ResponseState(response: $response, isLoading: $isLoading, errorMessage: $errorMessage, isError: $isError, head: $head)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResponseState &&
        listEquals(other.response, response) &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.head == head &&
        other.isError == isError;
  }

  @override
  int get hashCode =>
      response.hashCode ^
      isLoading.hashCode ^
      errorMessage.hashCode ^
      head.hashCode ^
      isError.hashCode;
}
