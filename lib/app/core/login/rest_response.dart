class RestResponse {
  final String type;
  final dynamic results;
  final int status;

  RestResponse({
    required this.type,
    required this.results,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type,
      'results': results,
      'status': status,
    };
  }

  factory RestResponse.fromJson(Map<String, dynamic> map) {
    return RestResponse(
      type: map['type'] as String,
      results: map['results'] as dynamic,
      status: map['status'] as int,
    );
  }
}
