import 'package:equatable/equatable.dart';

class IOSCallKit extends Equatable {
  String iconTemplateImageData;
  String? ringtoneSound;

  IOSCallKit({
    required this.iconTemplateImageData,
    this.ringtoneSound,
  });

  factory IOSCallKit.fromJson(Map<String, dynamic> json) {
    try {
      return IOSCallKit(
          iconTemplateImageData: json['iconTemplateImageData'],
          ringtoneSound: json['ringtoneSound']);
    } catch (e) {
      print('Error parsing ALIOTTCallData from JSON: $e');
      throw Exception('Error parsing ALIOTTCallData from JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'iconTemplateImageData': iconTemplateImageData,
      'ringtoneSound': ringtoneSound,
    };
  }

  @override
  List<Object?> get props => [
        iconTemplateImageData,
        ringtoneSound,
      ];
}
