import 'package:equatable/equatable.dart';

class ALIOTTCall extends Equatable {
  String uuid;
  String callerId;
  String callerAvatar;
  String calleeId;
  String calleeAvatar;
  String calleeName;
  dynamic metadata;

  ALIOTTCall({
    required this.uuid,
    required this.callerId,
    required this.callerAvatar,
    required this.calleeId,
    required this.calleeAvatar,
    required this.calleeName,
    required this.metadata,
  });

  factory ALIOTTCall.fromJson(Map<String, dynamic> json) {
    try {
      return ALIOTTCall(
          uuid: json['uuid']?.toString() ?? "",
          callerId: json['callerId']?.toString() ?? "",
          callerAvatar: json['callerAvatar']?.toString() ?? "",
          calleeId: json['calleeId']?.toString() ?? "",
          calleeAvatar: json['calleeAvatar']?.toString() ?? "",
          calleeName: json['calleeName']?.toString() ?? "",
          metadata: json['metadata']);
    } catch (e) {
      print('Error parsing ALIOTTCall from JSON: $e');
      throw Exception('Error parsing ALIOTTCall from JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'callerId': callerId,
      'callerAvatar': callerAvatar,
      'calleeId': calleeId,
      'calleeAvatar': calleeAvatar,
      'calleeName': calleeName,
      'metadata': metadata,
    };
  }

  @override
  List<Object> get props => [
        uuid,
        callerId,
        callerAvatar,
        calleeId,
        calleeAvatar,
        calleeName,
        metadata,
      ];
}
