package vn.ali.flutter_ali_ott_hotline

import com.google.gson.Gson
import vn.ali.ott.core.`object`.ALIOTTCallConfig
import vn.ali.ott.core.`object`.ALIOTTCallData
import vn.ali.ott.core.`object`.ALIOTTCallState
import vn.ali.ott.core.`object`.ALIOTTHotlineConfig
import vn.ali.ott.core.`object`.ALIOTTServerConfig
import vn.ali.ott.core.`object`.ALIOTTUser
import vn.ali.ott.hotline.`object`.ALIOTTCall

class ObjectParser private constructor()
{
    companion object {
        @Volatile
        private var instance: ObjectParser? = null

        fun getInstance(): ObjectParser {
            return instance ?: synchronized(this) {
                instance ?: ObjectParser().also { instance = it }
            }
        }
    }

    public fun hotlineConfigFromMap(map: Map<String, Any>): ALIOTTHotlineConfig {
        val id = map["id"] as String
        val key = map["key"] as String
        val name = map["name"] as String
        val icon = map["icon"] as String
        return ALIOTTHotlineConfig(id, key, name, icon)
    }

    public fun payloadForRequestShowCall(call: ALIOTTCall): Map<String, Any> {
        val map = mutableMapOf<String, Any>()

        val callData = mutableMapOf<String, Any>()
        callData.put("callerId", call.callerId)
        callData.put("callerAvatar", call.calleeAvatar)
        callData.put("calleeId", call.calleeId)
        callData.put("calleeAvatar", call.calleeAvatar)
        callData.put("calleeName", call.calleeName)

        val metadata = call.metadata
        if (metadata != null) {
            callData.put("metadata", hashMapToMap(metadata))
        }
        map.put("type", "aliottOnRequestShowCall")
        map.put("payload", callData)
        return map
    }
    public fun payloadForStartCallFailEvent(errorMessage: String): Map<String, Any> {
        val map = mutableMapOf<String, Any>()
        val payload = mutableMapOf<String, Any>()

        payload.put("errorMessage", errorMessage)
        map.put("type", "aliottOnInitFail")
        map.put("payload", payload)
        return map
    }
    public fun payloadForCallStateChangeEvent(callState: ALIOTTCallState): Map<String, Any> {
        val payload = mutableMapOf<String, Any>()
        when (callState) {
            ALIOTTCallState.PENDING -> payload["callState"] = "ALIOTTCallStatePending"
            ALIOTTCallState.CALLING -> payload["callState"] = "ALIOTTCallStateCalling"
            ALIOTTCallState.ACTIVE -> payload["callState"] = "ALIOTTCallStateActive"
            ALIOTTCallState.ENDED -> payload["callState"] = "ALIOTTCallStateEnded"
        }

        val map = mutableMapOf<String, Any>()
        map["type"] = "aliottOnCallStateChange"
        map["payload"] = payload
        return map
    }

    public fun payloadForConnectStateChangeEvent(connectedTime: Long): Map<String, Any> {
        val map = mutableMapOf<String, Any>()
        val payload = mutableMapOf<String, Any>()
        payload["connectedState"] = "ALIOTTConnectedStateComplete"

        payload["connectedDate"] = connectedTime

        map["type"] = "aliottOnCallConnectedChange"
        map["payload"] = payload

        return map
    }

    private fun hashMapToMap(map: HashMap<String, String>): Map<String, Any> {
        val result = mutableMapOf<String, Any>()
        for ((key, value) in map) {
            result[key] = value
        }
        return result
    }

}