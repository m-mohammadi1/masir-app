import 'dart:convert';
import 'dart:developer';
import 'package:easy_helper/easy_helper.dart';

export 'request.dart';
export 'failure.dart';
export 'result.dart';

part 'dio_restful_api.dart';

/// Result Type
typedef TResult<T extends BaseResult> = ({
  T model,
  bool isList,
  List<String>? maps,
});

/// Response Result
typedef RResult<T extends BaseResult> = ({
  T? result,
  List<T>? results,
  dynamic data,
});

extension ResultExtension on BaseResult {
  TResult get toResult => (model: this, isList: false, maps: ['result']);

  TResult get toResults => (model: this, isList: true, maps: ['result']);

  TResult setResult(List<String> maps) =>
      (model: this, isList: false, maps: maps);

  TResult setResults(List<String> maps) =>
      (model: this, isList: true, maps: maps);
}

sealed class IRestfulApi {
  Future<RResult> get({
    required String path,
    required TResult result,
    JsonRequest? request,
  });

  Future<RResult> post({
    required String path,
    required TResult result,
    BaseRequest? request,
  });

  Future<RResult> put({
    required String path,
    required TResult result,
    BaseRequest? request,
  });

  Future<RResult> patch({
    required String path,
    required TResult result,
    BaseRequest? request,
  });

  Future<RResult> delete({
    required String path,
    required TResult result,
    BaseRequest? request,
  });
}
