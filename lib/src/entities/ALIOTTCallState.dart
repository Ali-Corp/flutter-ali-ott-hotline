// ignore_for_file: constant_identifier_names

enum ALIOTTCallState {
  ALIOTTCallStatePending,
  ALIOTTCallStateCalling,
  ALIOTTCallStateActive,
  ALIOTTCallStateHeld,
  ALIOTTCallStateEnded,
}

// Extension to add a method to convert from String to enum
extension ALIOTTCallStateExtension on ALIOTTCallState {
  static ALIOTTCallState fromString(String value) {
    switch (value) {
      case 'ALIOTTCallStatePending':
        return ALIOTTCallState.ALIOTTCallStatePending;
      case 'ALIOTTCallStateCalling':
        return ALIOTTCallState.ALIOTTCallStateCalling;
      case 'ALIOTTCallStateActive':
        return ALIOTTCallState.ALIOTTCallStateActive;
      case 'ALIOTTCallStateHeld':
        return ALIOTTCallState.ALIOTTCallStateHeld;
      case 'ALIOTTCallStateEnded':
        return ALIOTTCallState.ALIOTTCallStateEnded;
      default:
        throw ArgumentError('Invalid enum value: $value');
    }
  }
}

enum ALIOTTCallConnectedState {
  ALIOTTConnectedStatePending,
  ALIOTTConnectedStateComplete,
}

// Extension to add a method to convert from String to enum
extension ALIOTTCallConnectedStateExtension on ALIOTTCallConnectedState {
  static ALIOTTCallConnectedState fromString(String value) {
    switch (value) {
      case 'ALIOTTConnectedStatePending':
        return ALIOTTCallConnectedState.ALIOTTConnectedStatePending;
      case 'ALIOTTConnectedStateComplete':
        return ALIOTTCallConnectedState.ALIOTTConnectedStateComplete;
      default:
        throw ArgumentError('Invalid enum value: $value');
    }
  }
}
