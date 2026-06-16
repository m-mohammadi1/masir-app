import 'package:dio/dio.dart';

abstract class BaseRequest {
  const BaseRequest();

  Object toJson() => toJson();
}

abstract class JsonRequest implements BaseRequest {
  const JsonRequest();

  factory JsonRequest.model() => _JsonRequestModel();

  @override
  Map<String, dynamic> toJson() => toJson();
}

class _JsonRequestModel implements JsonRequest {
  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

abstract class FormDataRequest implements BaseRequest {
  const FormDataRequest();

  @override
  FormData toJson() => toJson();
}

abstract class AnyDataRequest implements BaseRequest {
  const AnyDataRequest();

  @override
  toJson() => toJson();
}

mixin RequestMixin implements BaseRequest {}
