class PaginationRequest {
  final int limit;
  int page;
  String? type;

  PaginationRequest({this.limit = 10, required this.page});

  Map<String, dynamic> toJson() {
    return {
      'limit': limit,
      'page': page,
      if(type != null) 'type': type,
    };
  }
}