package com.shivam.otp_pin_field

import android.app.Activity
import android.app.PendingIntent
import android.content.*
import android.os.Build
import android.os.Bundle
import android.telephony.TelephonyManager
import android.util.Log
import com.google.android.gms.auth.api.identity.GetPhoneNumberHintIntentRequest
import com.google.android.gms.auth.api.identity.Identity
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.auth.api.phone.SmsRetrieverClient
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import com.google.android.gms.tasks.OnFailureListener
import com.google.android.gms.tasks.OnSuccessListener
import com.google.android.gms.tasks.Task
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.lang.ref.WeakReference
import java.util.regex.Matcher
import java.util.regex.Pattern

class OtpPinFieldPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {
    private var activity: Activity? = null
    private var pendingHintResult: Result? = null
    private var channel: MethodChannel? = null
    private var broadcastReceiver: SmsBroadcastReceiver? = null
    private val activityResultListener = object : PluginRegistry.ActivityResultListener {
        override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
            try {
                if (requestCode == PHONE_HINT_REQUEST && pendingHintResult != null) {
                    if (resultCode == Activity.RESULT_OK && data != null) {
                        val phoneNumber = Identity.getSignInClient(activity!!).getPhoneNumberFromIntent(data)
                        pendingHintResult?.success(phoneNumber)
                    } else {
                        pendingHintResult?.success(null)
                    }
                    return true
                }
            } catch (e: Exception) {
                Log.e("Exception", e.toString())
            }
            return false
        }
    }

    fun setCode(code: String?) {
        channel?.invokeMethod("smsCode", code)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "requestPhoneHint" -> {
                pendingHintResult = result
                requestHint()
            }

            "listenForCode" -> {
                val smsCodeRegexPattern: String? = call.argument("smsCodeRegexPattern")
                val client: SmsRetrieverClient = SmsRetriever.getClient(activity!!)
                val task: Task<Void> = client.startSmsRetriever()

                task.addOnSuccessListener {
                    unregisterReceiver()
                    broadcastReceiver = SmsBroadcastReceiver(WeakReference(this@OtpPinFieldPlugin), smsCodeRegexPattern!!)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        activity?.registerReceiver(broadcastReceiver, IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION), Context.RECEIVER_EXPORTED)
                    } else {
                        activity?.registerReceiver(broadcastReceiver, IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION))
                    }
                    result.success(null)
                }

                task.addOnFailureListener {
                    result.error("ERROR_START_SMS_RETRIEVER", "Can't start SMS retriever", it)
                }
            }

            "unregisterListener" -> {
                unregisterReceiver()
                result.success("Successfully unregistered receiver")
            }

            "getAppSignature" -> {
                val signatureHelper = AppSignatureHelper(activity?.applicationContext)
                val appSignature: String = signatureHelper.appSignature
                result.success(appSignature)
            }

            else -> result.notImplemented()
        }
    }

    private fun requestHint() {
        if (!isSimSupport) {
            pendingHintResult?.success(null)
            return
        }

        val request = GetPhoneNumberHintIntentRequest.builder().build()
        Identity.getSignInClient(activity!!)
            .getPhoneNumberHintIntent(request)
            .addOnSuccessListener { pendingIntent ->
                try {
                    activity?.startIntentSenderForResult(pendingIntent!!.intentSender, PHONE_HINT_REQUEST, null, 0, 0, 0)
                } catch (e: Exception) {
                    e.printStackTrace()
                    pendingHintResult?.error("ERROR", e.message, e)
                }
            }
            .addOnFailureListener {
                it.printStackTrace()
                pendingHintResult?.error("ERROR", it.message, it)
            }
    }

    private val isSimSupport: Boolean
        get() {
            val telephonyManager = activity?.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            return telephonyManager.simState != TelephonyManager.SIM_STATE_ABSENT
        }

    private fun setupChannel(messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, channelName)
        channel?.setMethodCallHandler(this)
    }

    private fun unregisterReceiver() {
        broadcastReceiver?.let {
            try {
                activity?.unregisterReceiver(it)
            } catch (ex: Exception) {
                // Silent catch to avoid crash if receiver is not registered
            }
            broadcastReceiver = null
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        setupChannel(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        unregisterReceiver()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(activityResultListener)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        unregisterReceiver()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(activityResultListener)
    }

    override fun onDetachedFromActivity() {
        unregisterReceiver()
    }

    class SmsBroadcastReceiver(
        private val plugin: WeakReference<OtpPinFieldPlugin>,
        private val smsCodeRegexPattern: String
    ) : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent) {
            if (SmsRetriever.SMS_RETRIEVED_ACTION == intent.action) {
                plugin.get()?.let {
                    val extras = intent.extras
                    val status = extras?.get(SmsRetriever.EXTRA_STATUS) as? Status
                    if (status?.statusCode == CommonStatusCodes.SUCCESS) {
                        val message = extras.getString(SmsRetriever.EXTRA_SMS_MESSAGE) ?: ""
                        val pattern = Pattern.compile(smsCodeRegexPattern)
                        val matcher: Matcher = pattern.matcher(message)
                        if (matcher.find()) {
                            it.setCode(matcher.group(0))
                        } else {
                            it.setCode(message)
                        }
                    }
                }
            }
        }
    }

    companion object {
        private const val PHONE_HINT_REQUEST = 1112
        private const val channelName = "otp_pin_field"
    }
}
