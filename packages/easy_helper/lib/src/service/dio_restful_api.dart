part of 'restful_api.dart';

class DioRestfulApi implements IRestfulApi {
  final WebService webService;

  const DioRestfulApi({required this.webService});

  Map<String, dynamic> fixMap(dynamic json, List<String>? maps) {
    if (json.runtimeType == String) json = jsonDecode(json);

    if (maps != null && maps.isNotEmpty) {
      for (var e in maps) {
        json = json[e];
      }
    }
    return json;
  }

  List<dynamic> fixMaps(dynamic json, List<String>? maps) {
    if (json.runtimeType == String) json = jsonDecode(json);

    if (maps != null && maps.isNotEmpty) {
      for (var e in maps) {
        json = json[e];
      }
    }
    return json;
  }

  @override
  Future<RResult> get({
    required String path,
    required TResult result,
    JsonRequest? request,
  }) async {
    var response = await webService.dio.get(
      path,
      queryParameters: request?.toJson(),
    );

    try {
      if (result.isList) {
        var temp = fixMaps(response.data, result.maps);
        List<BaseResult> ls = result.model.listFromJson(temp);
        return (result: null, results: ls, data: response.data);
      }
      var temp = fixMap(response.data, result.maps);
      return (
        result: result.model.fromJson(temp),
        results: null,
        data: response.data
      );
    } catch (e) {
      log("Parse error in Dio Restful Api:   $e");
      return (result: null, results: null, data: response.data);
    }
  }

  @override
  Future<RResult> post({
    required String path,
    required TResult result,
    BaseRequest? request,
  }) async {
    var response = await webService.dio.post(path, data: request?.toJson());

    try {
      if (result.isList) {
        var temp = fixMaps(response.data, result.maps);
        List<BaseResult> ls = result.model.listFromJson(temp);
        return (result: null, results: ls, data: response.data);
      }
      var temp = fixMap(response.data, result.maps);
      return (
        result: result.model.fromJson(temp),
        results: null,
        data: response.data
      );
    } catch (e) {
      log("Parse error in Dio Restful Api:   $e");
      return (result: null, results: null, data: response.data);
    }
  }

  @override
  Future<RResult> put({
    required String path,
    required TResult result,
    BaseRequest? request,
  }) async {
    var response = await webService.dio.put(path, data: request?.toJson());
    try {
      if (result.isList) {
        var temp = fixMaps(response.data, result.maps);
        List<BaseResult> ls = result.model.listFromJson(temp);
        return (result: null, results: ls, data: response.data);
      }
      var temp = fixMap(response.data, result.maps);
      return (
        result: result.model.fromJson(temp),
        results: null,
        data: response.data
      );
    } catch (e) {
      log("Parse error in Dio Restful Api:   $e");
      return (result: null, results: null, data: response.data);
    }
  }

  @override
  Future<RResult> patch({
    required String path,
    required TResult result,
    BaseRequest? request,
  }) async {
    var response = await webService.dio.patch(path, data: request?.toJson());
    try {
      if (result.isList) {
        var temp = fixMaps(response.data, result.maps);
        List<BaseResult> ls = result.model.listFromJson(temp);
        return (result: null, results: ls, data: response.data);
      }
      var temp = fixMap(response.data, result.maps);
      return (
        result: result.model.fromJson(temp),
        results: null,
        data: response.data
      );
    } catch (e) {
      log("Parse error in Dio Restful Api:   $e");
      return (result: null, results: null, data: response.data);
    }
  }

  @override
  Future<RResult> delete({
    required String path,
    required TResult result,
    BaseRequest? request,
  }) async {
    var response = await webService.dio.delete(path, data: request?.toJson());
    try {
      if (result.isList) {
        var temp = fixMaps(response.data, result.maps);
        List<BaseResult> ls = result.model.listFromJson(temp);
        return (result: null, results: ls, data: response.data);
      }
      var temp = fixMap(response.data, result.maps);
      return (
        result: result.model.fromJson(temp),
        results: null,
        data: response.data,
      );
    } catch (e) {
      log("Parse error in Dio Restful Api:   $e");
      return (result: null, results: null, data: response.data);
    }
  }
}
