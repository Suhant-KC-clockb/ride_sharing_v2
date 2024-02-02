class ErrorResponse {
  late String title;
  late String? header;
  ErrorResponse({required this.title, this.header});
}

class DynamicErrorResponse {
  DynamicErrorResponse({
    required Map<String, dynamic> data,
  }) {
    key = data.keys.first;
    final test = data[key];
    description = test[0];
  }

  late String? key;
  late String? description;

  // factory DynamicErrorResponse.fromJson(Map<String, dynamic> json) {
  //   final key = json.keys.first;

  //   print(key);
  //   final description = json[key];

  //   return DynamicErrorResponse(description: description, key: key, data: json);
  // }
}
