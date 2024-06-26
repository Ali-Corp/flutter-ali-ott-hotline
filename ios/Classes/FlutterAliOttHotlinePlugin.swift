import Flutter
import UIKit
import ALIOTTHotline
import SwiftyJSON

public class FlutterAliOttHotlinePlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    var channelInstance: FlutterMethodChannel?
    var eventChannel: FlutterEventChannel?
    var sink: FlutterEventSink?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let taskQueue = registrar.messenger().makeBackgroundTaskQueue!()

        let channelInstance = FlutterMethodChannel(
            name: "flutter_ali_ott_hotline",
            binaryMessenger: registrar.messenger(),
            codec: FlutterStandardMethodCodec.sharedInstance(),
            taskQueue: taskQueue)


        let eventChannel = FlutterEventChannel(name: "flutter_ali_ott_hotline_event",
                                               binaryMessenger: registrar.messenger(),
                                               codec: FlutterStandardMethodCodec.sharedInstance(),
                                               taskQueue: taskQueue)


        let instance = FlutterAliOttHotlinePlugin(channelInstance: channelInstance,
                                                  eventChannel: eventChannel)

        registrar.addMethodCallDelegate(instance, channel: channelInstance)
    }

    init(channelInstance: FlutterMethodChannel, eventChannel: FlutterEventChannel) {
        self.channelInstance = channelInstance
        self.eventChannel = eventChannel

        super.init()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "config":
            self.config(call, result)
            break
        case "startHotlineCall":
            self.startHotlineCall(call, result)
            break
        case "endCall":
            self.endCall(call, result)
            break
        case "setSpeakOn":
            self.setSpeakOn(call, result)
            break
        case "setMuteCall":
            self.setMuteCall(call, result)
            break
        case "startListenEvent":
            self.startListenEvent(call, result)
            break
        case "stopListenEvent":
            self.stopListenEvent(call, result)
            break
        case "startListenCallEvent":
            self.startListenCallEvent(call, result)
            break
        case "stopListenCallEvent":
            self.stopListenCallEvent(call, result)
            break
        default:
            result(nil)
        }
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
}

extension ALIOTTHotlineConfig {
    static func fromDict(data: NSDictionary) -> ALIOTTHotlineConfig {
        return ALIOTTHotlineConfig(id: data["id"] as! String,
                                   key: data["key"] as! String,
                                   name: data["name"] as! String,
                                   icon: data["icon"] as! String)
    }

    func toDict() -> NSDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(id, forKey: "id")
        dict.setValue(key, forKey: "key")
        dict.setValue(name, forKey: "name")
        dict.setValue(icon, forKey: "icon")

        return dict
    }
}

extension ALIOTTCall {
    func toDict() -> NSDictionary {

        let dict = NSMutableDictionary()
        dict.setValue(callerId, forKey: "callerId")
        dict.setValue(callerAvatar, forKey: "callerAvatar")
        dict.setValue(calleeId, forKey: "calleeId")
        dict.setValue(calleeAvatar, forKey: "calleeAvatar")
        dict.setValue(calleeName, forKey: "calleeName")
        dict.setValue(metadata.rawString([:]), forKey: "metadata")

        return dict
    }
}

extension ALIOTTCallState {
    func raw() -> String {
        switch self {
            case .pending: return "ALIOTTCallStatePending"
            case .calling: return "ALIOTTCallStateCalling"
            case .active: return "ALIOTTCallStateActive"
            case .ended: return "ALIOTTCallStateEnded"
        }
    }
}

extension ALIOTTConnectedState {
    func raw() -> String {
        switch self {
            case .pending: return "ALIOTTConnectedStatePending"
            case .complete: return "ALIOTTConnectedStateComplete"
        }
    }
}

func convertDictionaryTo(_ nsDictionary: NSDictionary) -> [String: Any] {
    var swiftDictionary: [String: Any] = [:]

    for (key, value) in nsDictionary {
        if let key = key as? String {
            if let nestedNSDictionary = value as? NSDictionary {
                swiftDictionary[key] = convertDictionaryTo(nestedNSDictionary)
            } else {
                swiftDictionary[key] = value
            }
        }
    }

    return swiftDictionary
}

