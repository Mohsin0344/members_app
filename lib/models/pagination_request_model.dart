class PaginationRequest {
  final int limit;
  int page;
  String? type;
  String? date;

  PaginationRequest({
    this.limit = 10,
    required this.page,
    this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'limit': limit,
      'page': page,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
    };
  }
}
