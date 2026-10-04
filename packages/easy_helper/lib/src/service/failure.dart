abstract class Failure {
  final String message;

  const Failure({this.message = ""});

  Failure fromJson(Map<String, dynamic> json) {
    return Failure.fromJson(json);
  }

  factory Failure.fromJson(Map<String, dynamic> json) {
    return Failure.fromJson(json);
  }
}

class DefaultFailure implements Failure {
  @override
  final String message;

  DefaultFailure({this.message = ""});

  @override
  DefaultFailure fromJson(Map<String, dynamic> json) {
    return DefaultFailure(message: json['message']);
  }
}

class ServerFailure implements Failure {
  @override
  final String message;

  ServerFailure({this.message = ""});

  @override
  ServerFailure fromJson(dynamic json) {
    try {
      if (json == null) {
        return ServerFailure(message: "یه چیزی این وسط خراب شد، چند لحظه دیگه دوباره امتحان کن");
      } else if (json.runtimeType == String) {
        return ServerFailure(message: json.toString());
      } else if (json.containsKey("messages")) {
        List<String> errors = [];

        for (var element in List.from(json['messages'])) {
          errors.add(element['message']);
        }

        String message = "";
        for (var e in errors) {
          message += "$e\n";
        }
        return ServerFailure(message: message.trim());
      } else if (json.containsKey("message")) {
        return ServerFailure(message: json['message']);
      } else if (json.containsKey("msg")) {
        return ServerFailure(message: json['msg']);
      } else if (json.containsKey("error")) {
        return ServerFailure(message: json['error']);
      } else {
        List<String> errors = [];

        var j = Map<String, dynamic>.from(json);
        var temp = j
            .map((key, value) => MapEntry(key, List<String>.from(value)))
            .values;

        for (var element in temp) {
          errors.addAll(element);
        }
        String message = "";
        for (var e in errors) {
          message += "$e\n";
        }

        return ServerFailure(message: message.trim());
      }
    } catch (e) {
      return ServerFailure(message: e.toString());
    }
  }
}
