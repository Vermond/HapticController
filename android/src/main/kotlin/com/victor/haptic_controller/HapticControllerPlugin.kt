package com.victor.haptic_controller

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** HapticControllerPlugin */
class HapticControllerPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var activity: Activity
  private lateinit var haptic: Haptic

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "haptic_controller")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    haptic = Haptic(context)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method) {
      "canHaptic" -> {
        result.success(haptic.canHaptic)
        Log.i("haptic_test", "result : ${haptic.canHaptic}")
      }
      "haptic" -> {
        haptic.haptic()
        result.success("")
        Log.i("haptic_test", "haptic")
      }
      "hapticPattern" -> {
        val argMap = call.arguments as? Map<String, Any>
        val delayTime = argMap?.get("delayTime") as? DoubleArray
        val duration = argMap?.get("duration") as? DoubleArray
        val intensities = argMap?.get("intensities") as? DoubleArray

        if (delayTime != null && duration != null && intensities != null) {
          haptic.hapticPattern(delayTime=delayTime, intensities=intensities, duration=duration)
          result.success("")
          Log.i("haptic_test", "haptic pattern success")
        } else {
          result.error("ParameterError", "Some parameter is null", null)
          Log.i("haptic_test", "haptic pattern failed")
        }
      }
      else -> {
        result.notImplemented()
        Log.i("haptic_test", "notImplemented")
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    //do nothing
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    //do nothing
  }
}
