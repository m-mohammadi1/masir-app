import '/features/main/domain/entities/my_subscriptions.dart';

class MySubscriptionsModel extends MySubscriptionsEntity {
  const MySubscriptionsModel({super.id});

  @override
  MySubscriptionsModel fromJson(Map<String, dynamic> json) {
    return MySubscriptionsModel(id: json['id']);
  }

  Map<String, dynamic> toJson() => {"id": id};

  MySubscriptionsModel copyWith(String? id) {
    return MySubscriptionsModel(id: id ?? this.id);
  }
}
