import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ALIOTTHotlineConfig extends Equatable {
  late String id;
  late String key;
  late String name;
  late String icon;

  ALIOTTHotlineConfig({
    required this.id,
    required this.key,
    required this.name,
    required this.icon,
  });

  factory ALIOTTHotlineConfig.fromJson(Map<String, dynamic> json) {
    return ALIOTTHotlineConfig(
      id: json['id'],
      key: json['key'],
      name: json['name'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'name': name,
      'icon': icon,
    };
  }

  @override
  List<Object> get props => [
        id,
        key,
        name,
        icon,
      ];
}
