package vn.ali.flutter_ali_ott_hotline

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener
import vn.ali.ott.core.Constants
import vn.ali.ott.core.`object`.ALIOTTCallState
import vn.ali.ott.core.`object`.ALIOTTEnv
import vn.ali.ott.hotline.ALIOTT
import vn.ali.ott.hotline.ALIOTTCallDelegate
import vn.ali.ott.hotline.ALIOTTDelegate
import vn.ali.ott.hotline.`object`.ALIOTTCall
import java.util.function.Function


/** FlutterAliOttHotlinePlugin */
class FlutterAliOttHotlinePlugin: FlutterPlugin, MethodCallHandler, ALIOTTCallDelegate,
  ALIOTTDelegate, StreamHandler, ActivityAware , RequestPermissionsResultListener  {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var methodChannel: MethodChannel
  private var eventChannel: EventChannel? = null
  private var eventSink: EventSink? = null
  private lateinit var context: Context
  private var activity: Activity? = null
  private var onPermissionRequestResultCallback: Function<Boolean, Void>? =  null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_ali_ott_hotline")
    methodChannel.setMethodCallHandler(this)

    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_ali_ott_hotline_event")
    //eventChannel?.setStreamHandler(this)

    context = flutterPluginBinding.applicationContext
  }

  override fun onListen(arguments: Any?, events: EventSink?) {
    events!!.also { this.eventSink = it }
    // Start sending events if needed
  }

  override fun onCancel(arguments: Any?) {
    this.eventSink = null
    // Stop sending events if needed
  }

  // Method to send events to Flutter
  private fun sendEvent(data: Any) {
    if (eventSink != null) {
      eventSink?.success(data)
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "config" -> config(call, result)
      "startHotlineCall" -> startHotlineCall(call, result)
      "endCall" -> endCall(call, result)
      "setSpeakOn" -> setSpeakOn(call, result)
      "setMuteCall" -> setMuteCall(call, result)
      "startListenEvent" -> startListenEvent(call, result)
      "stopListenEvent" -> stopListenEvent(call, result)
      "startListenCallEvent" -> startListenCallEvent(call, result)
      "stopListenCallEvent" -> stopListenCallEvent(call, result)
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    //eventChannel?.setStreamHandler(null);
  }
  private fun config(@NonNull call: MethodCall, @NonNull result: Result) {
    val arguments = call.arguments as Map<String, Any>
    val hotlineConfig = arguments["hotlineConfig"] as Map<String, Any>
    val environment = arguments["environment"] as String
    val customOnHoldSound = arguments["customOnHoldSound"] as String?
    val timeoutCall = arguments["timeoutForOutgoingCall"] as Double?

    var customHoldSoundResId: Int? = null;
    if (customOnHoldSound != null) {
      val resId: Int = context.resources.getIdentifier(
        customOnHoldSound, "raw", context.packageName
      )

      if (resId > 0) {
        customHoldSoundResId = resId;
      }
    }
    var timeout: Long = 60 * 1000
    if (timeoutCall != null) {
      timeout = timeoutCall.toLong() * 1000
    }

    ALIOTT.getInstance().config(
      context,
      ALIOTTEnv.fromString(environment.lowercase()),
      ObjectParser.getInstance().hotlineConfigFromMap(hotlineConfig),
      customHoldSoundResId,
      timeout
    )

    result.success(null)
  }

  private fun startHotlineCall(@NonNull call: MethodCall, @NonNull result: Result) {
    val arguments = call.arguments as Map<String, Any>
    val callerId = arguments["callerId"] as String
    val callerName = arguments["callerName"] as String
    val callerAvatar = arguments["callerAvatar"] as String?

    ALIOTT.getInstance().startHotlineCall(callerId, callerName, callerAvatar)

    result.success(null)
  }

  private fun endCall(@NonNull call: MethodCall, @NonNull result: Result) {
    ALIOTT.getInstance().endCall()
    result.success(null)
  }

  private fun setSpeakOn(@NonNull call: MethodCall, @NonNull result: Result) {
    val arguments = call.arguments as Map<String, Any>
    val speak = arguments["on"] as Boolean
    ALIOTT.getInstance().setSpeakOn(speak)
    result.success(null)
  }

  private fun setMuteCall(@NonNull call: MethodCall, @NonNull result: Result) {
    val arguments = call.arguments as Map<String, Any>
    val mute = arguments["on"] as Boolean
    ALIOTT.getInstance().setMuteCall(mute)
    result.success(null)
  }
  private fun startListenEvent(@NonNull call: MethodCall, @NonNull result: Result) {
    ALIOTT.getInstance().setDelegate(this);
    this.eventChannel?.setStreamHandler(this);
    result.success(null)
  }

  private fun stopListenEvent(@NonNull call: MethodCall, @NonNull result: Result) {
    this.eventChannel?.setStreamHandler(null);
    ALIOTT.getInstance().setDelegate(null);
    result.success(null)
  }

  private fun startListenCallEvent(@NonNull call: MethodCall, @NonNull result: Result) {
    ALIOTT.getInstance().setCallDelegate(this);
    result.success(null)
  }
  private fun stopListenCallEvent(@NonNull call: MethodCall, @NonNull result: Result) {
    ALIOTT.getInstance().setCallDelegate(null);
    result.success(null)
  }
  override fun aliottOnStartCallFail(message: String?) {
    var mess = ""
    if (message != null) {
      mess = message
    }
    val params = ObjectParser.getInstance().payloadForStartCallFailEvent(mess)
    sendEvent(params)
  }

  override fun aliottOnCallStateChange(callState: ALIOTTCallState) {
    val params = ObjectParser.getInstance().payloadForCallStateChangeEvent(callState)
    sendEvent(params)
  }

  override fun aliottOnCallConnectStateChange(connectedTime: Long) {
    val params = ObjectParser.getInstance().payloadForConnectStateChangeEvent(connectedTime)
    sendEvent(params)
  }

  override fun aliottOnInitSuccess() {
    val map = mutableMapOf<String, Any>()
    map.put("type", "aliottOnInitSuccess")
    sendEvent(map)
  }

  override fun aliottOnInitFail(p0: String?) {
    val map = mutableMapOf<String, Any>()
    map.put("type", "aliottOnInitFail")
    sendEvent(map)
  }
  override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
    if (requestCode == Constants.AUDIO_REQUEST_PERMISSION_CODE) {
      if (grantResults.size > 0 && permissions.size > 0) {
        for (i in permissions.indices) {
          if (permissions[i] == Manifest.permission.RECORD_AUDIO) {
            onPermissionRequestResultCallback!!.apply(grantResults[i] == PackageManager.PERMISSION_GRANTED)
            break
          }
        }
      }
    }
    return false
  }
  override fun aliottOnRequestRequiredPermission(callback: Function<Boolean, Void>?) {

    onPermissionRequestResultCallback = callback
    activity?.let {
      if (ActivityCompat.checkSelfPermission(
          it,
          Manifest.permission.RECORD_AUDIO
        ) != PackageManager.PERMISSION_GRANTED
      ) {
        ActivityCompat.requestPermissions(
          it,
          arrayOf(Manifest.permission.RECORD_AUDIO),
          Constants.AUDIO_REQUEST_PERMISSION_CODE
        )
      }
    }

  }

  override fun aliottOnRequestShowCall(call: ALIOTTCall?) {
    val params = call?.let { ObjectParser.getInstance().payloadForRequestShowCall(it)}
    params?.let { sendEvent(it) }
  }
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    this.activity = null
  }

}