extension FlutterAliOttHotlinePlugin {
    private func config(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>

        guard  let hotlineConfig = arguments["hotlineConfig"] as? [String: Any] else {
            return
        }
        let callKit = arguments["iOSCallKit"] as? [String: Any]

        let environment = arguments["environment"] as?  String ?? "sandbox"
        let iconTemplateImageData = callKit?["iconTemplateImageData"] as?  String ?? "AppIcon"
        let ringtoneSound = callKit?["ringtoneSound"] as?  String
        let customOnHoldSound = arguments["customOnHoldSound"] as? String ?? "ringtone-nhac-cho"
        let timeoutForOutgoingCall = arguments["timeoutForOutgoingCall"] as? TimeInterval ?? 60.0

        let config = NSDictionary(dictionary: hotlineConfig)
        let imageData = UIImage(named: iconTemplateImageData)?.pngData()

        ALIOTT.shared().config(environment: ALIOTTEnv(rawValue: environment) ?? ALIOTTEnv.sandbox,
                               hotlineConfig: ALIOTTHotlineConfig.fromDict(data: config),
                               callKitConfig: CallKitConfig(iconTemplateImageData: imageData, ringtoneSound: ringtoneSound),
                               customOnHoldSound: customOnHoldSound,
                               timeoutForOutgoingCall: timeoutForOutgoingCall)

        result(nil)
    }

    // startHotlineCallCMM
    private func startHotlineCall(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>

        ALIOTT.shared().startHotlineCall(callerId: arguments["callerId"] as! String,
                                         callerName: arguments["callerName"] as! String,
                                         callerAvatar: arguments["callerAvatar"] as? String)
        result(nil)
    }

    //setSpeakOn
    private func setSpeakOn(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let isSpeak = arguments["on"] as? Bool ?? false

        ALIOTT.shared().setSpeakOn(on: isSpeak)
        result(nil)
    }

    //setMuteCall
    private func setMuteCall(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let isMute = arguments["on"] as? Bool ?? false

        ALIOTT.shared().setMuteCall(mute: isMute)
        result(nil)
    }
    //endCall
    private func endCall(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        ALIOTT.shared().endCall()
        result(nil)
    }

    private func startListenEvent(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        DispatchQueue.main.async {
            ALIOTT.shared().delegate = self
            self.eventChannel?.setStreamHandler(self)
            result(nil)
        }
    }

    private func stopListenEvent(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        eventChannel?.setStreamHandler(nil)
        ALIOTT.shared().delegate = nil
        result(nil)
    }

    //startListenCallEvent
    private func startListenCallEvent(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        ALIOTT.shared().callDelegate = self
        result(nil)
    }

    //stopListenCallEvent
    private func stopListenCallEvent(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        ALIOTT.shared().callDelegate = nil
        result(nil)
    }
}

extension FlutterAliOttHotlinePlugin: ALIOTTDelegate {
    public func aliottOnInitSuccess() {
        let jsonBody = [
            "type": "aliottOnInitSuccess"
        ] as [String : Any]

        sink?(jsonBody)
    }

    public func aliottOnInitFail() {
        let jsonBody = [
            "type": "aliottOnInitFail"
        ] as [String : Any]

        sink?(jsonBody)
    }

    public func aliottOnRequestShowCall(call: ALIOTTCall) {
        let jsonBody = [
            "type": "aliottOnRequestShowCall",
            "payload": convertDictionaryTo(call.toDict())
        ] as [String : Any]

        sink?(jsonBody)
    }
}

extension FlutterAliOttHotlinePlugin: ALIOTTCallDelegate {
    public func aliottOnCallStateChange(_ callState: ALIOTTCallState) {
        let jsonBody = [
            "type": "aliottOnCallStateChange",
            "payload":  ["callState": callState.raw()],
        ] as [String : Any]

        sink?(jsonBody)
    }

    public func aliottOnCallConnectedChange(_ connectedState: ALIOTTConnectedState?, connectedDate: Date?) {
        var payload: [String: Any] = [:]

        if let connectedState = connectedState {
            payload["connectedState"] = connectedState.raw()
        }

        if let connectedDate = connectedDate {
            payload["connectedDate"] = Int(connectedDate.timeIntervalSince1970 * 1000)
        }

        let jsonBody = [
            "type": "aliottOnCallConnectedChange",
            "payload": payload,
        ] as [String : Any]

        sink?(jsonBody)
    }
}
