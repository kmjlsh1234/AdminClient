enum HTTP{
  GET,
  POST,
  PUT,
  DELETE
}

extension HTTPMethods on HTTP {
  String get name {
    return toString()
        .split('.')
        .last;
  }
}
