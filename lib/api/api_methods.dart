enum ApiMethod {
  get,
  post,
  put,
  patch,
  delete,
}

extension ApiMethodExtension on ApiMethod {
  String get value {
    switch (this) {
      case ApiMethod.get:
        return 'GET';
      case ApiMethod.post:
        return 'POST';
      case ApiMethod.put:
        return 'PUT';
      case ApiMethod.patch:
        return 'PATCH';
      case ApiMethod.delete:
        return 'DELETE';
    }
  }
}
